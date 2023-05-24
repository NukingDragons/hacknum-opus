# WinRM
## Summary

WinRM, or Windows Remote Management, is a feature that can be enabled on any Windows Server. Usage of this service requires credentials (or the NTLM hash) of a user that has permissions. The WinRM service starts automatically on Windows Server 2008 and later. On earlier versions of Windows (client or server), you need to start the service manually.

## Prerequisites

A windows server must be set up and configured to use WinRM, with at least one user who has access to this service.

## Setup

To configure winrm, use the following command as an administrator:

```cmd
winrm quickconfig
```

## Execution

### Method 1 - Evil-WinRM

Evil-WinRM is written in Ruby, ruby must be installed for this tool to work. Using the credentials of the user that has access to the WinRM service, run one of the following commands to obtain access to the target.

Connect to a host:

`evil-winrm --ip <target> --user <user> --password <password>`
 
Connect to a host, passing the hash instead of using a password:

`evil-winrm --ip <target> --user <user> --hash <nt_hash>`

#### Indicators of Compromise

TODO