#!/bin/bash

# absolute path to top level of repo
PROJECT="/mnt/c/Users/stephen-krewson/Documents/StephenKrewson.github.io"

# move to the dissertation folder, so that image links will resolve properly
# for LaTeX and Word when pandoc goes to compile them
cd $PROJECT/_articles/literary-history

# Loop over all the markdown files that have been changed in last hour
for f in $(find . -mmin -60 -name "*.md")
do
	echo $f
	# render to HTML, PDF, and DOCX
	$PROJECT/scripts/convert-mla.sh $f
done

