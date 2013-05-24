``` ruby
class Davi
  def capital
    puts "Karaz-a-Karak"
  end

  alias_method :orig_capital, :capital

  def capital
    puts "Karaz-a-Karak rebuild"
    orig_capital
  end
end

davi = Davi.new
davi.capital

# output
"Karaz-a-Karak rebuild"
"Karaz-a-Karak"
```


```vim
:set number
:set numberwidth=10
:set numberwidth=4
:set numberwidth?
:echom "Hello again, world!"
:echo "Hello, world!"
```

```
:set number
:set numberwidth=10
:set numberwidth=4
:set numberwidth?
```


```bash
$ rbenv global 1.9.2-p290
$ rbenv local 1.9.2-p290
$ ruby -v
=> ruby 1.9.2p290 (2011-07-09 revision 32553) [i686-linux]
```



Setting Options
===============

Vim has many options you can set to change how it behaves.

There are two main kinds of options: boolean options (either "on" or "off") and
options that take a value.

Run the following command:

    :::vim
    :set number

Line numbers should appear in Vim.  Now run this:

    :::vim
    :set nonumber

The line numbers should disappear.  `number` is a boolean option -- it can be
off or on.  You turn it "on" by running `:set number` and "off" with `:set
nonumber`.

Toggling Options
----------------

You can also "toggle" boolean options to set them to the *opposite* of whatever
they are now.  Run this:

    :::vim
    :set number!

The line numbers should reappear.  Now run it again:

    :::vim
    :set number!

They should disappear once more.  Adding a `!` (exclamation point or "bang") to
a boolean option toggles it.

Checking Options
----------------

You can ask Vim what an option is currently set to by using a `?`.  Run these
commands and watch what happens after each:

    :::vim
    :set number
    :set number?
    :set nonumber
    :set number?

Notice how the first `:set number?` command displayed `number` while the second
displayed `nonumber`.

Options with Values
-------------------

Some options take a value instead of just being off or on.  Run the following
commands and watch what happens after each:

    :::vim
    :set number
    :set numberwidth=10
    :set numberwidth=4
    :set numberwidth?

The `numberwidth` option changes how wide the column containing line numbers
will be.

Try checking what a few other common options are set to:

    :::vim
    :set wrap?
    :set numberwidth?

Setting Multiple Options at Once
--------------------------------

Finally, you can specify more than one option in the same `:set` command.  Try
running this:

```ruby
def
  a = 3
end

class Bla
  TEST = 11

end
```

```
def
  a = 3
end

class Bla
  TEST = 11

end
```



Read `:help wrap`.

