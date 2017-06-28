#!/bin/sh

# TODO: convert this build script so that it generates ALL markdown files
# within _articles

# Ensure a file is given as an argument
if [ "$#" -ne 1 ] || ! [ -f "$1" ]; then
  echo "Usage: $0 MARKDOWN_FILE" >&2
  exit 1
fi

# Capture the base filename by removing markdown extension
name=$(echo $1 | cut -f 1 -d '.')

echo "Converting $1 to $name.pdf..."
pandoc --toc --css="/assets/css/pandoc.css" --filter pandoc-citeproc -o "$name.pdf" -f markdown+citations+implicit_figures+inline_notes+yaml_metadata_block -s $1
echo "Done!"

# TODO: MS word in way that Caleb will like
echo "Converting $1 to $name.docx..."
pandoc --toc --css="/assets/css/pandoc.css" --filter pandoc-citeproc -o "$name.docx" -f markdown+citations+implicit_figures+inline_notes+yaml_metadata_block -s $1
echo "Done!"

