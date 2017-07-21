---
layout: post
title: Discovering Duplicate Books with illustra-ligner
---

DRAFT

Stopping to describe what it is I'm doing is one of the ways to keep the research process on-track and enjoyable.

As I return to the `illustra-ligner` project and convert those tools to work with the HathiTrust APIs (next step: build my own book image API, perhaps in collaboration with HTRC), the research rewards are becoming clear. Working with a dataset of all the search results for "Peter Parley" from 1827-1855, patterns of outright reuse and repackaging are obvious.

This emergence is first of all a result of what I have been calling visual search. That is, I cluster all the extracted image details from the Parley dataset and start looking at them. One of the best ways to start the discovery process is by picking a random image (out of the more than 4000 extracted illustrations in my initial dataset). Pretty quickly, I notice a neighborhood with lots of identical copies: the source image is a jungle scene with reptiles.

![](/assets/img/show-neighbors-prototype.png)

What is the relevant type/token distinction here? I created the dataset using HathiTrust's download API. Since HTRC is a consortium of research libraries, I am reasonably sure that they are not giving me back witness copies of the same imprint. Different volumes (this is their term, and refers to a unique ID prepended by an abbreviation for the holding library) are grouped into one record, or text. We will soon see how two volumes digitized from Harvard, `hvd.hn63jm` and `hvd.hn5eb1` are suspiciously alike. But first, how does this grid of 30 thumbnail-sized images interface with standard bibliographic data?

The role that machine learning plays in `illustra-ligner` is to increase the "hit rate" at which a human can spot meaningful (dis)similarities among historical book illustrations. By simplifying the high-dimensional space of a digitized image (i.e. its area in pixels) down to a 2048-dimensional vector, we can provide the human user with "hot spots" that are likely to contain resued or copied or illustrations. What we are looking at with all the pictures of alligators and snakes is one such hot spot. Now its my job as a literary historian to meaningfully connect these thumbnails, using what I know and can find out about 19C print culture.

I designed my `ht_show_neighbors.py` script to also print out basic bibliographic data, using HathiTrust's Solr API. Eventually, there will be a full-fledged UI with zoom capabilities and HTML divs for each of the thumbnails. But for right now, I'm keeping it simple. I use a Python library to generate the thumbnail montage and then print the corresponding metadata for the illustrations to my terminal. Note the use of Anaconda and a specially-created environemnt, `tensorflow`, for keeping track of the tools and libraries that I am using for this project.

![](/assets/img/show-neighbors-bib.png)

The only columns that need explaining are the last three. Third from the right is the ordinal number of each neighbor. Since the neighborhood is of size 30, the original illustration is 0 and then we have neighbors 1 through 29. Neighbor 1 is the closest possible match and Neighbor 29 is the 29th-closest match. Second from the end is a unique local identifier for the volumes in this neighborhood. Since we start at 0 and 11 is the highest number, we can conclude that only 12 different volumes make up the neighborhood (again, a volume is a physical witness that is held at some library and in the majority of cases has been digitized by Google Books). I would like to statistically describe heterogeneity across all neighborhoods, but for now, we can just observe that 12 different books provide the images that most closely match our source image of the reptiles. This is consistent with the hypothesis that the Peter Parley ecosystem was characterized by high rates of reuse and intra-book visual similarity.

Let me highlight the three "matching pairs" that most intrigued me by framing them in same-colored rectangles. As a book historian, I don't care as much about matches that show up in the same publication year. Often, different publishers would distribute the same imprint. Samuel Goodrich, Parley's creator, was adept at this. Conversely, the reappearance of a wood engraving a decade or two later is the start of a story! Geographical shifts in place of publication set off my antennae as well.

![](/assets/img/show-neighbors-highlight.png)

In this genre, the full title is too noisy a source of information to use in discovery phase. Let's consider the three pairs by place and date of publication (the neighbor and volume IDs are given for reference and are annotated in red on the thumbnails themselves). This gives us:

Color | Neighbor | Volume | Place | Date
--- | --- | --- | --- | --- | ---
Red | 0 | 0 | Boston | 1834
Red | 2 | 2 | New York | 1854
Blue | 5 | 5 | Philadelphia | 1847 
Blue | 8 | 6 | Philadelphia | 1832
Purple | 12 | 4 | New York | 1854
Purple | 14 | 1 | Philadelphia | 1834

Keeping in mind that same color means a match between wood engraving, we can further distinguish within the "reused after a long interval" category. In the case of red and purple, New York publishers re-release illustrations first used in Boston and Philadelphia twenty years previously! (likely as part of the same printing/distribution push in 1834). In the case of the blue pair, we have a wood engraving showing up in a book by a different printer in the same city, fifteen years later. 

Now, we have some excellent leads to follow up on. In particular, it seems as if Peter Parley's *The every day book* was repackaged wholesale into an 1850s gift book/annual: *A gift for my young friends*. In the next installment of this post, I'll talk about what I found when I dug deeper into Goodrich's memoirs and the secondary literature on gift books.

I'll also show how I was able to use another tool, `illustration-collation` (developed through a grant from the Yale DH Lab), to load up the image sets from the 1830s and 1850s books and prove that the set of engravings had been completely reused.

In closing, I want to offer a brief motivation for why this approach has advantages that are not offered by textual research.

* Looking at pictures is fun, sensuous, and utilizes our innate human collation skills
* By comparing images and image sets instead of word sequences, we get closer to the mindset of 19C publishers, who often began from the acquisition of a set of engravings and *then* worked to put text in place around them
* Image circulation and reuse is highly predictive of textual reuse, but it *materializes* our idea of what it means to "plagiarize" (and it defamiliarizes the terms of that tired paradigm)

For your perusal, here are the full page images from which the first 15 neighbors were found for the reptiles image:

![](/assets/img/show-neighbors-full-page.png)
