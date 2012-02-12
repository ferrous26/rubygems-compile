# rubygems-compile

A set of rubygems commands for `macgem` that interface with the
MacRuby compiler. This gem requires MacRuby 0.11 or newer.

All you need to do is:

```bash
sudo macgem install rubygems-compile
```

And then you're off to the races!

## Commands

`compile`

  Can be used to compile, or re-compile, any gems that are already
  installed.

```bash
sudo macgem compile nokogiri                        # Compile gems based on names you provide
sudo macgem compile minitest --version 2.0.2        # Compile a specific version of a gem
sudo macgem compile --all                           # Compile all installed gems
sudo macgem compile rspec --no-ignore-dependencies  # Also compile dependencies
```

`uncompile`

  Can be used to remove the compiled `.rbo` files if a gem does not
  work well when compiled. If you find a gem that does not work when
  compiled, it would be greatly appreciated if you reported it here or
  to the MacRuby project itself so that someone can look into the
  problem.

```bash
sudo macgem uncompile nokogiri                        # Uncompile gems based on names you provide
sudo macgem uncompile minitest --version 2.0.2        # Compile a specific version of a gem
sudo macgem uncompile --all                           # Uncompile all installed gems
sudo macgem uncompile rspec --no-ignore-dependencies  # Also uncompile dependencies
```

`auto_compile`

  If you don't like the idea of calling `compile` each time you
  install a gem, then you can use `auto_compile` to enable a
  post-install hook that will automatically compile gems when they are
  installed. You can call `auto_compile` a second time to turn off the
  feature.

```bash
sudo macgem auto_compile  # gems will compiled when you install them
sudo macgem auto_compile  # gems will not be compiled when you install them
```

## Caveats

* Large gems will take a long time to compile, but these are the gems
  that will benefit the most from being compiled so please be patient
* This has only been tested on a few gems, but should not break
  existing gems since we leave the original files around
* At the moment, compiled gems will not provide usable backtraces
  + If you suspect a bug in the way MacRuby compiled a file, try running with pre-compiled files disabled like so: `VM_DISABLE_RBO=1 macruby my_code.rb`
* `.rbo` files take up more disk space than their `.rb` equivalents

## Known Issues

* Source files using a non-standard suffix (e.g. `mime-types` has a `.rb.data` file) will not get compiled
  + This might be addressable in a later release, but is not a big deal
* Gems that explicitly require a file with the file suffix (e.g. `require 'nokogiri.rb'`) will never load the compiled version of the file
  + This issue may be addressed in MacRuby itself in the near future
  + Alternatively, those gems should be updated so that compiled code can be loaded

## TODO

* Parallel compilation to speed up compilation of large gems
  + This might require changes in the MacRuby compiler

## Copyright

Copyright (c) 2011-2012 Mark Rada. See LICENSE.txt for further details.

