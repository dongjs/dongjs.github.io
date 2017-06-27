Setup
=====

This site is built with Jekyll and React. The static content uses a slightly-
modified version of the Cayman theme.

Since Jekyll and Kramdown do not support markdown footnotes and image captions,
I use pandoc to generate my academic articles.

Because Jekyll and kramdown do not support citations (at least not natively),
my research articles are written in Pandoc markdown and built with a very simple
shell script. Before pushing to GitHub, I refresh my Zotero bibliography, export
it to `/assets/bib/references.bib` and then run `/scripts/article-md-to-html.sh`.
The various Pandoc extensions are invoked within this script. As works-in-
progress, the articles are unstyled (expect with some minimal CSS to keep image
sizes reasonable.

Links:

http://programminghistorian.org/lessons/sustainable-authorship-in-plain-text-using-pandoc-and-markdown
