# WinRM
## Summary

WinRM, or Windows Remote Management, is a feature that comes installed on all modern versions of Windows (Windows Server 2008/Windows 7 onwards) which allows remote administration between hosts. Usage of this service requires credentials or the NTLM hash of a user that has remote management permissions.

WinRM utilizes an API called wsman, which is built ontop of HTTP/S and operates on ports 5985 (HTTP) or 5986 (HTTPS) by default. Its legitimate use is comparable to psexec, and it can be used to perform administrative functions on remote hosts without the need for SSH or RDP. With the addition of PowerShell to the Windows ecosystem, it also goes by the name PowerShell Remoting, though these commands are just wrappers around WinRM.

## Prerequisites

WinRM may require configuration to work, and the target user must have the "Remote Management User" permissions. Unless permissions are applied via group policy, users must be added to the "Remote Management Users" localgroup on a per-machine basis. Adding that user to the domain group only grants WinRM access to the domain controller.

## Setup

To configure WinRM, run the following command as an administrator:

```cmd
winrm quickconfig
```

Once WinRM has been successfully configured, add a user to the Remote Management User group using this command:
```
net localgroup "Remote Management Users" username /add
```

## Execution

### Method 1 - Evil-WinRM
https://github.com/Hackplayers/evil-winrm

Evil-WinRM is a tool which wraps WinRM commands to give you an interactive shell on a target machine. Evil-WinRM is written in Ruby, and requires it to be installed to work. 

Using the credentials of the user that has access to the WinRM service, run one of the following commands to obtain access to the target.

Connect to a host:

`evil-winrm --ip <target> --user <user> --password <password>`
 
Connect to a host, passing the hash instead of using a password:

`evil-winrm --ip <target> --user <user> --hash <nt_hash>`

#### Indicators of Compromise

When connecting to a WinRM port, network traffic will show the upload of a "wsman" file to the target host over HTTP.