About
=====
This site is built with Jekyll and React. The static content uses a slightly-
modified version of the [Cayman theme](https://pages-themes.github.io/cayman/) for GitHub Pages. Details of my environment, toolchain, and dependencies are given below. Mainly, this helps me reproduce functionality (and remember bugs!) when working from a different computer.

My goal is a plaintext workflow that keeps me focused on writing and researching. For excellent guidance--aimed at humanists--on this subject, see Nicholas Cifuentes-Goodbody's [YouTube channel](https://www.youtube.com/channel/UCYspUZGexLdDLjHRkuERQlg) and [this article](https://programminghistorian.org/lessons/sustainable-authorship-in-plain-text-using-pandoc-and-markdown) by Dennis Tenen and Grant Wythoff.

Since Jekyll and Kramdown do not support citations and image captions, I use Pandoc to generate my research articles. These take advantage of [Pandoc-flavored Markdown](http://pandoc.org/MANUAL.html#pandocs-markdown) and are built with a very simple shell script. Before pushing to GitHub, I refresh my Zotero bibliography, export it to `/assets/bib/references.bib` and then run `/scripts/article-md-to-html.sh MARKDOWN_FILE`. The various Pandoc extensions are invoked within this script. As works-in-progress, the articles are unstyled (excepting some minimal CSS to keep image sizes reasonable).

In building the site, I was revisiting my own efforts (circa 2015) but with a better understanding of both web programming as well as templating frameworks. While I was inspired to do this by Chris Olah's blog (and the Distill platform), using Haskell's Stack and Hakyll with the Windows subsystem for Linux (WSL) is not workable yet.

Even installing Ruby and Node on WSL Ubuntu was unexpectedly complex, as `rbenv` and `nvm` either do not work or load extremely slowly (as of Summer 2017). Credit to Microsoft for maintaining a clear [issues tracker](https://github.com/Microsoft/BashOnWindows/issues), however.


System
======

Environment (as of August 2017)
-------------------------------
* Windows 10, Insider Preview Build 15063.540
* Windows Subystem for Linux, Ubuntu 16.04.3 "xenial"
	- Regularly run `sudo apt [update|upgrade|autoremove]`

Tools
-----
* Pandoc
	- Install with `apt-get`
	- Install dependency `haskell-platform` and extension `pandoc-citeproc` with `apt-get` as well
* Sublime Text 3 (registration key not versioned but kept in Dropbox)
* Vim (copy customized `.vimrc` from my [config repo](https://github.com/StephenKrewson/config) to `$HOME`)
* Zotero
	- Sync to account `stephen-krewson`
	- Sync to Box WebDAV server (school email is login, need to restart Zotero a couple of times)
	- Enable Chrome plugin
	- NEW: run updated export from Zotero to `references.bib` in this repo; customize Better BibTex
		* https://retorque.re/zotero-better-bibtex/customized-exports/
	- Install ZotFile and BetterBib(La)TeX extensions
	- https://github.com/retorquere/zotero-better-bibtex/issues/555

Previewing the site with Jekyll
-------------------------------
Jekyll has `make` and `gcc` as [dependencies](https://jekyllrb.com/docs/installation/), so the very first step is to make sure these basic C tools are installed: `sudo apt-get install build-essential`.

The goal is a concise number of steps for reproducing my environment on a new machine. Thus I'm OK with `sudo` installs because tinkering with the `PATH` opens the door to things breaking (`pip`, `apt-get`, etc. should normally be used with the `--user` flag). Similarly, after encountering various permissions and performance issues with Ubuntu's Ruby/rbenv, I followed the advice of several bloggers and installed it as a package from [Brightbox](https://www.brightbox.com/docs/ruby/ubuntu/). See [this guide](https://ntsystems.it/post/Jekyll-on-WSL).

After installing Jekyll and Bundler, run `bundle install` to add the correct dependencies from the project's `Gemfile` and everything is ready. From the top-level directory, run `bundle exec jekyll serve` then navigate to `localhost:4000` in a browser.

Note that file regeneration appears to work, but doesn't actually on WSL. So the general workflow is to work until you've written a decent amoung, preview locally, then push up to GitHub. What this works poorly for is checking CSS adjustments; but the focus should be on writing!


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
* ~~Abstract poetry into "poems" Jekyll collection~~
* Style research articles using SASS from gh-pages themes (low priority)
* ~~Make header button link to first heading of README~~


根目录下config.yml控制页面显示标题和哪些button出现
主页内容在index.html，那里面的标题是现实在浏览器标题栏的标题，不是页面标题
Layout文件夹里default最重要，下面说，其他文件控制每个button点进去以后显示的内容。
default

首页会根据config决定button和内容。点了button以后似乎是先在根目录找对应文件，那个文件会直接添进includes里面对应文件。神奇的是_config.yml里，根目录文件名，includes文件名这三个必须都一样。当然如果要显示文章列表，文件夹名字和site.是怎么对应的？
