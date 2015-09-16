---
layout: post
title: My Combinatorics Workflow
---
How many paths are there through an *m x n* matrix, M? Suppose we can only move up and to the right. From (0, 0) to, say, (100, 70) there are an incredible number of paths.

Since the question above is from one of my homeworks, I won't give a solution here! Instead, I want to talk about what I did to quickly and easily calculate solutions of this size using [DataJoy, the online Python and R editor](https://www.getdatajoy.com?r=7eed6c61&rm=d&rs=b).

DataJoy is brought to you by the team at [ShareLaTeX](https://www.sharelatex.com), the fantastic online TeX platform that I have subscribed to for some months now. My new workflow is to have a DataJoy project open beside my ShareLaTeX project in my browser. Though I tend to prefer a Unix-style workflow with lots of shell interaction, this semester I'm a teaching fellow for [CS50](https://cs50.yale.edu) and we're using an online IDE. So for better or for worse, it's a browser-based year.

One great advantage of this is that my work is backed up in the cloud and accessible most everywhere. This is great for my because me two Windows 7 machines are getting older and it's nice to be able to hop onto a school workstation and get to work. I also don't need to worry about keeping a clean, well-equipped, and updated Python + libraries installation(s) on my local machine. For instance, I don't need to have numpy + scipy on my space-limited laptop.

Enter DataJoy.

To get an answer (not the correct one!) on the order of 100 choose 70, I just need to create a Python script in my project that contains the following:



{% highlight python linenos %}

from scipy.special import comb
comb(100, 70, exact=True)

# Out[3]:
# 62757830663187746413533383430396L

{% endhighlight %}

Did I need that 32-digit long for my solution? No--understanding and showing the combinatorial concepts is more important. But it's still fun with DataJoy to be able to get huge solutions like this very quickly and with no overhead on my computer.
