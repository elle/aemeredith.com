---
title: Speed vs quality and technical debt
date: 2021-06-20
description: We cannot have everything we want at once, so how do we reconcile speed of delivery with quality of code?
---
# Speed vs quality and technical debt

![Project management triangle](/images/project-management-triangle.png)

## Project management triangle
The project management triangle is
a model of the constraints of project management.
The idea is that quality of work is constrained
by the project, budget, deadlines, and scope of features.
That the project manager can trade between constraints.
And the changes in one constraint will cause the others to adjust accordingly.
You may have heard this described as
_"Good, fast, or cheap. Pick two"_.

Generally, you can never get everything you want.
Well, at least not all at once (although
[Toyota has challenged](https://www.thisamericanlife.org/403/transcript)
this concept).
Many product companies, as they start, have very limited budget,
and they are in a rush to get to market.
Thus, they sometimes cut corners,
and do things quick and dirty.
This leads to what we call
[technical debt](https://www.martinfowler.com/bliki/TechnicalDebt.html).

## Technical debt

Most applications accumulate technical debt over time.
As applications grow to provide more features,
they often also grow in complexity.
This results in challenges around timely delivery of new features,
and reduced velocity development processes and performance.
Technical debt is a metaphor that frames
how to think about dealing with low-quality or highly complex code.
Technical debt makes it harder than it would ideally be
to modify and extend the application further.
We usually use an interest on debt as the metaphor,
meaning that unless you work on
cleaning, reorganising, and refactoring the code,
you will pay for it with interest,
with slower development time,
higher difficulty developing functionality,
and lower team morale.

A different way to explain technical debt is using a restaurant metaphor:

<blockquote>
  If you run a commercial kitchen and you only ever cook food
  because selling cooked food is your business.
  If you never cleaned the dishes,
  never scrubbed the grill,
  never organised the freezer,
  the health inspector will shut your sheet down pretty quickly.

  Software. on the other hand, doesn't have health inspectors.
  It has kitchen staff who become more alarmed over time
  at the state of the kitchen they're working in every day.
  And if nothing is done about it,
  they will come a point where
  the kitchen starts failing to produce edible meals.
  Generally you can either convince decision makers
  that cleaning the kitchen is more profitable in the long run,
  or you can dust off your resume, and get out before it burns down.
</blockquote>


![Technical debt kitchen example](/images/technical-debt.jpg)

<blockquote>
  If you develop a program for a long period of time by only adding features,
  but never reorganizing it to reflect your understanding of those features,
  then eventually that program simply does not contain any understanding,
  and all efforts to work on it take longer and longer.
</br>
<cite>
  Ward Cunningham
</cite>
</blockquote>

The focus in this quote is
_never reorganising the code to reflect your understanding_.
Ie. Thinking of technical debt as a poorly managed knowledge base.

## Sprints

Many development cycles run in sprints of whatever length.
One week, two weeks up to six.
I dislike this choice of naming.
The definition of sprint is to run or go at top speed,
especially for a short distance.
It means we are always rushing.
There is no time to stop, evaluate, or reflect on our work.
In a go-go-go product cycle,
that loss of understanding begins to create problems
that have literal and figurative costs to the business.

## Pressure can expedite delivery

If the developers on the project
do not believe there is purpose to their work,
they will not be motivated, and will not feel a sense of urgency.
One way to get them to deliver faster is by adding pressure.
However, this comes at a cost.
Pressure and urgency typically lead people to cut corners.
It gives the illusion of speed,
but in reality, it leads to poor quality results.
And later on, delays and reduced velocity.
Furthermore, people who operate under pressure for too long
experience burnout and leave your company.

The next argument is cost.
The biggest cost on a software project is people.
Paying people to build your software is by far the most expensive outlay.
If velocity is low and it takes longer to develop the new feature,
it will cost you more with people's hours, either for actual development,
but also in communication overhead.
Moreover, if you have a low retention rate of people,
you are paying the additional costs of recruitment services,
as well as unproductive team members
while they onboard onto the team and the codebase. 

## Slow is smooth. Smooth is fast

The solution to this problem is to go slow and steady.
Quality reduces your cost in the long run.
If you concentrate on quality,
you build up confidence,
which in return builds speed.
Focusing on speed, reduces quality, which reduces the speed.

## Deliberate technical debt

There is always a fine line with how much can the team dedicate
to writing good extensible and maintainable code,
to how quickly they need to get to market,
to be able to generate a revenue stream.
Sometimes teams decide to intentionally do something quickly
as a temporary compromise because they need to deliver to market.
But this means they should also consider
how long it will take to fix that quick implementation.
And hopefully they also ensure the relevant stakeholders
are aware of this compromise,
and that this means slowing down other feature releases later on.

## Refactor or rewrite?

If you leave the technical debt to grow without tending to it regularly,
there will come a point where development on the app
will get to a screeching halt.
Every feature will take a very long time to ship out,
and will come at a pain.
This is when people start saying that they need to do
a really big refactor or even worse, a rewrite of the whole code base.

A big refactor means stopping work on new features
for multiple months while the whole team works on refactoring the codebase
based on better understanding of the business,
and knowledge of its requirements.
Sometimes doing a rewrite _is_ the best option.
So the team has a collective understanding of the code,
but this is _rarely_ the right thing to do.
There is so much business logic and domain knowledge
that hides in between all the technical debt,
that it will be very difficult to account
for all the different edge cases in one big rewrite.
The chances of missing some important business logic is high.
The best way to approach fixing technical debt,
and to increase the quality of the codebase is with the small steps.

## Small steps

Don't say "you are fixing technical debt". This work is never done.
Instead, budget time and slack for "sustaining engineering work".
The "we're going to spend the next three months working on nothing
but tech debt never produces the results you want.
Most likely outcome will be that your plan gets changed out from under you.
Instead consider
_making tech debt work visible_.
What I like to do is when I finished working on a feature,
and the feature works, but not with the best approach to the problem,
I will merge my PR and immediately start on a refactor branch,
to clean up the code that I just merged.
I will either use the same ticket or card for the refactor,
or create a new one so that the refactoring work
will be visible and included in tracking progress on the project.

## Momentum > urgency

Fixing technical debt is a morale boost for many engineers.
Some teams have a day a week dedicated to bug fixing.
In one specific team, the team lead selects a bunch of small tickets
that can be done in a day,
and which give the team a sense of achievement and momentum

In her article,
[Momentum > Urgency](https://testobsessed.com/2020/02/momentum-urgency/),
Elizabeth Hendrickson tells the story of a very responsive product manager
and that responsiveness kept the momentum on the project going.
She says:

<blockquote>
    What I've learnt is that if we want things to go fast,
    a sense of momentum is much more effective than a sense of urgency.
</blockquote>

She also suggests the following few things:

- Everyone on the team has a shared understanding of the big picture
  and what "good" looks like.
  So they don't burn cycles on unnecessary, or non-useful work.
- The team breaks the work into small pieces,
  a couple of days at the most,
  which still represent incremental business value.
  Even if it is not user facing features.
- The team embraces the technical practices necessary to ensure
  that the code they deliver does what they intended it to do,
  and is of good quality.
- There is an engaged and responsive product manager
  who is considered part of the team,
  and who does hands-on acceptance of the work.
- The work, and the status of the work is visible to everyone.
- The team as a whole has a strong sense of partnership and trust.
  So that visibility never becomes a mechanism for micromanagement.

## Slow is smooth. Smooth is fast

If we go back and review how we started the talk,
considering the three aspects of the triangle of project management
with time, budget and quality,
maximising two does not have to come at the expense of the third.
So how do we have it all?
The answer is easy.
We focus on quality first.
This might seem counter intuitive, but research has shown that
high performing engineering teams,
ones that focus on quality are the most that gain the speed.
By
_focusing on quality, we focus on future-proofing our application_.
So slow is smooth and smooth is fast.
And as the saying goes: "slow and steady wins the race".
