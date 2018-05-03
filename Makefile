all: link run
.PHONY: all

SHELL := /bin/bash

LINK = $(patsubst %.symlink, ~/%, $(notdir $(wildcard **/*.symlink) $(wildcard **/.*.symlink)))
RUN  = $(wildcard **/*.install)

~/%: **/%.symlink
	@ln -sF $(CURDIR)/$< $@

delete:
	@rm -f $(LINK)

link: $(LINK)

run: $(RUN)
	@echo $^ | xargs -n 1 $(SHELL)
