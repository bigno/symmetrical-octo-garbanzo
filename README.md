# waitnetmnt
Bash script for automatic mount of a network disk when connection are available.

### Main features
- Check if the disk is already mounted
- Check if the path where the mount will be mounted exists
- Check that the server (where the disk is exposed, i.e. via samba protocol) is available


### Configurations
- `DRIVE_TO_MOUNT`: This variable is an array that must contains the name(s) of the exposed "network drive(s)" that we desire to mount.
- `DRIVE_IP_ADDRESS`: This variable is an array that must contains the IP address of the exposed "network drive(s)" that we desire to mount.
- `PATH_WHERE_MOUNT`: This variable is an array that must contains the "absolute mount path(s)" that we desire to mount.
- `MOUNT_TYPE`: This variable is an array that must define the "mount type" that will be used in the `-t` option of `mount` command.
- `MOUNT_OPTIONS`: This variable is an array that must define the "mount options" that will be used in the `-o` option of `mount` command.
- `MAX_ATTEMPS`: This variable is an integer value that define the maximum number of `ping` attempts the script will make before considering as "_unavailable_" IP address.
- `SLEEP_SECOND`: This variable is an integer value that define the number of seconds that the script waits between a ping attempt and another.

### Suggested use
The script can be used via crontab.

### Tested environment
The script has been successfully tested on the following environments:
- Raspberry Pi 3 with _**Raspbian**_ Stretch distro.
