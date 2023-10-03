resource "shoreline_notebook" "troubleshooting_compaction_merging_sstables_in_cassandra" {
  name       = "troubleshooting_compaction_merging_sstables_in_cassandra"
  data       = file("${path.module}/data/troubleshooting_compaction_merging_sstables_in_cassandra.json")
  depends_on = [shoreline_action.invoke_disk_space_check]
}

resource "shoreline_file" "disk_space_check" {
  name             = "disk_space_check"
  input_file       = "${path.module}/data/disk_space_check.sh"
  md5              = filemd5("${path.module}/data/disk_space_check.sh")
  description      = "Check for available disk space on all the nodes in the Cassandra cluster. If there is insufficient disk space available, add more storage capacity or remove unnecessary data to free up space."
  destination_path = "/agent/scripts/disk_space_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_disk_space_check" {
  name        = "invoke_disk_space_check"
  description = "Check for available disk space on all the nodes in the Cassandra cluster. If there is insufficient disk space available, add more storage capacity or remove unnecessary data to free up space."
  command     = "`chmod +x /agent/scripts/disk_space_check.sh && /agent/scripts/disk_space_check.sh`"
  params      = ["THRESHOLD","NODE3_IP","NODE1_IP","NODE2_IP","USERNAME"]
  file_deps   = ["disk_space_check"]
  enabled     = true
  depends_on  = [shoreline_file.disk_space_check]
}

