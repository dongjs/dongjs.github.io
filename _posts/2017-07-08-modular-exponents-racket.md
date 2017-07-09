---
layout: post
title: Modular Exponents in Racket
---

DRAFT

Come August, I'll be back as the TF for [CS201](http://zoo.cs.yale.edu/classes/cs201/index.html), which is taught in Racket. As a way of refreshing my FP memory, I want to implement efficient algorithms for:

* Exponents: $$x^n$$
* Taking exponents modulo some number: $$x^n \mod p$$

The constraint is that both functions must run in $$O(\log n)$$ time. Right away, this suggests that we can solve both problems with the same basic approach. Let's start with the first one, then use some modular arithmetic to adapt for the second operation.

In Racket, the purely recursive solution for $$x^n$$ is elegant; however, it runs in linear time (there are $$n$$ multiplications).

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

Can we do even better?

Think about an expression like $$3^4$$. We could rewrite this as $$3^2 \times 3^2$$, using the identity $$a^b = a^{b/2} \times a^{b/2}$$. Recursively, $$b/2$$ will become the new $$b$$ and we will continue until $$b = 0$$. This will take $$\log_2 b$$ steps.

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

Why does this work? Notice that `base` is multiplied with itself at each level of the recursion. We have already shown that there will be $$\log_2 exp$$ levels, since we are repeatedly dividing `exp` by two and then truncating (incidentally, this is why we need to use `quotient` and not `/`). We can represent the successive squarings of `base` by using $$2$$ raised to the power $$\log_2 exp$$. Since the original root is `base`, we then have:  

$$base^{2^{\log_2 exp}} = base^{exp}$$

This is because $$a^{\log_a x} = x$$ by definition of what a logarithm is. So we can be satisfied that the updates to `base` in the recursive calls are correct and will yield an answer of the right magnitude. But what about `result` and the `odd?` predicate?

Notice that in my example above of $$3^4$$ decomposing into two halves of $$3^2$$, everything is nice and even and symmetrical. But what about $$3^5$$? It's easier to consider the case $$3^1$$. In fact, as we divide `exp` by two, the final two values of `exp` will inevitably be $$1$$ and $$0$$. You can verify this for yourself by checking the odd and even cases. When `exp` equals one, we can think of there being an extra `base` hanging around that needs to be incorporated into the result of the exponentiation.

Put another way, the number of times that the `odd?` predicate will evaluate to true is a measure of how far `exp` is from being a power of 2 (in which case we can imagine a perfectly balanced binary tree being combined into the solution: the leaves have the value `base` and these join with their siblings to become $$base^2$$ and in turn $$base^4$$ and $$base^8$$ and so on). But to evaluate something like $$3^7$$, there are three extra `base`'s hanging around since seven is not quite $$2^3 = 8$$.  

http://www.math.nyu.edu/faculty/hausner/congruence.pdf



http://www.math.nyu.edu/faculty/hausner/congruence.pdf
