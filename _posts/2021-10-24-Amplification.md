---
author:
- Jinshuo Dong
bibliography:
- 'mybib.bib'
title: "Exponential Mechanisms - What's Wrong with Sensitivity?"
...
---


<div class="proof">

*Proof.* Let *f* = *T*\[*P*,*Q*\]. First we claim that
*T*\[*P*,(1−*γ*)*P*+*γ**Q*\](*x*) = (1−*γ*)(1−*x*) + *γ**f*(*x*).
To see this, consider any testing rule *ϕ* such that
$\\E_P\[\\phi\]= x$. We need to show that
$$\\inf\_{\\phi:\\E_P\[\\phi\]= x}\\E\_{(1-\\gamma) P+ \\gamma Q}\[1-\\phi\]= (1-\\gamma)(1-x)+ \\gamma f(x).$$
By definition of *f* = *T*\[*P*,*Q*\], we have
$\\inf\_{\\phi:\\E_P\[\\phi\]= x}\\E_Q\[1-\\phi\]= f(x)$. Therefore,
$$\\begin{aligned}
        \\E\_{(1-\\gamma) P+ \\gamma Q}\[1-\\phi\]
        &=(1-\\gamma) \\E_P\[1-\\phi\]+ \\gamma \\E_Q\[1-\\phi\]\\\\
        &= (1-\\gamma)(1-x)+ \\gamma \\E_Q\[1-\\phi\]\\\\
        \\inf\_{\\phi:\\E_P\[\\phi\]= x}\\E\_{(1-\\gamma) P+ \\gamma Q}\[1-\\phi\]
        &=(1-\\gamma)(1-x)+ \\gamma \\inf\_{\\phi:\\E_P\[\\phi\]= x}\\E_Q\[1-\\phi\]\\\\
        &=(1-\\gamma)(1-x)+ \\gamma f(x).
    \\end{aligned}$$
This verifies [\[eq:2156\]][1]. Next we proceed to the proof of the
lemma. Similarly, it suffices to consider arbitrary testing rules *ϕ*
with $\\E\_{\\bar{P}} \[\\phi\]\\leqslant x$ and show
$$\\label{eq:fe}
        \\E\_{(1-\\gamma) \\bar{P}+ \\gamma \\bar{Q}} \[1-\\phi\]\\geqslant 
        T\[P,(1-\\gamma) P+ \\gamma Q\](x) = (1-\\gamma)(1-x)+ \\gamma f(x).$$
Expanding the convex combination, we have
$$\\begin{aligned}
        \\E\_{(1-\\gamma) \\bar{P}+ \\gamma \\bar{Q}} \[1-\\phi\]
        &=(1-\\gamma) \\E\_{\\bar{P}}\[1-\\phi\]
        + \\gamma  \\sum p_i \\E\_{Q_i}\[1-\\phi\]\\\\
        &\\geqslant (1-\\gamma) (1-x)+ \\gamma  \\sum p_i \\E\_{Q_i}\[1-\\phi\]
    \\end{aligned}$$
Comparing to [\[eq:fe\]][2], it suffices to show
$$\\sum p_i \\E\_{Q_i}\[1-\\phi\]\\geqslant f( x)$$
We know that *T*\[*P*<sub>*i*</sub>,*Q*<sub>*i*</sub>\] ≥ *f*. Hence
$\\E\_{Q_i}\[1-\\phi\]\\geqslant f(\\E\_{P_i}\[\\phi\])$. By convexity
of *f*,
$$\\begin{aligned}
        \\sum p_i \\E\_{Q_i}\[1-\\phi\]
        \\geqslant \\sum p_i f(\\E\_{P_i}\[\\phi\])\\geqslant f\\left(\\sum p_i \\E\_{P_i}\[\\phi\]\\right)=f( \\E\_{\\bar{P}}\[\\phi\])\\geqslant f(x).
    \\end{aligned}$$
The last inequality follows from the monotonicity of trade-off
functions. Hence [\[eq:fe\]][2] is verified and the proof is complete. ◻

</div>

  [1]: #eq:2156
  [2]: #eq:fe