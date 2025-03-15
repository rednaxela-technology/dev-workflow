terraform {
    backend "remote" {
        organization = "rednaxela"

        # The name of the Terraform Cloud workspace to store Terraform state files in.
        workspaces {
          name = "dev-workflow"
        }
      }
    

      # You need to specify required providers block
      required_providers {
        null = {
          source = "hashicorp/null"
          version = "~> 3.0"  # Specify a version constraint
        }
      }
    }

    # An example resource that does nothing.
    resource "null_resource" "example" {
      triggers = {
        value = "A example resource that does nothing!"
      }
    }


