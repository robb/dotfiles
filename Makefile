all: link run
.PHONY: all

SHELL := /bin/bash

RUN  = $(wildcard **/*.install)
LINK = $(patsubst %.symlink, ~/%, $(notdir $(wildcard **/*.symlink) $(wildcard **/.*.symlink)))

run: $(RUN)
	@echo $^ | xargs -n 1 $(SHELL)

link: $(LINK)

delete:
	@rm -f $(LINK)

~/%: **/%.symlink
	@ln -sF $(CURDIR)/$< $@
