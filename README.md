# scratchgo

## About
This is a minimal example of how to create a statically linked
webserver in Go that can be executed in a Docker [FROM scratch](https://hub.docker.com/_/scratch) container.

I use a [multi-stage build](https://docs.docker.com/develop/develop-images/multistage-build/)
to build the binary so no Go related tools needs to be installed.

Keep in mind that this minimal webserver is only meant for
demonstrational purposes. For production traffic you need to think about
additional stuff such as connection timeouts. Here is some more
reading/viewing if that is your goal:
* [So you want to expose Go on the Internet](https://blog.cloudflare.com/exposing-go-on-the-internet/)
* [Golang UK Conference 2017 | Ian Kent - Production-ready Go](https://www.youtube.com/watch?v=YF1qSfkDGAQ)

When creating this example I found lots of useful information here:
* [Create the smallest and secured golang docker image based on scratch](https://medium.com/@chemidy/create-the-smallest-and-secured-golang-docker-image-based-on-scratch-4752223b7324)
* [The Go 1.11 web service Dockerfile](https://medium.com/@pierreprinetti/the-go-1-11-dockerfile-a3218319d191)


## How to build
```
docker build -t scratchgo:v0.0.1 .
```

## How to run
```
docker run -p 8080:8080 scratchgo:v0.0.1
```

## How to test
```
curl localhost:8080
```

## Why would I want this?

Basing your container on a `scratch` image gives some advantages:
* The size of the image will be small.
* Security inspections can be focused on the app itself and not the additional and possibly unused cruft from a more general base image.

## Why would I not want this?

If your workflow involves entering a running container via some shell
for debugging purposes or modifying settings this will not work since
there is no shell to execute (and even if there was, no tools like
`ls` or `cat` for poking around).

## Ways to deal with the lack of a shell

If a tool is available in the host operating system you might be able to
utilize [nsenter(1)](https://manpages.debian.org/testing/util-linux/nsenter.1.en.html)
to interact with the container given that the tool is compatible. Keep in mind
that this creates a dependency between the container contents and the host it
is running on which might be unwanted.

Instead you should build debuggability into the application itself
through means like logging, [tracing](https://opentracing.io/) or some sort
of exposed metrics where the app presents its state, possibly using
something like [expvar](https://golang.org/pkg/expvar/).

The app should also have some sort of administrative API where runtime
settings such as log levels can be configured without local access to
the container.

## This all sounds great, but I don't want to use Go

As long as your programming language of choice has the ability to generate
statically linked binaries you should be able to use a slightly modified
version of this setup and be good to go.
