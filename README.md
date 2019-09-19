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

Looking at the original code example from Jan-Piet MENS (output reformated
to 80 column width).

```
[dan@mydev:~/src/git_proc_commit] $ python3
Python 3.6.9 (default, Aug 27 2019, 04:29:05) 
[GCC 4.2.1 Compatible FreeBSD Clang 6.0.1 (tags/RELEASE_601/final 335540)] on freebsd12
Type "help", "copyright", "credits" or "license" for more information.
>>> import git
>>> repo = git.Repo("~/src/freebsd-ports")
>>> commits = list(repo.iter_commits("master", max_count=9))
>>> dir(commits[0])
['Index', 'NULL_BIN_SHA', 'NULL_HEX_SHA', 'TYPES', '__class__', '__delattr__', 
'__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__getattr__', 
'__getattribute__', '__gt__', '__hash__', '__init__', '__init_subclass__', 
'__le__', '__lt__', '__module__', '__ne__', '__new__', '__reduce__', 
'__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__slots__', 
'__str__', '__subclasshook__', '_deserialize', '_get_intermediate_items', 
'_id_attribute_', '_iter_from_process_or_stream', '_process_diff_args', 
'_serialize', '_set_cache_', 'author', 'author_tz_offset', 'authored_date', 
'authored_datetime', 'binsha', 'committed_date', 'committed_datetime', 
'committer', 'committer_tz_offset', 'conf_encoding', 'count', 
'create_from_tree', 'data_stream', 'default_encoding', 'diff', 'encoding', 
'env_author_date', 'env_committer_date', 'gpgsig', 'hexsha', 'iter_items', 
'iter_parents', 'list_items', 'list_traverse', 'message', 'name_rev', 'new', 
'new_from_sha', 'parents', 'repo', 'size', 'stats', 'stream_data', 'summary', 
'traverse', 'tree', 'type']
>>> print(commits[0].author)
jrm
>>> print(commits[0].message)
sysutils/doctl: Update to v1.31.2

Sponsored by:	DigitalOcean [1]

[1] DigitalOcean provided VM credit to test doctl

>>> print(commits[0].hexsha)
0d5f1c8c72d95bc46329694b2490099765002331
>>> 
[dan@mydev:~/src/git_proc_commit] $ ./git-show-commit.py
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
