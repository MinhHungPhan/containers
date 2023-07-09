
# Fluentd Installation on Ubuntu

This guide will walk you through the steps to install Fluentd on Ubuntu.

## Table of Contents

- [Introduction](#introduction)
- [Installation Steps](#installation-steps)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Fluentd is an open-source data collection tool designed to unify the logging infrastructure. It serves as a data pipeline, collecting, filtering, and forwarding log data from various sources to multiple destinations. Fluentd is written in Ruby and provides a flexible and extensible architecture that allows it to handle large-scale log collection and processing.

## Installation Steps

1. Update Package Manager:

```bash
sudo apt update
```

2. Install Ruby and Rubygems:

```bash
sudo apt install ruby ruby-dev build-essential
```

3. Install Fluentd:

```bash
gem install fluentd
```

4. Configure Fluentd:

- Open the main configuration file for Fluentd:

```bash
sudo mkdir -p /etc/fluentd/
sudo vi /etc/fluentd/fluent.conf
```

- Edit the configuration file to define input sources, output destinations, and filters according to your requirements.

```bash
<source>
  type tail
  format none
  path /var/log/input/1.log
  pos_file /var/log/input/1.log.pos
  tag count.format1
</source>

<match **>
  @type file
  path /var/log/output/count
  time_slice_format %Y%m%d%H%M%S
  flush_interval 5s
  log_level trace
</match>
```

- Save the configuration file and exit the editor.

5. Start Fluentd Service:

```bash
fluentd -c /etc/fluentd/fluent.conf
```

6. Verify the Installation:

- Check the Fluentd process:

```bash
ps aux | grep fluentd
```

- Confirm that the Fluentd process is running without any errors.

7. Create an `output` directory:

```bash
sudo mkdir -p /etc/fluentd/output
```

## Relevant Documentation

- [Fluentd Documentation](https://docs.fluentd.org/)
- [Fluentd GitHub Repository](https://github.com/fluent/fluentd)
- [Install by Ruby Gem](https://docs.fluentd.org/installation/install-by-gem)

## Conclusion

Congratulations! You have successfully installed Fluentd on your Ubuntu server. Fluentd is now ready to collect, process, and forward logs from various sources to your desired destinations. Remember to customize the Fluentd configuration to meet your specific logging needs.

