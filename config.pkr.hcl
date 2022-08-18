packer {
  required_plugins {
    docker = {
      version = ">= 1.0.1"
      source = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = "ubuntu:22.04"
  commit = true
  changes = [
      "EXPOSE 8383",
      "ENTRYPOINT [\"java\", \"-jar\", \"/financial.jar\"]"
    ]
}

variable "username" {
  type = string
  default = ""
}

variable "password" {
  type = string
  default = ""
}

build {
  name = "Job2"
  sources = [
    "source.docker.ubuntu"
  ]
  
  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get install ansible -y"
    ]
  }
  
  provisioner "file" {
    source = "./financial.jar"
    destination = "/financial.jar"
  }
  
  provisioner "ansible-local" {
     playbook_file = "./playbook.yml"
  }
  
  post-processors {
    post-processor "docker-tag" {
        repository =  "julianooen/financial-app"
        tags = ["0.1"]
    }
    post-processor "docker-push" {
        login = true
        login_username = "julianooen@hotmail.com"
        login_password = "dckr_pat_RFy0qjt-fAJQatb3AFGWlEhjl6c"
    }
  }
}