SHELL        := /usr/bin/env bash
NAME         := libstatgrab-dev
VERSION      := 0.90
BUILD_NUMBER ?= 0

DIST         := "./dist"
TMP          := "./tmp"
TAR          := libstatgrab-$(VERSION).tar.gz
SRC          := $(TMP)/src/libstatgrab
PREFIX       := deb/usr/local
DEB          := $(NAME)_$(VERSION)+$(BUILD_NUMBER)_amd64.deb

.PHONY: clean

default: dist

build: $(SRC)/Makefile
	 $(MAKE) -C $(SRC) && \
	 $(MAKE) -C $(SRC) install

clean:
	-rm -rf $(DIST) $(TMP) $(TAR) $(PREFIX)

dist: $(DIST)/$(DEB)

%.deb: build $(DIST)
	makedeb --name=$(NAME) \
	 --version=$(VERSION) \
	 --debian-dir=deb \
	 --build=$(BUILD_NUMBER) \
	 --architecture=amd64 \
	 --output-dir=$(DIST)

$(SRC)/Makefile: $(SRC) $(PREFIX)
	cd $(TMP) && ./configure --prefix=$(realpath $(PREFIX))

$(SRC): $(TAR) $(TMP)
	tar xf $< -C $(TMP) --strip-components=1

$(TAR):
	wget http://dl.ambiweb.de/mirrors/ftp.i-scream.org/libstatgrab/$@

$(DIST) $(TMP) $(PREFIX):
	mkdir -p $@
