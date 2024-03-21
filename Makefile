.phony: all

_pos = $(if $(findstring $1,$2),$(call _pos,$1,\
       $(wordlist 2,$(words $2),$2),x $3),$3)
pos = $(words $(call _pos,$1,$2))

# this order matters (long strings must come first)
SOURCES=nongnu #org gnu melpa-stable melpa
URL_PATHS="https://elpa.nongnu.org/nongnu/" "http://orgmode.org/elpa/" "https://elpa.gnu.org/packages/" "rsync://stable.melpa.org/packages/" "rsync://melpa.org/packages/" 
GIT_URL_PATHS="https://elpa.nongnu.org/nongnu/" "http://orgmode.org/elpa/" "https://elpa.gnu.org/packages/" "rsync://stable.melpa.org/packages/" "rsync://melpa.org/packages/" 

CLONE_TARGETS=$(patsubst %,clone-%,$(SOURCES))
RESET_TARGETS=$(patsubst %,git-reset-%,$(SOURCES))
all: $(RESET_TARGETS)

clone-%: elpa-clone.el
	emacs -l elpa-clone.el -nw --batch --eval="(elpa-clone \"$(word $(call pos,$*,$(SOURCES)),$(URL_PATHS))\" \"$(PWD)/$*\")"
git-reset-%: clone-%
	cp $*/.git/config $*-config
	cd $*/ && rm -rf .git
	@echo cd $*/ && git init
	@echo mv $*-config $*/.git/config
	@echo cd $*/ && git add .
	@echo cd $*/ && git commit -m ""
	@echo cd $*/ && git remote add origin <github-uri>
	@echo cd $*/ && git push -u --force origin main
elpa-clone.el:
	wget https://raw.githubusercontent.com/dochang/elpa-clone/master/elpa-clone.el
