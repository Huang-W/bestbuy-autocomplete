/**
 *
 * Bestbuy autocomplete
 *
 */
 'use strict';

const http = require('http');
const path = require('path');
const express = require('express');
const { Client } = require('@elastic/elasticsearch');

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const port = 3000;
const es_address = "localhost"
const es_port = "9200"
const es_index = "products"
const es_client = new Client({ node: `http://${es_address}:${es_port}` })

// Routes
app.get('/search/:term?', async (req, res) => {
  let search_term = req.params.term;
  console.log(`GET /search/${search_term}`);
  es_client.search({
    index: es_index,
    body: {
      query: {
        multi_match: {
          query: search_term,
          type: "bool_prefix",
          fields: ["name", "name._2gram", "name._3gram"]
        }
      }
    }
  }, (err, result) => {
    if (err) {
      console.log(err);
      res.end();
    }
    else {
      console.log(`statusCode: ${result.statusCode}`);
      console.log(result.body.hits.total);
      res.set('Content-Type', 'application/json');
      let hits = new Array();
      for (let hit of result.body.hits.hits) {
        hits.push(hit._source.name);
      }
      res.send(JSON.stringify(hits));
    }
  });
});
app.use(express.static(path.join(__dirname, 'public')));

//Makes the app listen to port 3000
app.listen(port, () => console.log(`App listening to port ${port}`));
