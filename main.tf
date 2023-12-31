terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "troubleshooting_compaction_merging_sstables_in_cassandra" {
  source    = "./modules/troubleshooting_compaction_merging_sstables_in_cassandra"

  providers = {
    shoreline = shoreline
  }
}