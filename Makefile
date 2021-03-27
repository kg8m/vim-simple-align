.DEFAULT_GOAL := test

test-vim:
	vim --version
	THEMIS_VIM=vim themis

test-nvim:
	nvim --version
	THEMIS_VIM=nvim themis

test: test-vim test-nvim

.PHONY: test-vim test-nvim test
