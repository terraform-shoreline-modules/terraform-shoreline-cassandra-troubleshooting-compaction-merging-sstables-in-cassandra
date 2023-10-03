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