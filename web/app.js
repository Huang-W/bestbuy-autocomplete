/**
 *
 * Bestbuy autocomplete
 *
 */
"use strict";

const path = require("path");
const express = require("express");
const Redis = require("ioredis");
const { Client } = require("@elastic/elasticsearch");

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const deployment_type = process.env.DEPLOYMENT_TYPE
  ? process.env.DEPLOYMENT_TYPE
  : "LOCAL";
const elasticsearch_index = "products";

// connection details
let web_port;
let elasticsearch_address;
let elasticsearch_port;
let redis_address;
let redis_port;

// feature toggle
let redis_caching_enabled;
let return_url_along_with_product;

switch (deployment_type) {
  case "LOCAL":
    web_port = "3000";
    elasticsearch_address = "localhost";
    elasticsearch_port = "9200";
    redis_address = "localhost";
    redis_port = "6379";
    redis_caching_enabled = "off";
    return_url_along_with_product = "off";
    break;
  case "DOCKER":
    web_port = "3000";
    elasticsearch_address = "es-node1";
    elasticsearch_port = "9200";
    redis_address = "redis-node1";
    redis_port = "6379";
    redis_caching_enabled = "off";
    return_url_along_with_product = "off";
    break;
  case "ENV":
    web_port = process.env.WEB_PORT;
    elasticsearch_address = process.env.ELASTICSEARCH_ADDRESS;
    elasticsearch_port = process.env.ELASTICSEARCH_PORT;
    redis_address = process.env.REDIS_ADDRESS;
    redis_port = process.env.REDIS_PORT;
    redis_caching_enabled = process.env.REDIS_CACHING_ENABLED;
    return_url_along_with_product = process.env.RETURN_URL_ALONG_WITH_PRODUCT;
    break;
}

let elasticsearch_client;
let redis_client;

// Client for elasticsearch node
elasticsearch_client = new Client({
  node: `http://${elasticsearch_address}:${elasticsearch_port}`,
  maxRetries: 3,
  requestTimeout: 1000,
});

// Redis client
if (redis_caching_enabled == "on") {
  redis_client = new Redis.Cluster([
    {
      port: redis_port,
      host: redis_address,
    },
  ]);
}

// elasticsearch queries
app.get("/search/:term?", async (req, res) => {
  res.set("Content-Type", "application/json");

  let json_response_string = null;
  let term_exists_as_key = false;

  if (redis_caching_enabled == "on") {
    await redis_client
      .get(req.params.term)
      .then(function (reply) {
        if (reply !== null) {
          term_exists_as_key = true;
        }
        json_response_string = reply; // is null if entry not found
      })
      .catch(function (error) {
        console.log(error);
      });
  }

  // cache miss or caching not enabled
  if (json_response_string === null) {
    await elasticsearch_client
      .search({
        index: elasticsearch_index,
        body: {
          query: {
            multi_match: {
              query: req.params.term,
              type: "bool_prefix",
              fields: ["name", "name._2gram", "name._3gram"],
            },
          },
        },
      })
      .then((result) => {
        let hits = new Array();

        for (let hit of result.body.hits.hits) {
          if (return_url_along_with_product == "on") {
            hits.push({
              name: hit._source.name,
              url: hit._source.url,
            });
          } else {
            hits.push(hit._source.name);
          }
        }

        json_response_string = JSON.stringify(hits);
      })
      .catch((error) => {
        res.status(404).send(JSON.stringify(new Array()));
        res.end();
      });
  }

  if (redis_caching_enabled == "on" && term_exists_as_key == false) {
    // expire in 2 minutes
    redis_client.setex(
      req.params.term,
      120,
      json_response_string,
      function (error, _) {
        if (error) {
          console.log(error);
        }
      }
    );
  }

  // An array of product names ( may return empty array )
  res.send(json_response_string);
  res.end();
});

app.get("/ping", (req, res) => {
  res.set("Content-Type", "text/plain").send("ok");
});

// Static html and javascript
app.use(express.static(path.join(__dirname, "public")));

// Listen on this port
app.listen(web_port, () => console.log(`App listening to port ${web_port}`));

module.exports = app;
