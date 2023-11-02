# Template TTP
## Summary

Name the file itself with all characters lowercase, and spaces replaced with underscores. E.g. "Template TTP" becomes "template_ttp". Then add it to "SUMMARY" as "`- [Template TTP](./template_ttp.md)`". The only reason this file is named "00 - template_ttp", is so that it stays at the top of obsidian. If it belongs to a category (i.e. Windows Lateral Movement), then it must be added there as well. Each category will be in all caps and will end with \_SUMMARY, i.e. "WINDOWS_LATERAL_MOVEMENT_SUMMARY".

If pasting images, ensure to place them in the images directory otherwise your links may break when we go through and clean up the repo from time to time, and also replace spaces with "%20", and rename it as follows:

```md
# Old Name
![[Pasted image 1.png]]

# New Name
![image name](./images/Pasted%20image%201.png)
```

Alternatively, use the `fix_links.sh` file in the root of this repo to automatically apply the above change.

If you need to host a custom or specific file, place it into the `misc-attachments` folder and then link it like so:

```md
[link](./misc-attachments/file.whatevs)
```

## Prerequisites

## Setup

## Execution

### Method N - Blah Blah

#### Indicators of Compromise

### Method N - Blah Blah

#### Indicators of Compromise