## Introduction

This repository contains my solutions for the [Google Code Jam 2016, Round 1A](https://code.google.com/codejam/contest/4304486/dashboard)
using the Ruby programming language. While I do software development for
a living, I would consider myself an "amateur" when it comes to
[programming competitions](https://en.wikipedia.org/wiki/Competitive_programming) 
and solving algorithmic puzzles, because I don't do any special training 
specifically for this kind of activity. But it's good to have fun
occasionally and the Google Code Jam contest looks interesting enough.

There is no way I can compete successfully with other people on a serious
level, but at least it is an entertaining personal challenge. The biggest
problem so far has been the time limit. Of course, the other people have
to deal with the 2.5 hours time limit too, so it's not a valid excuse. But
I just wanted to see if I can still solve the problems in a reasonable
time frame even after the competition is over. So after running out of
time in the official part of the competition, it is still fun to continue
trying to solve the problems just to see how long it may take.

Below is a description of my solutions, written before spoiling myself reading
the official ``Contest Analysis`` for this round or looking at the solutions
implemented by the other people.

### Problem A (The Last Word)

There is not much to say about the problem A. I guess, it's one of those simple 
ones, which exist merely to ensure that almost every participant can solve at 
least one problem and feel somewhat better. The same as scoring a consolation 
goal in football/soccer.

The [solution is pretty straightforward](https://github.com/ssvb/ssvb-in-google-code-jam/blob/a51e304b92f3eb1edf6131c6518280a5c24a9700/2016/1A/A.rb). 
We want to ensure that the most favourable letter (closer to the end of the 
alphabet) comes up in the beginning of the word. So it must be processed by 
the last ``move-to-front`` operation, followed by every other remaining letter from 
the input stream getting handled via the ``append-to-the-end`` operation. 
Then this can be generalized to handling the second, third and other 
letters using a recursion.

### Problem C (BFFs)

There are a few possible ways to construct valid circles:
* One of them is just a simple circle, with the kids affection directed as "A -> B -> C -> A". That's a classic example of a https://en.wikipedia.org/wiki/Love_triangle :-)
* In a generalized form, simple circles can have more than 3 kids, for example "A -> B -> C -> D -> A".
* If we have pairs of kids with mutual affection, such as "A <-> B" and "C <-> D", then they can be used as self-sufficient links to assemble longer chains and represent the final circle as "A <-> B  C <-> D".
* And finally "C -> A <-> B <- D <- E" is a generalized form of a self-sufficient link, built around a pair of kids with mutual affection.

Accounting all of these cases accurately is the way to solve the problem. 
Unfortunately I did not solve this problem in time. Only after the allocated 
time has expired, I tried to visualize the example input/output with a pen 
and paper to better see the pattern. Then it took a rather long time to handle 
the small input correctly, because I overlooked assembling the circle from 
multiple self-sufficient links. After multiple trial and error attempts with 
the small input, it was really tempting to just download somebody else's 
solution and see how the correct output should look like. But instead of 
giving up at this stage, I added a simplistic bruteforce validation code 
and identified what was the issue. This is quite a common thing in normal 
software development, certain [optimization shortcuts are validated against 
trivial implementations](https://cgit.freedesktop.org/pixman/tree/test/scaling-helpers-test.c?id=pixman-0.34.0#n7) 
and assembly optimizations are validated against more simple and maintainable 
C code. This all seems quite easy, but the biggest question is how to manage 
time during the competition to skip as much work as possible, while still 
avoiding mistakes.

In the end, I got the [C problem solved](https://github.com/ssvb/ssvb-in-google-code-jam/blob/a51e304b92f3eb1edf6131c6518280a5c24a9700/2016/1A/C.rb) 
roughly ~6 hours after the start of the round.

### Problem B (Rank and File)

This turned out to be the most difficult problem for me.

It is relatively easy to see some interesting properties if we just sort 
the lists. There is exactly one soldier with the lowest possible height, 
standing in one corner of the grid. This soldier is present in exactly two 
lists in the input (assuming that one of these lists is not the missing one). 
Based on this fact, we already know two lists, which belong to the row and 
the column with the index 0. But we just don't know which of these lists is 
the row and which is the column. And in exactly the same way, examining the 
diagonal of the grid, we identify the lists which belong to rows and columns 
at every index. And again, we just don't know which one of them is the row 
and which one is the column. There is also the missing list to take care of, 
but it's easy to figure out its index in the grid and also the height of 
the soldier on the intersection of the missing row or column with the 
diagonal. This is done in the [analyze_data function](https://github.com/ssvb/ssvb-in-google-code-jam/blob/a51e304b92f3eb1edf6131c6518280a5c24a9700/2016/1A/B.rb#L12-L47), 
which can produce the following output for the example data from the 
problem description (the lists are pre-sorted though):

```ruby
  result = [[0,   1, 0],  # Lists number 0 and 1 represent row/column for the index 0 in the grid
            [3,   2, 1],  # Lists number 3 and 2 represent row/column for the index 1 in the grid
            [4, nil, 2]]  # The list number 4 represents a row or a column for the index 2 in the grid
```

There is also a missing list (represented as a nil entry in the output), 
which belongs to either a row or a column with the index 2. And since 
we know that the list 4 is ``[3, 5, 6]`` in the input data, we also 
know that the missing list looks like ``[?, ?, 6]`` because the missing 
list is intersecting with the list 4 there. The remaining part is filling
in the question marks. Too bad that I could not figure out whether it is 
possible to generalize this to discover all the entries from the missing 
list. The additional constraint "1 ≤ all heights ≤ 2500" from the problem 
description implies that there might be some clever trick involving 
summing the soldier heights together or other arithmetic manipulations 
to deduct the missing values...

So after unsuccessfully trying to find a more clever solution, I ended 
up just reconstructing the whole grid by using the information presented 
above. We know the placement of each list, but don't know whether it 
is a row or a column. For the NxN grid, this means 2^N possible 
permutation variants, which is a bit too much for N=50. And indeed, 
the [grid reconstruction code](https://github.com/ssvb/ssvb-in-google-code-jam/blob/a51e304b92f3eb1edf6131c6518280a5c24a9700/2016/1A/B.rb#L51-L85) 
works fine for the small input, but is too slow for the large input 
when run as-is. However because we know that the solution is guaranteed 
to exist, the grid reconstruction will never have to do 2^N trials. 
We are only interested in finding the solution faster. An empirical 
guess suggests that we will have less trials to do if we handle 
the most problematic cases first. And [sorting the row/column candidates](https://github.com/ssvb/ssvb-in-google-code-jam/blob/a51e304b92f3eb1edf6131c6518280a5c24a9700/2016/1A/B.rb#L116-L119) 
to first try the ones which have soldiers with rare heights, improves 
the performance dramatically. The large input is handled in just a 
fraction of a second after this change.

### Wrapping up

Solving the last problem B happened <b>~19 hours</b> after the 
beginning of the round. Though I did not use all of this time working 
hard on these problems after the official competition was over, 
and had a few rather long breaks doing other everyday activities.

For comparison, the winner of this round only needed [21 minutes](https://code.google.com/codejam/contest/4304486/scoreboard?c=4304486)
to solve everything! This makes him or her more than 50 times faster
than me. Moreover, even without taking the contest duration into account,
the large input for the problem B would timeout with my original
implementation and it needed some fixes.

Let's see what happens in the round 1B two weeks later :-)
