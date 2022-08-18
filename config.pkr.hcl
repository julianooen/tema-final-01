packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = "ubuntu:20.04"
  commit = true
  changes = [
      "EXPOSE 8383",
      "ENTRYPOINT [\"java\", \"-jar\", \"/financial.jar\"]"
    ]
}

build {
  name = "job2"
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
    source = "./build/libs/financial.jar"
    destination = "/financial.jar"
  }
  
  provisioner "ansible-local" {
     playbook_file = "./playbook.yml"
  }
  
  post-processors {
    post-processor "docker-tag" {
        repository =  "julianooen/financial-app"
      }
    post-processor "docker-push" {
        login = true
        login_username = "julianooen"
        login_password = "dckr_pat_RFy0qjt-fAJQatb3AFGWlEhjl6c"
    }
  }
}