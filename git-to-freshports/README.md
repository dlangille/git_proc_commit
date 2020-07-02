GIT to FreshPorts converter
===========================

Used to convert GIT commit entries into XML files digestible by the FreshPorts backend

Installation:
```shell script
pkg install python3 py36-lxml py36-gitpython
```

Running:
```shell script
python3 git-to-freshports-xml.py --path /path/to/git/repo --commit deafbeaf0 --output /path/to/xml/results
```

Getting help:
```shell script
python3 git-to-freshports-xml.py --help
```
