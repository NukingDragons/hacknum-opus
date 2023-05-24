# SUDO/SUID/etc
## Summary

One of the easiest and quickest privilege escalation techniques is to check if there is a vulnerable misconfiguration in the /etc/sudoers file, or if a known program contains the set-UID bit that may retain privileges. There are more than just sudo or SUID vulnerabilities on GTFOBins, so review the website for any additional abuse of privileges.

## Prerequisites

The only prerequisite is that the box has either sudo or SUID support for either of those specific vulnerabilities, though these are not the only vulnerabilities that could lead to privesc.

## Setup

To configure a box to be vulnerable to one of these methods, check https://gtfobins.github.io/ and select the binary and vulnerability type that you'd like to implement.

## Execution

### Method 1 - SUDO

For this method, the users password must be known *or* the user must have the NOPASSWD flag set in /etc/sudoers, i.e.:

```sudoers
...

root ALL=(ALL:ALL) ALL
# EVERYTHING ran without a password
user1 ALL=(ALL:ALL) NOPASSWD: ALL
# Specific program doesnt require a password
user2 ALL=(ALL:ALL) NOPASSWD: /usr/bin/vi
...
```

Then simply click "SUDO" or type "+sudo" followed by the program(s) listed in the output of `sudo -l`. Then follow the specific instructions for that binary to exploit the misconfiguration.

![image](./images/Pasted%20image%2020230522135640.png)

#### Indicators of Compromise

TODO

### Method 2 - SUID

This method is almost identical to sudo, but rather than running `sudo -l`, the following command(s) can be used to determine if the SUID bit is set:

```bash
# The program will run as the owner of the file
find / -perm -4000 -ls 2>/dev/null

# The program will run as the group of the file
find / -perm -2000 -ls 2>/dev/null

# The program will run as both the owner and the group
find / -perm -6000 -ls 2>/dev/null
```

Once a program has been identified from one or more of the commands above, plugging them into GTFOBins with "+suid" will determine if the machine is vulnerable to this misconfiguration.

#### Indicators of Compromise

TODO