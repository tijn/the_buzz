The Buzz
========

What's the buzz?

The goal of this project is having a [Dashing](http://shopify.github.io/dashing/) widget that can show a timeline of the current events of watched projects (and whole organizations) on GitHub.

'sup?
-----

Console output only for now.

```
git clone <this_repo>
cd <the_buzz_directory>
bundle install
bin/watch_viadeo # if you want to know what's up with my old employer (and you have access)
# see it failing to authenticate
# read https://github.com/octokit/octokit.rb#using-a-netrc-file
vim ~/.netrc
bin/watch_viadeo
```
:-)

You should consider forking this. The first thing you should do is to tweak it to use a better authentication method.
 
 
To Do
-----

* Support more authentication methods out of the box
* HTML output
