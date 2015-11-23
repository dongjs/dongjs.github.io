---
layout: post
title: Computer Music Drum Machine
---
I did a seminar with Connor Harris at Harvard a few days ago. Here's the [link](https://manual.cs50.net/seminars/).

We talked about Haskell, Euterpea, and LilyPond.

{% highlight lhaskell linenos %}
A typical sequencer might have 16 steps. Here, we support slightly longer,
two-bar beats.

> gN = 32

The basic idea: generate some list of elements in the range [1..gN]. Given a
list like this and a particular MIDI percussion sound p, stepSequence will
trigger p at each timestep that is an element in the list.

> stepSequence :: Maybe Volume -> Int -> [Int] -> Music (Pitch, Volume)
> stepSequence _ _ [] = rest 0
> stepSequence v p xs = addVolume v' $ line [if x `elem` xs then perc (toEnum p) qn else qnr | x <- [1..gN]]
>	where v' = fromMaybe 75 v

Now glue it all together with an infinite Music type. drumMachine will run
forever. The list filtering and generation techniques are not elegant; rather
they try to show the expressivity of list comprehension and function
composition in Haskell.

> drumMachine :: Music (Pitch, Volume)
> drumMachine = let r = [1..gN]
>                   f n p = (\x -> x `mod` n == p)
>                   p1 = stepSequence (Just 127) 1 $ filter (f 4 1) r
>                   p2 = stepSequence Nothing 7 $ filter (f 4 3) r
>                   p3 = stepSequence (Just 127) 0 [7,10,14,23,26,30]
>                   p4 = stepSequence Nothing 4 $ filter (f 8 5) r
>                   p5 = stepSequence (Just 127) 27 $ take gN $ foldr (:) [] $ [3,8,21] ++ [1,6..]
>                   p6 = stepSequence Nothing 28 $ map (`mod` gN) $ scanr (+) 1 [1..5]
>                   p7 = stepSequence Nothing 29 $ zipWith (*) 
>						(concatMap (replicate (gN `quot` 3)) [8,15,16])
>						(take gN $ cycle [1..(gN `quot` 3)])
>                   p8 = stepSequence Nothing 41 $ take gN $ iterate (+3) 2
>                   p9 = stepSequence Nothing 35 $ filter (not . (f 4 1)) r
>                   p10 = stepSequence Nothing 3 [7,15,25,28,32]
>               in tempo 4 $ instrument Percussion $ repeatM $ chord [p1,p2,p3,p4,p5,p6,p7,p8,p9,p10]

{% endhighlight %}
