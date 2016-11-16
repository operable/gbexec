## Compilation prequisites

* Erlang 19.1
* Elixir 1.3.4
* C++ compiler (Tested with gcc and clang)

## Building

1. Clone this repo
1. `cd` to cloned directory
1. `mix do deps.get, escript.package`
1. Place the contents of `gbexec/bin` in your path


## Using

```
> gbexec --help
gbexec 0.1.0

gbexec (-s,--slack|-h,--hipchat) <template file> <data file>

-s, --slack	Use Slack template renderer
-h, --hipchat	Use HipChat renderer
--help		Display this help message

<template file>	Path to a Greenbar template
<data file>	Path to a file containing valid JSON
```
