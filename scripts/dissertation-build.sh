#!/bin/bash


# turn on "shell options" for recursing through directories
shopt -s globstar

# loop over all markdown files in the dissertation directory
for f in ../_articles/dissertation/**
do
	echo $f
done
