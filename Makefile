DOT_FILES = .screenrc .vimrc .gitconfig

all: scr git vim

help:
	cat Makefile

scr: $(foreach f, $(filter .screenrc%, $(DOT_FILES)), link-dot-file-$(f))

vim: $(foreach f, $(filter .vim%, $(DOT_FILES)), link-dot-file-$(f))
	curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh

git: $(foreach f, $(filter .gitconfig%, $(DOT_FILES)), link-dot-file-$(f)) setup-git

setup-git: git-prompt.sh git-completion.bash
	@echo "下記のgit周りの処理を手動で追加"
	cat .bashrc.base

git-prompt.sh:
	wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
	
git-completion.bash:
	wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

.PHONY: clean
clean: $(foreach f, $(DOT_FILES), unlink-dot-file-$(f))
  

link-dot-file-%: %
	@echo "Create Symlink $< => $(HOME)/$<"
	@ln -snf $(CURDIR)/$< $(HOME)/$<

unlink-dot-file-%: %
	@echo "Remove Symlink $(HOME)/$<"
	@$(RM) $(HOME)/$<
