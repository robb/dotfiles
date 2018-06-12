all: link run
.PHONY: all

SHELL := /bin/bash

LINK = $(patsubst %.symlink, ~/%, $(notdir $(wildcard **/*.symlink) $(wildcard **/.*.symlink)))
RUN  = $(wildcard **/*.install)

~/%: **/%.symlink
	@echo "- Linking $<"
	@ln -sF "$(CURDIR)/$<" "$@"

delete:
	@echo "- Removing linked files"
	@rm -f $(LINK)

link: $(LINK)

run: $(RUN)
	@echo $^ | xargs -n 1 $(SHELL)
