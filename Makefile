#EXTENDED=yes

ifeq ($(EXTENDED),)
   OPTS =
else
   OPTS = -a extended
endif


OPTS:=$(OPTS) -a revdate="$(shell date +"%d %B, %Y")" --failure-level WARN -v

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	WATCHCMD=fswatch -r -e '\.swp' -e '\.git' -e build . | xargs -n1 -I{} make html
	WATCHCMD_PDF=fswatch -r -e '\.swp' -e '\.git' -e build . | xargs -n1 -I{} make pdf
else
	WATCHCMD=inotifywait -q -m -r --format gotchange --exclude '\.swp' --exclude '\.git' --exclude build -e modify | xargs -n1 -I{} make html
	WATCHCMD_PDF=inotifywait -q -m -r --format gotchange --exclude '\.swp' --exclude '\.git' --exclude build -e modify | xargs -n1 -I{} make pdf
endif

all: prepare html pdf

.PHONY: prepare
prepare:
	mkdir -p build
	bundle install
	bundle binstubs --all

html:
	bundle exec asciidoctor -r ./lib/stats.rb -a html $(OPTS) -b html5 -a docinfo=shared -o build/netxms-data-dictionary.html index.adoc

pdf:
	#asciidoctor-pdf -a pdf-style=netxms-theme.yml -a pdf-fontsdir=fonts -o build/netxms-data-dictionary.pdf index.adoc
	bundle exec asciidoctor-pdf --theme netxms -a pdf-themesdir=themes -a pdf-fontsdir=fonts -o build/netxms-data-dictionary.pdf index.adoc

clean:
	rm -rf build/netxms-data-dictionary.pdf build/netxms-data-dictionary.html

watch:
	$(WATCHCMD)

watch-pdf:
	$(WATCHCMD_PDF)
