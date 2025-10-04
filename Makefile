# Adapted from: http://www.greghendershott.com/2017/04/racket-makefiles.html
SHELL=/bin/bash

PACKAGE-NAME=aoe2-rms

DEPS-FLAGS=--check-pkg-deps --unused-pkg-deps

help:
	@echo "install - install package along with dependencies"
	@echo "remove - remove package"
	@echo "build - Compile libraries"
	@echo "build-docs - Build docs"
	@echo "build-standalone-docs - Build self-contained docs that could be hosted somewhere"
	@echo "build-all - Compile libraries, build docs, and check dependencies"
	@echo "clean - remove all build artifacts"
	@echo "check-deps - check dependencies"
	@echo "test - run tests"
	@echo "docs - view docs in a browser"
	@echo "setup - day to day dev"

# Primarily for use by CI.
# Installs dependencies as well as linking this as a package.
install:
	raco pkg install --deps search-auto --link $(PWD)/$(PACKAGE-NAME)-{lib,test,doc} $(PWD)/$(PACKAGE-NAME)

remove:
	raco pkg remove $(PACKAGE-NAME)-{lib,test,doc} $(PACKAGE-NAME)

# Primarily for day-to-day dev.
# Build libraries from source.
build:
	raco setup --no-docs --pkgs $(PACKAGE-NAME)-lib

# Primarily for day-to-day dev.
# Build docs (if any).
build-docs:
	raco setup --no-launcher --no-foreign-libs --no-info-domain --no-pkg-deps \
	--no-install --no-post-install --pkgs $(PACKAGE-NAME)-doc

# Primarily for day-to-day dev.
# Build libraries from source, build docs (if any), and check dependencies.
build-all:
	raco setup $(DEPS-FLAGS) --pkgs $(PACKAGE-NAME)-{lib,test,doc} $(PACKAGE-NAME)

# Primarily for CI, for building backup docs that could be used in case
# the main docs at docs.racket-lang.org become unavailable.
build-standalone-docs:
	raco scribble +m --redirect-main http://pkg-build.racket-lang.org/doc/ --htmls --dest ./doc ./aoe2-rms-doc/aoe2-rms/scribblings/aoe2-rms.scrbl

build-markdown-docs:
	raco scribble +m --redirect-main http://pkg-build.racket-lang.org/doc/ --markdown --dest ./md-doc ./aoe2-rms-doc/aoe2-rms/scribblings/aoe2-rms.scrbl

# Primarily for day-to-day dev.
# Note: Also builds docs (if any) and checks deps.
setup:
	raco setup --tidy --avoid-main $(DEPS-FLAGS) --pkgs $(PACKAGE-NAME)

# Note: Each collection's info.rkt can say what to clean, for example
# (define clean '("compiled" "doc" "doc/<collect>")) to clean
# generated docs, too.
clean:
	raco setup --fast-clean --pkgs $(PACKAGE-NAME)-{lib,test,doc}

# Primarily for use by CI, after make install -- since that already
# does the equivalent of make setup, this tries to do as little as
# possible except checking deps.
check-deps:
	raco setup --no-docs $(DEPS-FLAGS) $(PACKAGE-NAME)

# Suitable for both day-to-day dev and CI
test:
	raco test -exp $(PACKAGE-NAME)-{lib,test,doc}

docs:
	raco docs $(PACKAGE-NAME)

.PHONY:	help install remove build build-docs build-all build-standalone-docs clean check-deps test docs
