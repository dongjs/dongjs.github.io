About
=====

This site is built with Jekyll and React. The static content uses a slightly-
modified version of the [Cayman theme] for GitHub Pages.

The various tools and dependencies are listed below.

Since Jekyll and Kramdown do not support citations and image captions, I use Pandoc to generate my research articles. These adhere to [Pandoc markdown] and are built with a very simple shell script. Before pushing to GitHub, I refresh my Zotero bibliography, export it to `/assets/bib/references.bib` and then run `/scripts/article-md-to-html.sh MARKDOWN_FILE`. The various Pandoc extensions are invoked within this script. As works-in-progress, the articles are unstyled (excepting some minimal CSS to keep image sizes reasonable).

In building the site, I was revisiting my own efforts (circa 2015) but with a better understanding of both web programming as well as templating frameworks.

While I admire Chris Olah's blog very much, using Haskell's Stack and Hakyll with the Windows subsystem for Linux (WSL) is not workable yet. Even installing Ruby was unexpectedly complex, as `rbenv` does not work.

For excellent explanations of how to use a plaintext workflow, see Nicholas Cifuentes-Goodbody's [YouTube channel] and [this article] by Dennis Tenen and Grant Wythoff.


Tools
=====

WSL
---
* Enable "fast" Insider Preview builds
* Ubuntu (Keep updated with `apt-get update|upgrade`)
* Ruby (N.B. not through `apt-get` or installer, but a managed distro from Bright)


Jekyll
------
* Dependencies: `ruby`, `gem`, `bundler`
* Install: `gem install jekyll`
* Flavor: GitHub Pages, Cayman Theme, Liquid templating


Packages
--------
* `apt-get`: haskell, pandoc, pandoc-citeproc


Text
----
* Vim (`git clone https://github.com/StephenKrewson/config.git` for easy access to customized `.vimrc`)
* Sublime Text 3 (licensed), mostly for the incredible distraction-free mode (`Shift+F11`) and linewrapping
* Pandoc with extensions `citations`, `
* `[pandoc-citeproc]` to power the citations extension

Bibliography
------------
* Zotero (once I committed to pushing my writing to the web in real-time, I was able to abandon EndNote and craft a completely plaintext workflow)
* ZotFile and BetterBib(La)TeX extensions


TODO
====

Research
--------
* Reception of Maria Edgeworth in USA
* Import Hawthorne chapter into markdown
* Type up outline for third chapter
* PDFs into Zotero

Site
----
* ~~Add PDF and DOCX links for all articles~~
* Abstract poetry into "poems" Jekyll collection
* Style research articles using SASS from gh-pages themes (low priority)
* ~~Make header button link to first heading of README~~

<!-- References -->
[Cayman theme]: https://github.com/pages-themes/cayman 
[Pandoc markdown]: http://pandoc.org/MANUAL.html#pandocs-markdown
[pandoc-citeproc]: https://hackage.haskell.org/package/pandoc-citeproc
[YouTube channel]: https://www.youtube.com/channel/UCYspUZGexLdDLjHRkuERQlg/featured
[this article]: http://programminghistorian.org/lessons/sustainable-authorship-in-plain-text-using-pandoc-and-markdown
