---
layout: post
title: log
---

Dec 18, 2023

According to [here](https://docs.mathjax.org/en/latest/web/configuration.html#configuration-using-an-in-line-script), added the following to layout file
```
    <script>
    MathJax = {
      tex: {
        inlineMath: [['$', '$'], ['\\(', '\\)']]
      }
    };
    </script>
    <script type="text/javascript" async
      src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js">
    </script>
```
Consequence:
- Upgrading from v2 to v3
- Latex now only need single $

Remaining issue:
- Need to do `$S=\\{0,1\\}$` instead of `$S=\{a\}$` to show $S=\{a\}$. However, `$$S=\{a\}$$` works fine while `$$S=\\{a\\}$$` shows $S=a$. Possible issue is inlineMath and displayMath are configured differently. [All available options](https://docs.mathjax.org/en/latest/options/input/tex.html) may have to look at [config files](https://docs.mathjax.org/en/v2.7-latest/config-files.html#the-tex-mml-am-chtml-configuration-file)

At this point this is the only difference between hackmd and local. Safe to edit in hackmd and replace `\{` with `\\{`.

Can upload hidden webpage. Anything in `_config.yml` will be processed. Only links in `index.html` will be shown.

Can use `$$\newcommand$$`

Centering is simply unavailable in markdown. Must use html.

Image is available. `![any text](/assets/img/thanos.png)`. Note that hackmd image url doesn't directly work. Must visit that image address and generate a long address.

Pretty diagrams and flow charts: https://hackmd.io/c/tutorials/%2Fs%2FMathJax-and-UML

---


The logic:
- index.html: top goes to layout folder, then for loop finds config.yml. Each item in config.yml shows up as a section. The for loop



IMPORTANT: don't rely on commenting out. It's hard to tell when it works and when it doesn't.

<!-- 根目录下config.yml控制页面显示标题和哪些button出现
主页内容在index.html，那里面的标题是现实在浏览器标题栏的标题，不是页面标题
Layout文件夹里default最重要，下面说，其他文件控制每个button点进去以后显示的内容。
default

首页会根据config决定button和内容。点了button以后似乎是先在根目录找对应文件，那个文件会直接添进includes里面对应文件。神奇的是_config.yml里，根目录文件名，includes文件名这三个必须都一样。当然如果要显示文章列表，文件夹名字和site.是怎么对应的？ -->


# layout here doesn't really matter. Specify layout at the beginning of every post
# output: true I also don't know what it is
# I don't know how to do the order...
# When working locally, if something unexpected happens, delete the site folder and restart the server

config.yml defines the namespace...

markdown layout must match one html file in layouts folder. html in layouts folder can be based on other html in layouts folder. For example post.html = layout: computermodern (which is basically just font) + link back to home "Jinshuo's Blog" Similar for poem.html