
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Troubleshooting Compaction Merging SSTables in Cassandra
---

Compaction is a process in Cassandra that merges multiple SSTables (Sorted String Tables) into a single SSTable, eliminating any redundant data and improving read performance. However, sometimes compaction can fail due to various reasons such as insufficient disk space or corrupted data, resulting in degraded performance or even complete failure of the database. Troubleshooting compaction merging SSTables involves identifying and resolving the root cause of such failures to ensure the smooth functioning of the Cassandra database.

### Parameters
```shell
export DATA_DIRECTORY="PLACEHOLDER"

export CASSANDRA_LOG_FILE="PLACEHOLDER"

export THRESHOLD="PLACEHOLDER"

export NODE1_IP="PLACEHOLDER"

export NODE2_IP="PLACEHOLDER"

export NODE3_IP="PLACEHOLDER"

export NODES[@]="PLACEHOLDER"

export USERNAME="PLACEHOLDER"
```

## Debug

### Check the size of the SSTables in the data directory
```shell
du -h ${DATA_DIRECTORY}
```

### Check if disk space is running low
```shell
df -h
```

### Check the Cassandra log files for any compaction-related errors
```shell
tail -f ${CASSANDRA_LOG_FILE}
```

### Display the compaction history using nodetool.
```shell
nodetool compactionhistory
```

### Check the current compaction throughput using nodetool.
```shell
nodetool getcompactionthroughput
```

### Check the status of running compaction
```shell
nodetool compactionstats
```

### Stop any running compaction
```shell
nodetool stop COMPACTION
```

### Check for any corrupted SSTables
```shell
nodetool verify
```

### Repair any corrupted SSTables
```shell
nodetool repair
```

### Restart the compaction process
```shell
nodetool compact
```

### Check the status of the repaired SSTables
```shell
nodetool status
```

### Monitor compaction progress
```shell
nodetool compactionstats
```

## Repair

### Check for available disk space on all the nodes in the Cassandra cluster. If there is insufficient disk space available, add more storage capacity or remove unnecessary data to free up space.
```shell
bash

#!/bin/bash



# Set the threshold for minimum free disk space in GB

THRESHOLD=${THRESHOLD}



# Array of Cassandra node IP addresses

NODES=(${NODE1_IP} ${NODE2_IP} ${NODE3_IP})



for node in "${NODES[@]}"

do

  # Check the available disk space on each node

  free_space=$(ssh ${USERNAME}@$node "df -BG /dev/mapper/data | awk 'NR==2 {print \$4}' | tr -d 'G'")



  # Compare the available disk space with the threshold

  if [ $free_space -lt $THRESHOLD ]

  then

    # Alert if there is insufficient disk space

    echo "Warning: Node $node has only $free_space GB of free disk space."

  fi

done


```