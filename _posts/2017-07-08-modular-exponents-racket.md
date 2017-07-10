---
layout: post
title: Modular Exponents in Racket
---

DRAFT

Come August, I'll be back as the TF for [CS201](http://zoo.cs.yale.edu/classes/cs201/index.html), which is taught in Racket. As a way of refreshing my FP memory, I want to implement efficient algorithms for:

* Exponents: $$x^n$$
* Taking exponents modulo some number: $$x^n \mod p$$

The constraint is that both functions must run in $$O(\log n)$$ time. When I refer to $$\log$$ in this post, I mean $$log_2$$. It's cleaner to write it without an explicit base! Right away, this suggests that we can solve both problems with the same basic approach. Let's start with the first one, then use some modular arithmetic to adapt for the second operation.


Exponents
---------
In Lisp-based languages, the purely recursive solution for $$x^n$$ is elegant; however, it runs in linear time (there are $$n$$ multiplications).

{% highlight racket linenos %}

; recursive O(exp) solution
(define (power base exp)
  (cond
    [(= exp 0) 1]
    [else (* base (power base (sub1 exp)))]))

{% endhighlight %}

One way to improve on the memory demands of `power1` is to make it tail-recursive, so that the the multiplication operation does not have to wait around for the results of the recursive call to bubble back up. We can keep the canonical signature in a wrapper, `pow1`, and then add a parameter that remembers the running total:

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
As it turns out, we can use the structure of `power2` to solve a related problem: what is the value of $$x^n$$ modulo some integer $$p$$? The very helpful [algorithms compendium](http://www.geeksforgeeks.org/modular-exponentiation-power-in-modular-arithmetic/) at Geeks for Geeks explains the practical importance of being able to calculate this quickly. TODO: say more about this.

Let's present the algorithm and then step through how it is different from `power2`. Again, we have a wrapper function `pow3` that hides the `result` parameter.

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

This follows immediately from the definition of the modulo operation. Clearly, $$a$$ "wraps around" $$p$$ the same distance that $$a \pmod p$$ does. Put another way, the remainder of $$a / p$$ is congruent (modulo $$p$$) to $$a$$ itself, since this remainder is what defines the value of $$a \pmod p$$ in the first place.

Basically, after having proved the base case $$n = 1$$, we want to show that adding a factor preserves the congruency. The statement $$a^n \equiv b^n \pmod p$$ is the inductive hypothesis. Having assigned $$b := a \pmod p$$ we claim that:

$$\begin{align}

a &\equiv b \pmod p\\
a^n &\equiv b^n \pmod p\\
a^{n+1} &\equiv b^{n+1} \pmod p

\end{align}$$







Let's simplify our notation and group together what we know.
Next we introduce one of the fundamental identities of modular arithmetic:

$$(a \pmod p)(b \pmod p) \equiv (ab \pmod p) \pmod p$$






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




http://www.math.nyu.edu/faculty/hausner/congruence.pdf
http://www.math.nyu.edu/faculty/hausner/congruence.pdf
