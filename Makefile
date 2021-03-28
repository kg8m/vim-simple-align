.DEFAULT_GOAL := test

test-vim:
	vim --version
	THEMIS_VIM=vim themis

test: test-vim

.PHONY: test-vim test
