terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.8.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "private_network" {
  name = "bestbuy_autocomplete"
}

resource "docker_image" "elasticsearch" {
  name         = "docker.elastic.co/elasticsearch/elasticsearch:7.10.1"
  keep_locally = true
}

resource "docker_image" "webserver" {
  name         = "bestbuy-web"
  keep_locally = true
  build {
    path = "./web"
  }
}

resource "docker_container" "elasticsearch" {
  image = docker_image.elasticsearch.latest
  name  = "es-node1"
  env   = ["discovery.type=single-node"]
  networks_advanced {
    name = docker_network.private_network.name
  }
  ports {
    internal = 9200
    external = 9200
  }
  ports {
    internal = 9300
    external = 9300
  }
}

resource "docker_container" "webserver" {
  image = docker_image.webserver.latest
  name  = "bestbuy-web"
  env   = ["DEPLOYMENT_TYPE=DOCKER"]
  networks_advanced {
    name = docker_network.private_network.name
  }
  ports {
    internal = 3000
    external = 3000
  }
}
