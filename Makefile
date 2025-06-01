#!/usr/bin/env make

# Variables
# TARBALL     := tarball.tar.gz
# DISTDIR     := Application
EXECDIR     := launch

.PHONY: all unpack link run clean

all: run

unpack:
# 	mkdir -p $(DISTDIR)
# 	tar -xzf $(TARBALL) -C $(DISTDIR)

#<	Source Files

#<	Nim
# 	cd $(DISTDIR) && \
# 		CC=musl-gcc nim c -d:release --opt:speed --mm:orc --passC:-flto --passL:-flto --passL:-static .nim

#<	Go
# 	cd $(DISTDIR)/src/ && \
# 		GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags='-s -w' .go

#<	Elixir
# 	cd $(DISTDIR)/src/.modules && \
# 		elixirc elixirtest.ex 2> /dev/null .ex

link: unpack
	mkdir -p $(HOME)/.local/bin
	ln -sf $(HOME)/Tholos/launch $(HOME)/.local/bin/thol

run: link
	./$(EXECDIR) --version

clean:
#	rm -rf $(TARDIR)
	rm $(HOME)/.local/bin/thol