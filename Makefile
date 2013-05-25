DOT_FILES = .screenrc .vimrc .gitconfig

all: scr vim git

scr: $(foreach f, $(filter .screenrc%, $(DOT_FILES)), link-dot-file-$(f))

vim: $(foreach f, $(filter .vim%, $(DOT_FILES)), link-dot-file-$(f))

git: $(foreach f, $(filter .gitconfig%, $(DOT_FILES)), link-dot-file-$(f))
  
.PHONY: clean
clean: $(foreach f, $(DOT_FILES), unlink-dot-file-$(f))
  

link-dot-file-%: %
	@echo "Create Symlink $< => $(HOME)/$<"
	@ln -snf $(CURDIR)/$< $(HOME)/$<

unlink-dot-file-%: %
	@echo "Remove Symlink $(HOME)/$<"
	@$(RM) $(HOME)/$<
