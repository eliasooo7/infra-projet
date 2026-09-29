terraform {
  required_providers {
    null = { source = "hashicorp/null", version = "~> 3.2" }
  }
}

variable "app_version" {
  type    = string
  default = "1.0"
}

variable "app_port" {
  type    = string
  default = "8081"
}

resource "null_resource" "app" {
  # Redeploie si la version, le port ou le script change
  triggers = {
    version = var.app_version
    port    = var.app_port
    script  = filesha256("${path.module}/../../scripts/deploy.sh")
    root    = abspath("${path.module}/../..")
  }

  provisioner "local-exec" {
    command     = "./scripts/deploy.sh ${self.triggers.version} ${self.triggers.port}"
    working_dir = self.triggers.root
    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "./scripts/teardown.sh tp3-mon-app"
    working_dir = self.triggers.root
    interpreter = ["bash", "-c"]
  }
}
