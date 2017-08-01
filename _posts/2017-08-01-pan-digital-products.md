---
layout: post
title: Fidning pan-digital products with Racket
---

One of the highlights of middle weeks of CPSC 201 is the `allSubsets` procedure. Students develop a recursive solution for generating all subsets (up to length $$n$$) of a simple alphabet such as $${a,b}$$ or $${0,1}$$.

The binary version is nice because it focuses attention on the base case, which is an empty nested list. By distributing the alphabet onto the base list, and then prepending these new strings onto the initial, empty list-of-lists, we get all subsets of length 1 and the null set:

{% highlight racket %}

'((0), (1)), ())

{% endhighlight %}

