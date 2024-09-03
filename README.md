# move-d
Bash script to recursively copy newly created or modified files from the current local directory to a remote host:/directory using rsync.

## Usage
### Requirements
Make sure you have have the following dependencies installed: curl, find, rsync <br>
You will also need to have a passwordless SSH key set up for the remote host. <br>
<b>NOTE:</b> Depending on your situation, this could be a serious security concern. You may want to set up a limited user specifically for file transfers on the remote host.

### Usage Steps
- Change directory to the source directory (Top level of the directory(s) you want to sync files from): ```cd /source/directory```
- Use curl to download the script: ```curl https://raw.githubusercontent.com/patrickramp/move-d/main/move-d.sh -o move-d.sh```
- Configure variables inside the script (See Configuration Variables section below): ```nano move-d.sh```
- Make script executable: ```chmod +x move-d.sh``` 
- Run script: ```./move-d.sh```

### Usage Notes
- To run script in persistently in the background: ```nohup ./move-d.sh > /dev/null 2>&1 &```
- To check the script is running: ```ps aux | grep move-d.sh``` 
- To kill script: ```pkill -f move-d.sh``` 

### Configuration Variables
Use your text editor of choice to edit the following variables inside move-d.sh. These variables <b>MUST</b> must be changed to suit your use case:
- TARGET_HOST="user@host:/target/directory"  # Remote User, Target host, and directory
- TIMESTAMP_FILE="/tmp/move-d.ts"            # Temp. file to store last sync timestamp
- SSH_KEY="/path/to/ssh/key"                 # Path to your SSH private key (no passphrase)
- SSH_PORT=22                                # Custom SSH port (e.g. 2222)
- SLEEP_INTERVAL=10                          # Time interval between checks (in seconds)

