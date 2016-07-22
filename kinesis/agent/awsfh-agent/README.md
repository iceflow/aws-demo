# Getting the Streaming Data Agent
The agent is currently shared on S3:
- Bucket Name: streaming-data-agent
- Object: awsfh-agent-latest.zip

To download the agent, use the S3Browser tool or use AWS Command Line command:

```
aws s3 cp s3://streaming-data-agent/awsfh-agent-latest.zip .
```

After unzipping an install script (`install-agent`) and a directory named `awsfh-agent` will appear.

# Installing Streaming Data Agent
To install the agent, type the command:

```sh
sudo ./install-agent [target-dir]
```

`target-dir` is where you want the agent to be installed. The default directory is `/var/run`.

# Configuring and starting Streaming Data Agent
Once the agent is installed, the configuration file can be found in `/etc/awsfh/agent.json`. You will need to modify this configuration file to set the data destinations, AWS credentials, and point the agent to the files you want to push. After you complete the configuration, you can make the agent automatically start at system startup by typing:

```sh
sudo chkconfig awsfh-agent on
```

If you do not want the agent running at system startup, you can also turn it off by running:

```sh
sudo chkconfig awsfh-agent off
```

To start the agent manually, type the command:

```sh
sudo service awsfh-agent start
```

You can check the status to make sure the agent is running by running:

```sh
sudo service awsfh-agent status
```

You will see messages like `awsfh-agent (pid [PID]) is running...`

To stop the agent, type the command:

```sh
sudo service awsfh-agent stop
```

# Viewing Agent's Log File
The agent writes its logs to `/var/log/awsfh-agent.log`

# Generating Test Logs
The script `awsfh-agent/generate-rotating-log` is included to generate a rotating log file for testing purposes. The script can be used according to this synopsis:

```
awsfh-agent/generate-rotating-log --throughput-bytes TARGET_BYTES_PER_SECOND [--rotate-interval ROTATE_INTERVAL_SECONDS] FILENAME

Generate a rotating log file with random data.

positional arguments:
  FILENAME              the file to append log records to

optional arguments:
  --throughput-bytes TARGET_BYTES_PER_SECOND
                        Target throughput in bytes per second.
  --rotate-interval ROTATE_INTERVAL_SECONDS
                        the interval, in seconds, that would trigger the log
                        file to rotate. Default: 3600 (1 hour).
```

For example, to generate a file that rotates hourly in the directory `/tmp` with a file name prefix of `app.log` and a throughput of 100MB/hour (~ 30,000 B/second), you could invoke the script as follows:

```sh
awsfh-agent/generate-rotating-log --throughput-bytes 30000 --rotate-interval 3600 /tmp/app.log
```

This would start writing log record to the specified file, and will rotate the file every hour. You can also run `awsfh-agent/generate-rotating-log --help` to see all available options.

# Uninstalling Streaming Data Agent
To uninstall the agent, type the command:

```sh
sudo awsfh-agent/install-agent --uninstall [target-dir]
```

`target-dir` is where the agent was installed (default is `/var/run`).
