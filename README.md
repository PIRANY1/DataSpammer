# DataSpammer
### Features
Add to Path, Autostart, Desktop Shortcut, Taskbar Shortcut, Remotespam(laggy), Desktop Spam, Portable Installation, Custom Folder Spam, Update Libs, Updater(requires Libs) and some more + 2 Easter Eggs

# Install
Please download the latest [Version](https://github.com/PIRANY1/DataSpammer/releases/latest) or use one of the methods down below.
### Git
```
git clone https://github.com/PIRANY1/DataSpammer
cd DataSpammer
install.bat
```
### Github CLI
```
gh repo clone PIRANY1/DataSpammer
cd DataSpammer
install.bat
```
### Download File
Install with only one [File](https://gist.github.com/PIRANY1/8344f981f20a8e430f8a74c5fa80c390/archive/97f89d1649c772d1c556310cd53a14e68a7801b4.zip)(Needs Git Installed)

# Supported Versions
## Todo
Fix Remotespam via scp/ftp/ssh
Improve Language
Please use the newest Version and Update the Script. Older Versions have more Bugs.
> Older Versions doesnt support full Update

|Version | Supported          |Link to Changelog                |
|------- | ------------------ |----------------------- |
|v1.0  |❌|[Changelog Here](https://github.com/PIRANY1/DataSpammer#v10)
|v1.0.1|❌|[Changelog Here](https://github.com/PIRANY1/DataSpammer#v101)
|v1.1|❌|[Changelog Here](https://github.com/PIRANY1/DataSpammer#v11)
|v1.2|❌|[Changelog Here](https://github.com/PIRANY1/DataSpammer#v12)
|v1.3|❌|[Changelog Here](https://github.com/PIRANY1/DataSpammer#v13)
|v1.4|❌|[Changelog Here](https://github.com/PIRANY1/DataSpammer#v14)
|v1.5|❌|[Changelog Here](https://github.com/PIRANY1/DataSpammer#v15)
|v1.5.1|❌|[Changelog Here](https://github.com/PIRANY1/DataSpammer#v151)
|v1.5.2|❌|[Changelog Here](https://github.com/PIRANY1/DataSpammer#v152)
|v1.5.3|❌|[Changelog Here](https://github.com/PIRANY1/DataSpammer#v153)
|v1.6|❌|[Changelog Here](https://github.com/PIRANY1/DataSpammer#v16)
|v1.7|❌|[Changelog Here](https://github.com/PIRANY1/DataSpammer#v17)
|v2|❌|[Changelog Here](https://github.com/PIRANY1/DataSpammer#v2)
|v2.1|❌|[Changelog Here](https://github.com/PIRANY1/DataSpammer#v21)
|v2.2|❌|[Changelog Here](https://github.com/PIRANY1/DataSpammer#v22)
|v2.3|❌|[Changelog Here](https://github.com/PIRANY1/DataSpammer#v23)
|v2.3.1|❌|[Changelog Here](https://github.com/PIRANY1/DataSpammer#v231)
|v2.4|❌|[Changelog Here](https://github.com/PIRANY1/DataSpammer#v24)
|v2.4.1|✅|[Changelog Here](https://github.com/PIRANY1/DataSpammer#v241)
|v2.5|✅|[Changelog Here](https://github.com/PIRANY1/DataSpammer#v25)
## Reporting a Bug
If you encountered a Glitch/Bug/Vulnerability please create an [Issue](https://github.com/PIRANY1/DataSpammer/issues)

# Credits
[TAAG](https://patorjk.com/software/taag/) Used for Main Menu
[jq](https://jqlang.github.io/jq/) ,
[Scoop](https://scoop.sh/#/) , 
[jid](https://bjansen.github.io/scoop-apps/main/jid/) Used For Auto Update

 ## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=pirany1/dataspammer&type=Date)](https://star-history.com/#pirany1/dataspammer&Date)

# License
MIT License

Copyright (c) - 2023 - PIRANY

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

# Changelog
### v1.0
Added Main Files (untested)
Bugs:
Installer not moving .txt Files into the Folder - Need to be done manually
Autostart Setup doesnt work
Installer doesnt recognise that the Script is already installed

### v1.0.1
Added ASCII Art and improved readme + license
Bugs
Autostart Setup doesnt work
Installer still not moving .txt Files into the Folder - Need to be done manually

### v1.1
Bugfixes + Reworked UI + Updater first Introduced
Bugs
Installer still not moving files into folder - Need to be done manually
Updater not working

### v1.2
Desktop Icon Introduced, added Autostart 
Bugs:
Updater is now working but cant install any Updates
Update skip doesnt work
Script cant start
Autostart doesnt work because script doesnt have Admin rights
Scoop Temp File doesnt get deleted

### v1.3
New Installer Options
Bugs:
Scoop Temp File doesnt get deleted
Skip Update doesnt work
Script cant start properly
Autostart doesnt work
Script cant start accurately

### v1.4
Updater done
Bugs:
Updater thinks its in v1.3
Skip Update doesnt work
Scoop Temp File doesnt get deleted
Script cant start accurately
Autostart doesnt work

### v1.5
Updater done has one error, Desktop Icons done.
Bugs:
Update skip doesnt work
Autostart doesnt work
JQ+Scoop Update doesnt work
Script cant start accurately

### v1.5.1
Improved Installer, Script is now checking if you have the libs installed and if yes it skips the install
Bugs:
Update skip doesnt work
Check for Update doesnt work
Script cant start accurately

### v1.5.2
Migrated startupcheck.bat and start.bat
Bugs:
Script cant start accuratly
Check for Update doesnt work

### v1.5.3
You can now skip the Update
Script can now start normally
Bugs:
Installer is trying to copy startupcheck.bat
Check for Update doesnt work

### v1.6
Added Desktop Spam, Check for Update got added

### v1.7
Error Codes added 
You can now use the Script without the Update Libs
Bugs:
Update doesnt work

### v2
Settings are all in one File
Bugs:
Update doesnt work

### v2.1
You can now install the Script on other Drives
Install in Normal Program Directory Got Added
Folder Name is now the right one
Bugs:
Install in Programmm Directory triggers AV
Update doesnt work

### v2.2 
Install in Program Directory added, may trigger AntiVirus
Bugs: 
Installer Crashes Early But can finish the installation
Update doesnt work

### v2.3
Migrated start.bat and Dataspammer.bat and fixed a Few Bugs
Bugs:
Update doesnt work

### v2.3.1
Fixed Updater

### v2.4
Fixed OnStart Update Checker

### v2.4.1
No known Bugs

### v2.5
Fixed and Improved everything. Script is almost perfect.

