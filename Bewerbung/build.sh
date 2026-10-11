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
	viewer="${PDF_VIEWER:-evince}"
	if ! command -v "$viewer" >/dev/null 2>&1; then
		echo "PDF ready: $pdf (viewer '$viewer' not found)"
	elif [ -z "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]; then
		echo "PDF ready: $pdf (no display)"
	else
		"$viewer" "$pdf" >/dev/null 2>&1 &
	fi
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
