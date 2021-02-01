/**
 *
 * Bestbuy autocomplete
 *
 */
"use strict";

const path = require("path");
const express = require("express");
const { Client } = require("@elastic/elasticsearch");

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const deployment_type = process.env.DEPLOYMENT_TYPE;
const es_index = "products";
const port = 80;
let es_address;
let es_port;
switch (deployment_type) {
  case "LOCAL":
    es_address = "localhost";
    es_port = "9200";
    break;
  case "DOCKER":
    es_address = "es-node1";
    es_port = "9200";
    break;
  case "ENV":
    es_address = process.env.ES_ADDRESS;
    es_port = process.env.ES_PORT;
    break;
}
// Client for elasticsearch node
//
const es_client = new Client({ node: `http://${es_address}:${es_port}` });

// Autocomplete endpoint
//
app.get("/search/:term?", async (req, res) => {
  let search_term = req.params.term;
  console.log(`GET /search/${search_term}`);
  es_client.search(
    // Query DSL
    {
      index: es_index,
      body: {
        query: {
          multi_match: {
            query: search_term,
            type: "bool_prefix",
            fields: ["name", "name._2gram", "name._3gram"],
          },
        },
      },
    },
    // Callback
    (err, result) => {
      if (err) {
        console.log(err);
        res.end();
      } else {
        console.log(`statusCode: ${result.statusCode}`);
        console.log(result.body.hits.total);
        res.set("Content-Type", "application/json");
        let hits = new Array();
        for (let hit of result.body.hits.hits) {
          hits.push(hit._source.name);
        }
        res.send(JSON.stringify(hits)); // Return an array of product names
      }
    }
  );
});

app.get("/ping", (req, res) => {
  res.send("ok");
});

// Serve static html and javascript
//
app.use(express.static(path.join(__dirname, "public")));

//Makes the app listen to port 3000
app.listen(port, () => console.log(`App listening to port ${port}`));
