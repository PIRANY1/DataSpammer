# DataSpammer

![Functionality Tests](https://github.com/PIRANY1/DataSpammer/actions/workflows/workflow.yml/badge.svg)
![Compile DataSpammer.bat](https://github.com/PIRANY1/DataSpammer/actions/workflows/analyze-bin.yml/badge.svg)
Read this in: [German](https://github.com/PIRANY1/DataSpammerDE)

## Summary

A multifunctional batch-based stress-testing & automation toolkit for Windows — written to learn the ins and outs of cmd.exe, batch scripting and Windows quirks.
Use responsibly. ⚠️ See Security & Responsible Use below.

## Features

### Stress-Test Features

ICMP, SSH, FTP, DNS, Telnet, HTTP(S), Printer (List) Spam, Desktop Spam, Folder Spam, Start Menu Spam, App List Spam, ZIP Bomb Creator, Encrypt / Decrypt, Internal Scripting

### Other Features

Desktop Shortcut, Auto Update, Logging, Elevation via sudo/pwsh/gsudo, Encryption, Debugging, Secure Authentication
Login, Monitor Socket, Coloring Support (NCS / ANSI), Settings via Registry, Applist Support, Emoji Suppot, 
Custom CHCP Support, Portable Install & many more Features

## Install

Use one of the methods below or download the [Latest Version](https://github.com/PIRANY1/DataSpammer/releases/latest)

### One-Line Command

``` batch
curl -sSLO https://github.com/PIRANY1/DataSpammer/releases/download/v6/dataspammer.bat && dataspammer.bat
```

### Scoop

``` batch
scoop bucket add dts-bucket https://github.com/PIRANY1/dataspammer-bucket
scoop install dataspammer
```

### Git

``` batch
git clone https://github.com/PIRANY1/DataSpammer.git
cd DataSpammer
dataspammer.bat install
```

### GitHub CLI

``` batch
gh repo clone PIRANY1/DataSpammer
cd DataSpammer
dataspammer.bat install
```

## Known Bugs

The updater occasionally corrupts files; redownloading the application resolves this issue.

## About

I created this script to learn more about Batch and how cmd.exe operates.

Good Resource:

[A detailed overview of CMD Commands](https://ss64.com/nt/)
