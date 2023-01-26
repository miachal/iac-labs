terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.24.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_tag" "tag_76179" {
  source_image = docker_image.nginx.image_id
  target_image = "wsb/iac-labs-nginx:1.0"
}

resource "docker_container" "nginx" {
  image = docker_tag.tag_76179.source_image_id
  name  = "tutorial"
  ports {
    internal = 80
    external = 8080
  }
}
