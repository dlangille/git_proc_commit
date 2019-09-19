This script aims to process, one at a time, commits made to the FreeBSD
ports tree. If successful, this proof-of-concept will become the basis for
FreshPorts commit processing after the FreeBSD projects moves to using git
for all commits.

Example test:

```
[dan@pro02:~/src/git_proc_commit] $ ./git-show-commit.sh
0d5f1c8c72d95bc46329694b2490099765002331
ab24c4bd5dffffeabdcaa9bc5f3ca1e1615c95d5
f2bfe60090b840b6d99a3288c0b745843cefcfe1
[dan@pro02:~/src/git_proc_commit] $ 
```

Example test with git:

```
$ ./git-show-commit.py
jrm
sysutils/doctl: Update to v1.31.2

Sponsored by:	DigitalOcean [1]

[1] DigitalOcean provided VM credit to test doctl

0d5f1c8c72d95bc46329694b2490099765002331
```

references:

* https://twitter.com/DLangille/status/1172119720486723590
* https://news.freshports.org/2019/09/18/moving-towards-commit-hooks/
* https://docs.freshports.org
