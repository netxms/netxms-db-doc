all: prepare html pdf

prepare:
	mkdir -p build

html:
	asciidoctor -b html5 -o build/netxms-data-dictionary.html index.adoc

pdf:
	asciidoctor-pdf -a pdf-style=netxms-theme.yml -a pdf-fontsdir=fonts -o build/netxms-data-dictionary.pdf index.adoc

clean:
	rm -rf build/netxms-data-dictionary.pdf build/netxms-data-dictionary.html
