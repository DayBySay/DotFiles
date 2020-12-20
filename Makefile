DOT_FILES = .vimrc .gitconfig .gitignore_global .tmux.conf .zshrc

all: scr git vim zsh brew tmx

help:
	cat Makefile

zsh: $(foreach f, $(filter .zshrc%, $(DOT_FILES)), link-dot-file-$(f))
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	touch $(HOME)/.zshrc.local

tmx: $(foreach f, $(filter .tmux.conf%, $(DOT_FILES)), link-dot-file-$(f))

vim: $(foreach f, $(filter .vim%, $(DOT_FILES)), link-dot-file-$(f))
	curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh

brew:
	ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
	brew bundle

git: $(foreach f, $(filter .git%, $(DOT_FILES)), link-dot-file-$(f))

.PHONY: clean
clean: $(foreach f, $(DOT_FILES), unlink-dot-file-$(f))

link-dot-file-%: %
	@echo "Create Symlink $< => $(HOME)/$<"
	@ln -snf $(CURDIR)/$< $(HOME)/$<

unlink-dot-file-%: %
	@echo "Remove Symlink $(HOME)/$<"
	@$(RM) $(HOME)/$<
