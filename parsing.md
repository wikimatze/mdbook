## Installing Ruby With rbenv

Instead of using the build-in software package for Ruby of your operating system, we will use
[rbenv](https://github.com/sstephenson/rbenv/ "rbenv") which lets you switch between multiple versions of Ruby.


First, we need to use [git](http://git-scm.org) to get the current version of rbenv:


{: lang="bash" }
    $ cd $HOME
    $ git clone git://github.com/sstephenson/rbenv.git .rbenv



I>## Why Sessions?
I>
I> When you request
I> that it doesn't [Regular](http://localhost:3000/login?user=test&password=test) aaa bla
I>
I> We are going to use cookies to save if a user is logged in and saving the user-Id in our session cookies under the
I> key `:current_user`.


In case you shouldn't want to use git, you can also download the latest version as a zip file from
[Github](http://github.com).


You need to add the directory that contains rbenv to your `$PATH`environment variable.  If you are on Mac, you have
to replace `.bashrc` with `.bash_profile` in all of the following commands):
