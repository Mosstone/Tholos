#!/usr/bin/env make

# Variables
TARBALL     := tarball.tar.gz
DISTDIR     := WeatherApp
EXECDIR     := $(DISTDIR)/glue

.PHONY: all unpack run clean

all: run

unpack:
	mkdir -p $(DISTDIR)
	tar -xzf $(TARBALL) -C $(DISTDIR)

#<	Source Files
	cd $(DISTDIR) && \
		CC=musl-gcc nim c -d:release --opt:speed --mm:orc --passC:-flto --passL:-flto --passL:-static ./glue.nim

	cd $(DISTDIR)/src/ && \
		GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags='-s -w' network.go

#<	Modules
	cd $(DISTDIR)/src/.modules && \
		elixirc elixirtest.ex 2> /dev/null

run: unpack
	$(EXECDIR) --version

clean:
	rm -rf $(TARDIR)
