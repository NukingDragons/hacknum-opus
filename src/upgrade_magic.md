# Upgrading Shells with Magic
## Summary

When using a raw shell, using netcat or something similar, usually this shell does not have an associated TTY, and can be killed accidentally with Ctrl+C. There are a few ways to fix both of these issues to stabilize the shell.

## Prerequisites

Some form of raw shell, C2 frameworks won't work with the magic portion, but may work with the TTY portion.

## Setup

Obtain a shell from a linux or mac based host through some means. If you have a windows shell, then fetch another by wrapping your listener with the `rlwrap` command. That's the best you'll get on Windows.

## Execution

### Method 1 - Python TTY + Magic

The first step is to obtain a working TTY in the shell using python, use the following command:

```bash
python -c 'import pty; pty.spawn("/bin/bash")'
```

With a TTY created, we can perform "Magic" to upgrade the shell such that Ctrl+C, tab completion, etc, gets forwarded to the shell instead of being handled locally.

First, press Ctrl+Z to background the process. Then, run the following command and note down the *rows* and *columns* from the output:

```bash
stty -a
```

Now, run the following command. The semicolon is important:

```bash
stty raw -echo; fg
```

Press enter to regain control of the netcat shell, and then run the following commands:

```bash
reset
export TERM=xterm
stty rows <rows> cols <columns>
```

Now, your reverse shell should function like any other shell, with tab completion and Ctrl+C support, you should also be able to clear the screen and use editors like vim. If you resize the terminal, you may need to update the rows and columns with `stty`.

#### Indicators of Compromise

TODO

### Method 2 - Script TTY  + Magic

The first step is to obtain a working TTY in the shell using script, use the following command:

```bash
script -q /dev/null -c /bin/bash
```

With a TTY created, we can perform "Magic" to upgrade the shell such that Ctrl+C, tab completion, etc, gets forwarded to the shell instead of being handled locally.

First, press Ctrl+Z to background the process. Then, run the following command and note down the *rows* and *columns* from the output:

```bash
stty -a
```

Now, run the following command. The semicolon is important:

```bash
stty raw -echo; fg
```

Press enter to regain control of the netcat shell, and then run the following commands:

```bash
reset
export TERM=xterm
stty rows <rows> cols <columns>
```

Now, your reverse shell should function like any other shell, with tab completion and Ctrl+C support, you should also be able to clear the screen and use editors like vim. If you resize the terminal, you may need to update the rows and columns with `stty`.

#### Indicators of Compromise

TODO