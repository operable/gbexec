## Compilation prequisites

* Erlang 19.1
* Elixir 1.3.4
* C++ compiler (Tested with gcc and clang)

## Building

### Native

1. Clone this repo
1. `cd` to cloned directory
1. `mix do deps.get, escript.package`
1. Place the contents of `gbexec/bin` in your path

### Docker

1. run Dev build in container:
```
docker build -t gbexec:dev .
```
1. Test container:
```
docker run --rm -v $PWD/examples:/examples -w /examples gbexec:dev -s hello.greenbar hello.json
```

## Using

```
> gbexec --help
gbexec 1.0.0

gbexec (-s,--slack|-h,--hipchat) <template file> <data file>

-s, --slack	Use Slack template renderer
-h, --hipchat	Use HipChat renderer
--help		Display this help message

<template file>	Path to a Greenbar template
<data file>	Path to a file containing valid JSON
```

## Examples

### Render a template for Slack

```
> bin/gbexec -s hello.greenbar data.json
*Hello Louise*
```

### Render a template for HipChat

```
> bin/gbexec -h hello.greenbar data.json
<strong>Hello Louise</strong>
```
