
# GonnaCope

## Summary

The GonnaCope Ransomware is among the more harmful ransomware threats. It is capable of locking the data of its victims completely. Furthermore, thanks to the sufficient strength of the encryption algorithm, the affected files are unlikely to ever be restored without assistance from the attackers.

## Prerequisites

- Administrator with high integrity or NT/Authority System shell.
- Defender disabled or definitions deleted.

## Setup
Download the 7z Compressed ransomware from [here.](https://github.com/vxunderground/MalwareSourceCode/tree/main/Win32/Ransomware) The password is 'infected' without the single quotes. 
Place the ransomware onto the system via download or GPO.

## Execution

### Method 1 - Execution via command prompt or RDP session.

Within the shell type:
```powershell
.\G0nnaC0pe.bat
```

OR

Navigate to the directory of the ransomware and double click the `G0nnaC0pe.bat` file.

#### Indicators of Compromise
- The ransomware encrypts files found and adds a ".cope" extension to the filename.

- The mouse buttons are inverted

- The ransomware spawns the below shell:

![gonnacope](./images/Pasted%20image%2020230606110703.png)
