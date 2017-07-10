---
layout: post
title: Modular Exponents in Racket
---

DRAFT

Come August, I'll be back as the TF for [CS201](http://zoo.cs.yale.edu/classes/cs201/index.html), which is taught in Racket. As a way of refreshing my functional programming (FP) memory, I want to implement efficient algorithms for:

* Raising a base to a power: $$x^n$$
* Taking exponents modulo some number: $$x^n \mod p$$

The constraint is that both functions must run in $$O(\log n)$$ time (whenever I refer to $$\log$$ in this post, I mean $$log_2$$). The identical time complexities hint that we can solve both problems with the same basic approach.

Along the way, I want to introduce some practical tips:

* how to write clean Racket code
* how to convert a function to tail-recursive form
* how to sketch an inductive proof
* how to look up the source code for built-in functions such as `expt`
* how to profile your own code
* how to consult reference works to check the efficiency of your algorithm


Exponents
---------
In Lisp-based languages, the purely recursive solution to $$x^n$$ is elegant; however, it runs in linear time (there are $$n$$ multiplications).

{% highlight racket linenos %}

; recursive O(exp) solution
(define (power base exp)
  (cond
    [(= exp 0) 1]
    [else (* base (power base (sub1 exp)))]))

{% endhighlight %}

One way to improve on the memory demands of `power1` is to make it tail-recursive, so that the the multiplication operation does not have to wait around for the result of the recursive call to bubble back up. We can keep the canonical signature in a wrapper, `pow1`, and then add a parameter that remembers the running total:

{% highlight racket linenos %}

; tail-recursive O(exp) solution
; wrapper for keeping the function signature clean
(define (pow1 base exp)
  (power1 base exp 1))

; note how final application is simply procedure itself
(define (power1 base exp result)
  (cond
    [(= exp 0) result]
    [else (power1 base (sub1 exp) (* base result))]))

{% endhighlight %}

Can we do even better? Think about an expression like $$3^4$$. We could rewrite this as $$3^2 \times 3^2$$, using the identity $$a^b = a^{b/2}a^{b/2}$$. Recursively, $$b/2$$ will become the new $$b$$ and we will continue until $$b = 0$$. This will take $$\log b$$ steps.

{% highlight racket linenos %}

; tail-recursive O(log exp) solution using identity a^b = a^(b/2)*a^(b/2) 
(define (pow2 base exp)
  (power2 base exp 1))

(define (power2 base exp result)
  (cond
    [(= exp 0) result]
    [(odd? exp) (power2 (* base base) (quotient exp 2) (* base result))]
    [else (power2 (* base base) (quotient exp 2) result)]))

{% endhighlight %}

Why does this work? Notice that `base` is multiplied with its current value at each level of the recursion. This squared value becomes the new base. We have already shown that there will be $$\log exp$$ levels, since we are repeatedly dividing `exp` by two and then truncating (incidentally, this is why we need to use `quotient` and not `/`). We can represent the successive squarings of `base` by writing $$2$$ raised to the power $$\log exp$$. Since the original root is `base`, we then have:  

$$base^{2^{\log_2 exp}} = base^{exp}$$

This is because $$a^{\log_a x} = x$$ from the definition of what a logarithm is (i.e. the undoing of exponentiation). So we can be satisfied that the updates to `base` in the recursive calls are correct and will yield an answer of the right magnitude. But what about `result` and the `odd?` predicate?

Notice that in my example of $$3^4$$ decomposing into two halves of $$3^2$$, everything is nice and symmetrical. But what about $$3^5$$ or $$3^{13}$$? It's easier to consider the case $$3^1$$. In fact, as we divide `exp` by two, the final two values of `exp` will inevitably be $$1$$ and $$0$$. You can verify this for yourself by checking the odd and even cases. When `exp` equals one, we can think of there being an extra `base` factor hanging around that needs to be incorporated into the result of the exponentiation.

Put more generally, the number of times that the `odd?` predicate will evaluate to true is a measure of how far `exp` is from being a power of 2 (in which case we could imagine a perfectly balanced binary tree being combined into the solution: the leaves have the value `base` and these join with their siblings to become $$base^2$$ and in turn $$base^4$$ and $$base^8$$ and so on). But to evaluate something like $$3^7$$, there are three extra `base` factors hanging around since seven is not quite $$2^3 = 8$$. In fact, when the initial value of `exp` is of the form $$2^{n} - 1$$, `exp` will *always* be odd until the maximum depth is reached and `exp` is 0. The values of the arguments throughout the computation (for our $$3^7$$ example) are:


`depth` | `exp` | `odd?` | `base` | `result`
--- | --- | --- | --- | ---
0 | 7 | `true` | 3 | 1
1 | 3 | `true` | 9 | 3
2 | 1 | `true` | 81 | 27
3 | 0 | `false` | 6561 | 2187

At the top level (`depth` = 0), we have an odd exponent, so we need to update `result` so that at the next call (`depth` = 1) the "missing" factor is accounted for (again, by "missing" I mean "distance from being a perfect power of 2"). How many factors we are missing scales with $$2^{depth}$$ since this is a doubling algorithm. Thus, we pick up $$2^{1} = 2$$ of the three missing 3's when we are at `depth` 1 and `odd?` is `true`. The exact same insight would apply to $$3^{1023}$$ or any base raised to an arbitrarily large odd exponent: since `base` can only take on values of the form $$base^{2^{depth}}$$, we need to pick up $$2^{depth}$$ of the missing original `base` factors at that depth and fold them into `result`. By the way, this is the motivation for returning `result` and not `base` in the terminating case.


Modular exponents
-----------------
As it turns out, we can use the structure of `power2` to solve a related problem: what is the value of $$x^n$$ modulo some integer $$p$$? The very helpful [algorithms compendium](http://www.geeksforgeeks.org/modular-exponentiation-power-in-modular-arithmetic/) at Geeks for Geeks explains the practical importance of being able to calculate this quickly.

TODO: linger on this and show the C and Racket source code for `expt`.

Moving on to the algorithm, we have a wrapper function `pow3` that hides the `result` parameter. If your recursion involves multiplication, the initial value of your accumulator (here it's called `result`) is typically 1. Why? A related question: what would be a good initial value for the running total if the algorithm involved addition?

{% highlight racket linenos %}

; for x^n % p, if x > p, we can just evaluate (x % p)^n % p 
(define (pow3 base exp p)
  (power3 (modulo base p) exp 1 p))

{% endhighlight %}

Lingering on this simplification will give us a way into the modular arithmetic identities we'll use for the main algorithm. Why are we allowed to substitute `base` modulo `p` for `base`? Doing so implies that $$base^{exp} \pmod p = (base \pmod p)^{exp} \pmod p$$. Or, using the congruency symbol:

$$base^{exp} \equiv (base \pmod p)^{exp} \pmod p$$

Here's a concrete example. The claim is that $$5^4 \pmod 3 = 2^4 \pmod 3$$ since $$5 \pmod 3 = 2$$ (this is the substitution that `pow3` performs). As a sanity check:

$$\begin{align}

5^4 &= 625\\
3 \times 208 &= 624\\
625 \pmod 3 &= 1\\

2^4 &= 16\\
3 \times 5 &= 15\\
16 \pmod 3 &= 1\\

\end{align}$$

For me, it wasn't immediately obvious that this relation should hold for any value of $$p$$. Breaking it down, an inductive proof suggests itself when you consider that the value of the exponent is irrelevant:

$$5 \times 5 \ldots \times 5 \pmod 3 = x\\
2 \times 2 \ldots \times 2 \pmod 3 = x$$

As we hold $$p = 3$$ constant, we can pile up $$n$$ 5's on the top row and $$n$$ 2's on the bottom row and they will always have the same answer modulo 3. Adding an $$(n+1)$$-th 5 and 2, respectively, will preserve the congruence. We can get the induction going by considering the base case for our example:

$$5^1 \equiv 2^1 \pmod 3$$

This follows immediately from the definition of the modulo operation. Clearly, $$a$$ "wraps around" $$p$$ the same distance that $$a \pmod p$$ does. Put another way, the remainder of $$a / p$$ is congruent (modulo $$p$$) to $$a$$ itself, since this remainder is what defines the value of $$a \pmod p$$ in the first place. Basically, after having proved the base case $$n = 1$$, we want to show that adding a factor preserves the congruency. The statement $$a^n \equiv b^n \pmod p$$ is the inductive hypothesis. Having assigned $$b := a \pmod p$$ we claim that:

$$\begin{align}
a &\equiv b \pmod p\\
a^n &\equiv b^n \pmod p\\
a^{n+1} &\equiv b^{n+1} \pmod p
\end{align}$$

Let's switch up our notation slightly so that we don't need to work with exponents. We can set $$x := a^n$$ and $$y := b^n$$ (remember that this is for some arbitary value of $$n \in \mathbb{N}$$). Now we just need to prove that it follows that $$ax \equiv by \pmod p$$. Using our updated notation, we will show that the congruences can be multiplied (much like two equalities). In fact, the proof involves briefly moving out of the congruence notation and into that of equalities. Consider that if $$a \equiv b \pmod p$$ then $$b$$ can be expressed as the sum of $$a$$ and some multiple of $$p$$:

$$b = a + pc | c \in \mathbb{Z}$$

We keep it simple by also only using integers (the set $$\mathbb{Z}) for all bases, exponents, and values of $$p$$. The intuition is that $$a$$ and $$b$$ remain the same number of "spots" from all the multiples of $$p$$ on the number line. We can express both the following congruences in this new form:

$$\begin{align}
a &\equiv b \pmod p\\
x &\equiv y \pmod p\\
b &= a + pc_1 | c_1 \in \mathbb{Z}\\
y &= x + pc_2 | c_2 \in \mathbb{Z}\\
\end{align}$$

Since we are allowed to multiply equalities, we distribute and then factor out a $$p$$:

$$\begin{align}
by &= (a + pc_1)(x + pc_2)\\
by &= ax + apc_2 + xpc_1 + p^2c_1c_2\\
by &= ax + p(ac_2 + xc_1 + pc_1c_2)\\
c_3 &:= (ac_2 + xc_1 + pc_1c_2)\\
by &= ax + pc_3 | c_3 \in mathbb{Z}\\
by &\equiv ax \pmod p
\end{align}$$

We've just shown that we can obtain an equality in terms of $$ax$$ and $$by$$ that is identical to the form used to convert *to* an equality *from* a congruence: namely, a remainder added to a multiple of $$p$$. This implies that $$ax$$ is congruent to $$by$$ modulo $$p$$ and vice versa. If we recall that $$x = a^n$$ and $$y = b^n$$, we've shown that if $$a^n \equiv b^n \pmod p$$ then it follows that:

$$a^{n+1} \equiv b^{n+1} \pmod p$$

That completes the inductive proof that we can simplify `base` to `base` modulo `p` in `pow3`. Whew! In general, what you should remember is the following identity (which is more general and less confusing):

$$(a \pmod p)(b \pmod p) \equiv ab \pmod p$$

Melvin Hausner has an excellent [set of notes](http://www.math.nyu.edu/faculty/hausner/congruence.pdf
) on the basics of modular arthmetic; they were helpful in formulating and checking this post.

We can actually use the just-mentioned form to complete our $$O(\log exp)$$ solution for modular exponentiation. Since 

{% highlight racket linenos %}
; as before, this has complexity O(log exp)!
(define (power3 base exp result p)
  (cond
    [(= exp 0) result]
    [(odd? exp)
    	(power3 
    		(modulo (* base base) p)
    		(quotient exp 2)
    		(modulo (* base result) p)
    		p)]
    [else
    	(power3
    		(modulo (* base base) p)
    		(quotient exp 2)
    		result
    		p)]))
{% endhighlight %}

Note that this function has the desired $$O(\log_2 \text{exp})$$ time complexity, but we are just using Racket's built-in `modulo` operator. Can we do better, following a trick of Hausner?
