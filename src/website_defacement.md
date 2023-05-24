# Website Defacement
## Summary

Website defacement is a destructive and loud method of denying or humiliating a service or company. In this case, the website will be replaced with a "King of the Hill" themed propane selling service.

## Prerequisites

The target webserver must support PHP in order to host the defaced webroot contents.

## Setup

Download [this](./misc-attachments/papa_www.zip) file, it contains the contents to be placed in the targets webroot. Often times this is in /var/www/html, but check the running webservers config file to verify.

## Execution

### Method 1 - Extract using Unzip

To upload the file to the machine, one possible way is to use `scp` or to host a python webserver and then use `wget` on the target webserver. Prior to extracting, either delete or move the contents of the old webroot. Then, once the file is uploaded, its time to locate and enter the webroot of the server, then run the following command:

```bash
cd /var/www/html # Most common webroot location
unzip /path/to/papa_www.zip
```

#### Indicators of Compromise

TODO, but its going to be loud and obvious