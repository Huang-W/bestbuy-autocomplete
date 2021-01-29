package main

import (
	"bufio"
	"bytes"
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"math/rand"
	"os"
	"runtime"
	"strings"
	"sync/atomic"
	"time"

	"github.com/cenkalti/backoff/v4"
	"github.com/dustin/go-humanize"

	"github.com/elastic/go-elasticsearch/v8"
	"github.com/elastic/go-elasticsearch/v8/esapi"
	"github.com/elastic/go-elasticsearch/v8/esutil"
)

type Product struct {
	Sku          int         `json:"sku"`
	Name         string      `json:"name"`
	Type         string      `json:"type"`
	Price        float32     `json:"price"`
	Upc          string      `json:"upc"`
	Categories   []Category  `json:"category"`
	Shipping     interface{} `json:"shipping"`
	Description  string      `json:"description"`
	Manufacturer string      `json:"manufacturer"`
	Model        string      `json:"model"`
	Url          string      `json:"url"`
	Image        string      `jons:"image"`
}

type Category struct {
	Id   string `json:"id"`
	Name string `json:"name"`
}

var (
	// batch int
	indexFile  string
	indexName  string
	indexDocs  string
	elasticAddress string
	numWorkers int
	flushBytes int
	numItems   int
)

func init() {
	flag.StringVar(&indexName, "name", "products", "Index name")
	flag.StringVar(&indexFile, "def", "search/idx_products.json", "Create the index using this file")
	flag.StringVar(&indexDocs, "docs", "data/products.json", "JSON file of documents to insert")
	flag.StringVar(&elasticAddress, "addr", "http://localhost:9200", "elasticsearch server - {protocol}://{hostname}:{port}")
	flag.IntVar(&numWorkers, "workers", runtime.NumCPU(), "Number of indexer workers")
	flag.IntVar(&flushBytes, "flush", 1e+6, "Flush threshold in bytes")
	flag.Parse()

	rand.Seed(time.Now().UnixNano())
}

func main() {
	log.SetFlags(0)

	var (
		countSuccessful uint64
		res             *esapi.Response
		err             error
	)

	log.Printf(
		"\x1b[1mBulkIndexer\x1b[0m: workers [%d] flush [%s]",
		numWorkers, humanize.Bytes(uint64(flushBytes)))
	log.Println(strings.Repeat("▁", 65))

	// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	//
	// Use a third-party package for implementing the backoff function
	//
	retryBackoff := backoff.NewExponentialBackOff()
	// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	//
	// Create the Elasticsearch client
	//
	// NOTE: For optimal performance, consider using a third-party HTTP transport package.
	//       See an example in the "benchmarks" folder.
	//
	es, err := elasticsearch.NewClient(elasticsearch.Config{
		Addresses: []string{elasticAddress},
		// Retry on 429 TooManyRequests statuses
		//
		RetryOnStatus: []int{502, 503, 504, 429},

		// Configure the backoff function
		//
		RetryBackoff: func(i int) time.Duration {
			if i == 1 {
				retryBackoff.Reset()
			}
			return retryBackoff.NextBackOff()
		},

		// Retry up to 5 attempts
		//
		MaxRetries: 5,
	})
	FailOnError(err, "Error creating the elasticsearch client")
	// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	//
	// Create the BulkIndexer
	//
	// NOTE: For optimal performance, consider using a third-party JSON decoding package.
	//       See an example in the "benchmarks" folder.
	//
	bi, err := esutil.NewBulkIndexer(esutil.BulkIndexerConfig{
		Index:         indexName,        // The default index name
		Client:        es,               // The Elasticsearch client
		NumWorkers:    numWorkers,       // The number of worker goroutines
		FlushBytes:    int(flushBytes),  // The flush threshold in bytes
		FlushInterval: 30 * time.Second, // The periodic flush interval
	})
	FailOnError(err, "Error creating the indexer")
	// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	// Delete the index
	//
	res, err = es.Indices.Delete([]string{indexName})
	FailOnError(err, fmt.Sprintf("Cannot delete index: %s", indexName))
	res.Body.Close()

	// (Re)create the index
	//
	f1, err := os.Open(indexFile)
	FailOnError(err, "unable to open index definition")
	defer f1.Close()
	r1 := bufio.NewReader(f1)
	res, err = es.Indices.Create(indexName, es.Indices.Create.WithBody(r1))
	FailOnError(err, "Cannot create index")
	if res.IsError() {
		log.Fatalf("Cannot create index: %s", res)
	}
	res.Body.Close()

	// BestBuy products dataset
	// https://github.com/BestBuyAPIs/open-data-set
	//
	f2, err := os.Open(indexDocs)
	FailOnError(err, "unable to open product data")
	defer f2.Close()

	r2 := bufio.NewReader(f2)
	dec := json.NewDecoder(r2)

	start := time.Now().UTC()

	// read open bracket
	//
	t, err := dec.Token()
	FailOnError(err, fmt.Sprintf("Unable to read token %T: %v\n", t, t))

	// Loop over the collection
	//
	numItems = 0
	for dec.More() {
		numItems++
		// decode an array value (Product)
		// might need to decode into "interface{}" instead of "Product"
		//
		var p Product
		err = dec.Decode(&p)
		FailOnError(err, "Unable to decode")

		// Prepare the data payload: encode article to JSON
		//
		data, err := json.Marshal(p)
		FailOnError(err, fmt.Sprintf("Cannot encode article %d", numItems))

		// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		//
		// Add an item to the BulkIndexer
		//
		err = bi.Add(
			context.Background(),
			esutil.BulkIndexerItem{
				// Action field configures the operation to perform (index, create, delete, update)
				Action: "index",

				// Body is an `io.Reader` with the payload
				Body: bytes.NewReader(data),

				// OnSuccess is called for each successful operation
				OnSuccess: func(ctx context.Context, item esutil.BulkIndexerItem, res esutil.BulkIndexerResponseItem) {
					atomic.AddUint64(&countSuccessful, 1)
				},

				// OnFailure is called for each failed operation
				OnFailure: func(ctx context.Context, item esutil.BulkIndexerItem, res esutil.BulkIndexerResponseItem, err error) {
					if err != nil {
						log.Printf("ERROR: %s", err)
					} else {
						log.Printf("ERROR: %s: %s", res.Error.Type, res.Error.Reason)
					}
				},
			},
		)
		FailOnError(err, "Unexpected error")
		// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	}

	// read closing bracket
	//
	t, err = dec.Token()
	FailOnError(err, fmt.Sprintf("Unable to read token %T: %v\n", t, t))

	// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	// Close the indexer
	//
	if err := bi.Close(context.Background()); err != nil {
		log.Fatalf("Unexpected error: %s", err)
	}
	// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	biStats := bi.Stats()

	// Report the results: number of indexed docs, number of errors, duration, indexing rate
	//
	log.Println(strings.Repeat("▔", 65))

	dur := time.Since(start)

	if biStats.NumFailed > 0 {
		log.Fatalf(
			"Indexed [%s] documents with [%s] errors in %s (%s docs/sec)",
			humanize.Comma(int64(biStats.NumFlushed)),
			humanize.Comma(int64(biStats.NumFailed)),
			dur.Truncate(time.Millisecond),
			humanize.Comma(int64(1000.0/float64(dur/time.Millisecond)*float64(biStats.NumFlushed))),
		)
	} else {
		log.Printf(
			"Sucessfuly indexed [%s] documents in %s (%s docs/sec)",
			humanize.Comma(int64(biStats.NumFlushed)),
			dur.Truncate(time.Millisecond),
			humanize.Comma(int64(1000.0/float64(dur/time.Millisecond)*float64(biStats.NumFlushed))),
		)
	}
}

// Helper Functions
func FailOnError(err error, msg string) {
	if err != nil {
		log.Fatalf("%s: %s", msg, err)
		panic(fmt.Sprintf("%s: %s", msg, err))
	}
}

func WarnOnError(err error, msg string) {
	if err != nil {
		log.Println("%s: %s", msg, err)
	}
}
