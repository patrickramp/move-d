# move-d
Bash script to recursively copy newly created or modified files from the current local directory to a remote host:/directory using rsync.

## Usage
### Requirements
Make sure you have have the following dependencies installed: curl, find, rsync <br>
You will also need to have a password-less SSH key set up for the remote host. <br>
<b>NOTE:</b> Depending on your situation, this could be a serious security concern. You may want to set up a limited user specifically for file transfers on the remote host.

### Usage Steps
- Use curl to download the script: ```curl https://raw.githubusercontent.com/patrickramp/move-d/main/move-d.sh -o move-d.sh```
- Configure variables inside the script (See Configuration Variables section below): ```nano move-d.sh```
- Make script executable: ```chmod +x move-d.sh``` 
- Move script to desired location: ```mv move-d.sh ~/.local/bin/```
- Run script: ```~/.local/bin/move-d.sh```

### Usage Notes
- To run script in persistently in the background: ```nohup ~/.local/bin/move-d.sh > /dev/null 2>&1 &```
- To check the script is running: ```ps aux | grep move-d.sh``` 
- To kill script: ```pkill -f move-d.sh``` 

### Configuration Variables
Use your text editor of choice to edit the following variables inside move-d.sh. These variables <b>MUST</b> must be changed to suit your use case:
- SOURCE_DIR="/source/directory"             # Source directory to watch for new files
- TARGET_HOST="user@host:/target/directory"  # Remote user, host, and target directory to copy to
- TIMESTAMP_FILE="/tmp/move-d.ts"            # Temporary file to store last sync time stamp
- SSH_KEY="/path/to/ssh/key"                 # Path to your SSH private key (no pass-phrase)
- SSH_PORT=22                                # Custom SSH port (e.g. 2222)
- SLEEP_INTERVAL=10                          # Time interval between checks (in seconds)

