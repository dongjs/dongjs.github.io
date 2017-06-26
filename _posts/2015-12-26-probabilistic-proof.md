---
layout: post
title: Ramsey Theorey Proof
---

Here's a cool proof that uses probabilistic methods. The theorem is due to [Alon and Linial](http://www.sciencedirect.com/science/article/pii/0095895689900713) (1989) and the proof was explained by Prof. Asaf Ferber in MATH 244.

Theorem. *Let $$k \in \mathbb{N}$$ where $$n$$ is large enough with respect to $$k$$ (that is, it falls within our Ramsey bounds). Let $$G$$ be a graph on $$n$$ vertices which is $$d$$-regular with $$d = 2k \ln{n}$$. Then $$G$$ contains a cycle of length divisible by $$k$$.*

*Proof*. Step 1. Every *oriented* graph with minimum "out degree" $$\geq 1$$ contains a cycle. Why? Pick an arbitrary starting vertex. Follow its out edge to $$v_2$$. Now go outward from $$v_2$$ to $$v_3$$. You can proceed in this fashion along at most $$n$$ edges before you MUST return to an already-visited vertex.

Step 2. We show that there exists a $$k$$-coloring of the vertices of $$G$$ with the colors $$\{1,\dotsc,k\}$$ such that in each neighborhood every color appears at least once. Or at least we will show that the probability of this NOT happening is less than 1. Let $$c(v)$$ denote the color of some vertex $$v$$.

Step 3. Define an oriented graph $$H$$ on the same vertex set as $$G$$ in the following way. Add the edge $$\overrightarrow{uv} \iff uv \in E(G)$$ AND $$c(v) = c(u) + 1 (\mod k)$$. That is, if $$u$$ is colored with the $$k$$-th color, then $$c(v) = k + 1 \mod k = 1$$.

It follows from Step 1 that $$H$$ has minimum out degree at least 1 and therefore contains a cycle. Moreover, such a cycle must be divisible by k. This is true by the construction of $$H$$! Without loss of generality, suppose we start at a vertex with color 1. We can only get back to that vertex from a vertex with color $$k$$. And we can only move from our starting vertex to vertices colored with color 2 (and, in general, to a color we have not used yet). We need to move through all $$k$$ colors before ending up back where we started!

Now we need to prove that the coloring described in Step 2 exists. Define $$c$$ as follows. Each vertex picks a color from $$\{1,\dotsc,k\}$$ uniformly and independently at random. We define the event $$A_v$$ to be the case in which the neighborhood $$N(v)$$ of a vertex $$v$$ is MISSING a color. Specifically, the color $$c(v) + 1 (\mod k)$$. This would have meant that we could not have drawn a directed edge in Step 3.

If we can show that the probability of the union of all $$A_v$$'s is smaller than 1, then as a consequence the probability of the intersection of the complements (``all vertices DO have a neighborhood with all $$k$$ colors'') is non-zero! As before, we use the union bound and want to show that

$$P(\bigcup_{v \in V(G)} A_v) \leq \displaystyle\sum_{v \in V(G)} P(A_v) < 1$$

It will be enough to demonstrate that each $$P(A_v)$$ in the summation has a value less than $$1 \over{n}$$ where $$\mid V(G) \mid = n$$. We can think of $$P(A_v)$$ as being

$$k \cdot {(1 - {1\over{k}})}^d$$

because we first must fix the vertex $$v$$ with one of the $$k$$ colors. Then, since $$G$$ is $$d$$-regular, we repeat $$d$$ trials in which we are trying to NOT pick for the neighbor vertex $$u$$ the one color in the set of $$k$$ such that $$c(u) = c(v) + 1$$.

We can use what Jeremy Kun has called ``The Inequality'' in an illuminating [blog post](http://jeremykun.com/2015/11/23/the-inequality/) that explains the inequality's relation to probability: $$1 - x \leq e^{-x}$$. Then we can substitute in $$d = 2k \ln{n}$$. And since $$e^{\ln{n}} = n$$:

$$k \cdot {(1 - {1\over{k}})}^d \leq k \cdot e^{-({d\over{k}})}$$

$$\leq k \cdot e^{-({ {2k \cdot \ln{n}} \over {k}})}$$

$$\leq k \cdot e^{-({2 \cdot \ln{n}})}$$

$$\leq k \cdot n^{-2}$$

$$\leq {k \over{n^{2}}}$$

Since we defined the coloring to be at most the size of the vertex set of $$G$$ ($$k \leq n$$), then $$k\over{n^{2}}$$ is less than 1! So $$\displaystyle\sum_{v \in V(G)} P(A_v) < 1$$. And there is a non-zero probability that the coloring sketched out in Step 2 exists.

Thus $$G$$ contains a directed cycle that is divisible by $$k$$. And we're done! :eyeglasses:
