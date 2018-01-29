#!/bin/bash
# START - Configuration
DRIVE_TO_MOUNT=( 'DriveOne' 'DriveTwo' )
DRIVE_IP_ADDRESS=( 'IpOne' 'IpTwo' )
PATH_WHERE_MOUNT=( 'mountPathOne' 'mountPathTwo' )
MOUNT_TYPE=( 'mountTypeONe' 'mountTypeTwo' )
MOUNT_OPTIONS=( 'mountOptsOne' 'mountOptsTwo' )

MAX_ATTEMPS=30
SLEEP_SECOND=5
# END - Configuration

# ========================================================================================================================
# ========================================================================================================================
# ========================================================================================================================

# START - Check that the size of the arrays is the same
COUNT_DRIVE_TO_MOUNT=${#DRIVE_TO_MOUNT[@]}
COUNT_DRIVE_IP_ADDRESS=${#DRIVE_IP_ADDRESS[@]}
COUNT_PATH_WHERE_MOUNT=${#PATH_WHERE_MOUNT[@]}
COUNT_MOUNT_TYPE=${#MOUNT_TYPE[@]}

echo "Verify configuration..."
if [ "$COUNT_DRIVE_TO_MOUNT" != "$COUNT_DRIVE_IP_ADDRESS" ] ||
   [ "$COUNT_DRIVE_IP_ADDRESS" != "$COUNT_PATH_WHERE_MOUNT" ] ||
   [ "$COUNT_PATH_WHERE_MOUNT" != "$COUNT_MOUNT_TYPE" ];
then
  echo 'Invalid configuration...!'
  exit
fi
echo "[OK] Configuration are valid!"
# END - Check that the size of the arrays is the same

# START - Verify that the all value of PATH_WHERE_MOUNT array exist
echo "Verify mount path..."
for currentPath in "${PATH_WHERE_MOUNT[@]}"
do
  if [ ! -d "$currentPath" ]; then
    echo "Directory '$currentPath' not exist!!"
    echo "Please, create the missing folder and restart the script!"
    exit
  fi
done
echo "[OK] Mount path are valid!"
# END - Verify that the all value of PATH_WHERE_MOUNT array exist

# START - Verify the availability of the network drive
ARRAY_INDEX=0
for currentIpAddress in "${DRIVE_IP_ADDRESS[@]}"
do
  echo "===== ===== ===== ===== ===== ===== ===== ===== ===== ====="
  # START - Verify if the current Drive is already mounted
  if mount | grep "//${DRIVE_IP_ADDRESS[$ARRAY_INDEX]}/${DRIVE_TO_MOUNT[$ARRAY_INDEX]}" > /dev/null; then
    echo "Current Drive is already mounted! Skip to next drive..."
  else
    echo "Starting MOUNT operations for drive '${DRIVE_TO_MOUNT[$ARRAY_INDEX]}'"
    echo "Verify connection availability of '$currentIpAddress'..."

    ((ATTEMPT_INDEX = 1))
    while [[ "$ATTEMPT_INDEX" -le "$MAX_ATTEMPS" ]];
    do
      echo "Try to ping $currentIpAddress [$ATTEMPT_INDEX of $MAX_ATTEMPS]..."
      if ping -q -c 4 -W 1 $currentIpAddress > /dev/null; then
        echo "[OK] '$currentIpAddress' are available!!!"

        echo "Now try to MOUNT the drive..."
        MOUNT_COMMAND="sudo mount -t ${MOUNT_TYPE[$ARRAY_INDEX]} -o ${MOUNT_OPTIONS[$ARRAY_INDEX]} //${DRIVE_IP_ADDRESS[$ARRAY_INDEX]}/${DRIVE_TO_MOUNT[$ARRAY_INDEX]} ${PATH_WHERE_MOUNT[$ARRAY_INDEX]}"

        echo `$MOUNT_COMMAND`

        break
      else
        echo "[KO] '$currentIpAddress' NOT available..."

        if [[ "$ATTEMPT_INDEX" -ne "$MAX_ATTEMPS" ]]; then
          echo "...sleep $SLEEP_SECOND seconds..."

          SLEEP_COMMAND="sleep $SLEEP_SECOND"
          echo `$SLEEP_COMMAND`
        else
          echo "[KO] Drive IP Address not available. Skip to next Drive!!"
        fi
      fi

      ((ATTEMPT_INDEX = ATTEMPT_INDEX + 1))
    done # while [[ "$ATTEMPT_INDEX" -ne "$MAX_ATTEMPS" ]];
  fi
  ((ARRAY_INDEX = ARRAY_INDEX + 1))
done # for currentIpAddress in "${DRIVE_IP_ADDRESS[@]}"
# END - Verify the availability of the network drive

echo 'End script!! Bye bye...'
