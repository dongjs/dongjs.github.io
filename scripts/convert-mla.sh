#!/bin/sh


PROJECT="/mnt/c/Users/stephen-krewson/Documents/StephenKrewson.github.io"

# Ensure a file is given as an argument
if [ "$#" -ne 1 ] || ! [ -f "$1" ]; then
  echo "Usage: $0 MARKDOWN_FILE" >&2
  exit 1
fi

# First substitute out the markdown extension; then canonicalize the name
# we want nothing to break if we call it from the "wrong" subdirectory provided
# that we are at least within the repo

name=$(readlink -f ${1%.md})
echo "Converting $1 to $name.[docx|html|pdf]..."

# For extensions, see: http://pandoc.org/MANUAL.html#pandocs-markdown
# NOTE: the CSS file is given as a relative path because it is just a link
# from the perspective of the site resources (no relation to my dev machine)

# TODO: check against config repo since I have added more pandoc options
# 6/12/18 "smart" option for em-dashes does NOT work with target outputs
# figure out best way to insert unicode em-dash in sublime

# Generate the HTML
pandoc\
	--toc\
	--bibliography="$PROJECT/assets/bib/references.bib"\
	--csl="$PROJECT/assets/bib/modern-language-association-8th-edition.csl"\
	--css="/assets/css/pandoc.css"\
	--filter pandoc-citeproc\
	-o $name.html\
	-f\
	markdown+citations+implicit_figures+inline_notes+yaml_metadata_block\
	-s\
	$1

echo "HTML generated!"

# Generate a PDF LaTeX version
pandoc\
	--toc\
	--bibliography="$PROJECT/assets/bib/references.bib"\
	--csl="$PROJECT/assets/bib/modern-language-association-8th-edition.csl"\
	--filter pandoc-citeproc\
	-o $name.pdf\
	-f\
	markdown+citations+implicit_figures+inline_notes+yaml_metadata_block\
	-s\
	$1

echo "PDF generated!"

# Finally, let's do a word file
pandoc\
	--toc\
	--bibliography="$PROJECT/assets/bib/references.bib"\
	--csl="$PROJECT/assets/bib/modern-language-association-8th-edition.csl"\
	--filter pandoc-citeproc\
	-o $name.docx\
	-f\
	markdown+citations+implicit_figures+inline_notes+yaml_metadata_block\
	-s\
	$1

echo "Word DOCX generated!"

