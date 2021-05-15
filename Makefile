.DEFAULT_GOAL := test

.PHONY: test-vim
test-vim:
	vim --version
	THEMIS_VIM=vim themis

.PHONY: test-nvim
test-nvim:
	nvim --version
	THEMIS_VIM=nvim themis

.PHONY: test
test: test-vim test-nvim
