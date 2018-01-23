#!/bin/sh

# the drive will change depending on which computer...
PROJECT="/mnt/c/Users/stephen-krewson/Documents/StephenKerwson.github.io"

# Ensure a file is given as an argument
if [ "$#" -ne 1 ] || ! [ -f "$1" ]; then
  echo "Usage: $0 MARKDOWN_FILE" >&2
  exit 1
fi

# First substitute out the markdown extension; then canonicalize the name
# we want nothing to break if we call it from the "wrong" subdirectory provided
# that we are at least within the repo

name=$(readlink -f ${1%.md})
echo "Converting $1 to $name.pdf"

# For extensions, see: http://pandoc.org/MANUAL.html#pandocs-markdown
# NOTE: the CSS file is given as a relative path because it is only incorporated
# in localhost or on the website (not in the compilation)

# for resizing img: pandoc.org/MANUAL.html#images

# Generate a PDF LaTeX version
pandoc\
	--number-sections\
	--bibliography="$PROJECT/references.bib"\
	--filter pandoc-citeproc\
	-o $name.pdf\
	-f\
	markdown+citations+implicit_figures+inline_notes+yaml_metadata_block+link_attributes+simple_tables\
	-s\
	$1

echo "PDF generated!"

