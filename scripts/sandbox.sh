#!/bin/bash

echo $1
echo "${1%.md}"


PROJECT="/mnt/d/stephen-krewson/Documents/StephenKrewson.github.io"

for f in $(find $PROJECT/_articles/dissertation/ -name "*.md")
do
	$PROJECT/scripts/article-md-to-html.sh $f
	$PROJECT/scripts/article-md-to-pdf-docx.sh $f
done
