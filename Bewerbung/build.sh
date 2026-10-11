#!/usr/bin/env bash

function compileLanguage {
	project=$1
	language=$2
	cp -a "parameters/build/$language/." "$project/texProject/generated/"
	python translator.py "$language" "$project"
	cd "$project/build/$language"
	latexmk -pdf document
	cd ../../..
}

function openPdf {
	pdf=$1
	if [ -z "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]; then
		echo "PDF ready: $pdf (no display)"
		return
	fi
	if [ -n "${PDF_VIEWER:-}" ]; then
		if command -v "$PDF_VIEWER" >/dev/null 2>&1; then
			"$PDF_VIEWER" "$pdf" >/dev/null 2>&1 &
		else
			echo "PDF ready: $pdf (viewer '$PDF_VIEWER' not found)"
		fi
		return
	fi
	if command -v xdg-open >/dev/null 2>&1; then
		xdg-open "$pdf" >/dev/null 2>&1 &
		return
	fi
	if command -v gio >/dev/null 2>&1; then
		gio open "$pdf" >/dev/null 2>&1 &
		return
	fi
	for candidate in papers evince okular zathura qpdfview atril mupdf xpdf
	do
		if command -v "$candidate" >/dev/null 2>&1; then
			"$candidate" "$pdf" >/dev/null 2>&1 &
			return
		fi
	done
	echo "PDF ready: $pdf (no pdf viewer found)"
}

cd Anhang
latexmk -pdf document
cd ..
TZ='Europe/Berlin' printf -v eudate "%(%Y-%m-%d)T" -1
pdfnameGerman="$eudate Bewerbung Banucu Michael.pdf"
pdfnameEnglish="$eudate Application Banucu Michael.pdf"

langauges=( "German" "English" )
for language in "${langauges[@]}"
do
	python translator.py "$language" "parameters"
	compileLanguage "Anschreiben" "$language"
	compileLanguage "Deckblatt" "$language"
	compileLanguage "Lebenslauf" "$language"
	pdfname="pdfname$language"
	pdftkOutputDir="build/$language"
	mkdir -p "$pdftkOutputDir"
	pdftk "Anschreiben/build/$language/document.pdf" "Deckblatt/build/"$language"/document.pdf" "Lebenslauf/build/$language/document.pdf" Anhang/document.pdf cat output "$pdftkOutputDir/${!pdfname}"
	openPdf "$pdftkOutputDir/${!pdfname}"
done
