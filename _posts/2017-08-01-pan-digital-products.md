---
layout: post
title: Finding pan-digital products with Racket
---

DRAFT

One of the highlights of middle weeks of CPSC 201 is the `allSubsets` procedure. Students develop a recursive solution for generating all subsets (up to length $$n$$) of a simple alphabet such as $$\{a,b,c\}$$ or $$\{0,1\}$$.

The binary version is nice because it focuses attention on the base case, which is an empty nested list. By distributing the alphabet onto the base list, and then prepending these new strings onto the initial, empty list-of-lists, we get all subsets of length 1 and the null set:


{% highlight racket %}

; start with empty nested list
(())

; take car of list and append each symbol in alphabet onto its elements
; prepend new set onto old set
(((0), (1)), ())

; repeat the algorithm on the car of the new result
(((0, 0), (0, 1), (1, 0), (1, 1)), ((0), (1)), ()

{% endhighlight %}


But what if the alphabet has more than two or three symbols in it? We know that there are $$2^n$$ subsets of up to length $$n$$ for a binary alphabet. When dealing with the base 10 numeral system, there are $$10^n$$ subsets. This is quite a large number! In fact, it simply counts EVERY natural number from [0, $$10^n$$). For example, for strings up to length 2 there are 100 subsets given the alphabet $$\{1,...,9\}$$: namely, the numbers from 0 to 99. Note that 0 is technically 00, since it represents the case of deciding twice in a row to NOT select a symbol from the alphabet. But as with the binary case, we don't show the leading 0's by convention.

The steps of our algorithm imply an inner and an outer loop. We are looping over each element in the first element of the result. That's the outer loop; if we are at step $$i$$ then these elements will all be of length $$i - 1$$. The inner loop is over the symbols in the alphabet. We have $$k$$ choices for augmenting the selected lists from length $$i-1$$ to length $$i$$, where $$k$$ is the size of the alphabet.

In Racket, you can use `map` twice in order to get a nested list. See my code for Project Euler problem 32 [here](https://github.com/StephenKrewson/euler/blob/master/032-pan-digital.rkt). In my comments to this file, I discuss a modification (using `filter`) by which we can generate only those subsets that do not repeat any digits. 
