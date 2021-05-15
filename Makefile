.DEFAULT_GOAL := test

.PHONY: test-vim
test-vim:
	vim --version
	THEMIS_VIM=vim themis

.PHONY: test
test: test-vim
