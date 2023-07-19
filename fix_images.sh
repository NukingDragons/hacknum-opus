#!/bin/sh

find . -name "*.md" ! -name "00 - template_ttp.md" -exec sed -i 's/!\[\[Pasted image \(.*\)\]\]/![image](.\/images\/Pasted%20image%20\1)/g' {} \;
