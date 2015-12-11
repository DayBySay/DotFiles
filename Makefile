DOT_FILES = .screenrc .vimrc .gitconfig

all: scr git vim

help:
	cat Makefile

scr: $(foreach f, $(filter .screenrc%, $(DOT_FILES)), link-dot-file-$(f))

vim: $(foreach f, $(filter .vim%, $(DOT_FILES)), link-dot-file-$(f))
	curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh

git: $(foreach f, $(filter .gitconfig%, $(DOT_FILES)), link-dot-file-$(f)) setup-git

setup-git: git-prompt.sh git-completion.bash
	@echo "completionとprompt設定を追加していなければ追加\necho \"#git-completion\\ \nsource ~/DotFiles/git-prompt.sh\\ \nsource ~/DotFiles/git-completion.bash\\ \nGIT_PS1_SHOWDIRTYSTATE=true\\ \nGIT_PS1_SHOWSTASHSTATE=true\\ \nGIT_PS1_SHOWUNTRACKEDFILES=true\\ \nGIT_PS1_SHOWUPSTREAM=auto\"\\ \n >> ~/.bashrc"

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
