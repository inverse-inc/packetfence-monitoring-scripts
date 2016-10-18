# packetfence-monitoring-scripts

## How to add a script

First create a file with the right shebang so it can be executed on remote systems. You also need to add the '#fname' header which will determine the filename the script will have on the remote system.

```
#!/bin/bash
#fname:check-something.sh

if [ 1 -eq 0 ]; then
  echo "1 is not equal to 0. Something must be up"
  exit 1
fi
```

Then, you need to add it to `monit-script-registry.txt` so its part of the scripts that are pulled down on the remote systems.

The rest is magic
