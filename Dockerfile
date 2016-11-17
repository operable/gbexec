FROM operable/elixir:1.3.4-r0

# Greenbar-only compilation dependencies
RUN apk -U add --no-cache expat-dev gcc g++ libstdc++

COPY . /code
WORKDIR /code

RUN mix do deps.get, escript.package
ENV PATH /code/bin:$PATH

CMD /code/bin/gbexec
