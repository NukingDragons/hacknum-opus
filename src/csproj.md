# Visual Studio CSPROJ Reverse Shell
## Summary

Visual Studio `.csproj` files contain the ability to run pre-build and post-build commands during compile time of the project. This feature becomes a vulnerability if the project itself is accessible by a malicious actor, such as a compromised developer account gaining access to the projects git repository.

## Prerequisites

This requires visual studio to compile the malicious project, and some form of repository hosting is recommended.

## Setup

You can either download the [malicious visual studio project zip file](./misc-attachments/CSProjExploit.zip), or you can follow these steps to create it yourself. If you're modifying an existing repository, skip to step 2.

Step 1: Create the project using .NET 6.0 (Recommended):

![image](./images/Pasted%20image%2020231102134743.png)

![image](./images/Pasted%20image%2020231102134810.png)

Step 2: Go to the project properties:

![image](./images/Pasted%20image%2020231102135107.png)

Step 3: Go to Build -> Events

![image](./images/Pasted%20image%2020231102135154.png)

Step 4: Add your pre-build command

![image](./images/Pasted%20image%2020231102135233.png)

## Execution

### Method 1 - Compilation

If the target repository is in a git repo, push the changes with the following 2 commands:

```bash
git add -A .
git commit -m "Your Message Here"
git push
```

In every scenario, someone needs to compile this repository to execute the pre-build command.

#### Indicators of Compromise

TODO
