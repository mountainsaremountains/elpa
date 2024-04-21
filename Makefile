.phony: all

_pos = $(if $(findstring $1,$2),$(call _pos,$1,\
       $(wordlist 2,$(words $2),$2),x $3),$3)
pos = $(words $(call _pos,$1,$2))

# this order matters (long strings must come first)
SOURCES=nongnu org gnu melpa-stable melpa
URL_PATHS="https://elpa.nongnu.org/nongnu/" "http://orgmode.org/elpa/" "https://elpa.gnu.org/packages/" "rsync://stable.melpa.org/packages/" "rsync://melpa.org/packages/" 

CLONE_TARGETS=$(patsubst %,clone-%,$(SOURCES))
RESET_TARGETS=$(patsubst %,git-reset-%,$(SOURCES))
all: $(RESET_TARGETS)

clone-%: elpa-clone.el
	emacs -l elpa-clone.el -nw --batch --eval="(elpa-clone \"$(word $(call pos,$*,$(SOURCES)),$(URL_PATHS))\" \"$(PWD)/$*\")"
# this fires for each stemm but whatever
clean-%: clone-%
	-tar -vf nongnu/pdf-tools-1.1.0.tar --delete pdf-tools-1.1.0/test/encrypted.pdf
git-reset-%: clean-%
	cd $*/ && rm -rf .git
	cd $*/ && git init
	cd $*/ && git add .
	cd $*/ && git commit -m "Snapshot $(shell date +%m-%d-%Y)"
	cd $*/ && git branch -M main
	cd $*/ && git remote add origin "git@github.com:mountainsaremountains/$*.git"
	cd $*/ && git push -u --force origin main
elpa-clone.el:
	wget https://raw.githubusercontent.com/dochang/elpa-clone/master/elpa-clone.el
