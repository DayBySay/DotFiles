DOT_FILES = .screenrc .vimrc .gitconfig .gitignore_global .tmux.conf .zshrc keyremap.xml

all: scr git vim zsh

help:
	cat Makefile

zsh: $(foreach f, $(filter .zshrc%, $(DOT_FILES)), link-dot-file-$(f))

scr: $(foreach f, $(filter .screenrc%, $(DOT_FILES)), link-dot-file-$(f))

tmx: $(foreach f, $(filter .tmux.conf%, $(DOT_FILES)), link-dot-file-$(f))

vim: $(foreach f, $(filter .vim%, $(DOT_FILES)), link-dot-file-$(f))
	curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh

keyremap: link-keyremap

git: $(foreach f, $(filter .git%, $(DOT_FILES)), link-dot-file-$(f)) setup-git

setup-git: git-prompt.sh git-completion.bash
	@echo "下記のgit周りの処理を手動で追加"
	cat .bashrc.base

git-prompt.sh:
	wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
	
git-completion.bash:
	wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

brew:
	ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
	brew tap caskroom/cask
	brew install caskroom/cask/brew-cask
	brew tap Homebrew/brewdler

.PHONY: clean
clean: $(foreach f, $(DOT_FILES), unlink-dot-file-$(f))
  

link-dot-file-%: %
	@echo "Create Symlink $< => $(HOME)/$<"
	@ln -snf $(CURDIR)/$< $(HOME)/$<

unlink-dot-file-%: %
	@echo "Remove Symlink $(HOME)/$<"
	@$(RM) $(HOME)/$<

link-keyremap:
	echo "Create Symlink Keymap"
	ln -snf $(CURDIR)/keyremap.xml $(HOME)/Library/Application\ Support/Karabiner/private.xml 

test:
	git add . && git commit -m "a" && git push origin karabiner
