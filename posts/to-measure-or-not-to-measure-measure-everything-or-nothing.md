---
title: "To measure or not measure"
date: 2025-10-01
---
# To measure or not measure
## Measuring everything or nothing

A few years ago, a friend commented on my scales and how I measure quantities. They said that they do not really measure while cooking. This made me think, how much do I measure?

In our kitchen I weigh the cats' daily dry food intake. I use the scales when I feed my sourdough starter and when I bake; or make pizza and bread doughs. The general advice for baking is to measure everything precisely but the type of baking I do is not as finicky (bread can be quite forgiving, you just need to know your flour's capacity to absorb water). As for cooking in general, I use the scales sometimes when I cook a dish I am unfamiliar with, but otherwise I am not very precise.

I started reading Cooking at Home by David Chang and Priya Krishna. For 120 pages, they lament how measuring is not needed and instead we should know our own flavour profile and cook to our tastes. Some can cook a recipe to precision and it never comes out right whereas some cook by feel and the food comes out delicious.

Taking these ideas to work, getting a vibe for when the team is productive is not going to cut it for many. Metrics are important, no one argues this point. So the question isn’t whether we should measure nothing. The question is *what should we measure?* 

Last month I was at an event that debated whether individual productivity could be measured in knowledge work. This reminds me of Hofstede’s cultural dimension of individualism vs collectivism. How do people co-exist with one another? To what degree individuals look after themselves and their own interests vs. the interests of the collective. When we set individual goals and measure individual productivity, what we really say is that we value competition vs collaboration. 

There is also the topic of what we can and should measure. Measuring lines of code, commits or pull requests (PRs) is absurd. We are not in a factory where higher production is the goal. More lines of code means higher chance for code complexity and the need for additional future maintenance (not to speak of when we delete code). Code quality is not measured by lines of code. Counting commits will pollute the log history with garbage commits. All these examples measure output, not actual value or impact. Being busy does not equal providing value. And individuals will gamify the system for their personal benefit. Individual metrics lead to perverse incentives and lower performance in our teams.

We want our team members to ship performant, reliable, scalable code. But that is only half of it. We want them to ship code that provides value on a regular cadence. So what should we measure to know if our teams are productive? Here are some suggestions:

- **Release frequency** — infrequent releases are often symptomatic of unresolved bottlenecks and other issues
- **Change lead time **— the speed of moving tasks from backlog to production. How long do PRs get stuck in review before being merged?
- **Mean time to recovery** — can indicate system health and team productivity
- **Types of work** — new work, bugs, chores, failure demand. If we have many bugs and failure demands, our system is not stable.

You might have noticed that many metrics can only tell you when something is wrong. Having those numbers is usually a snapshot in time. It is much better to look for trends over time. Is the number of bugs going up or down? Were we getting work merged and deployed within a day but now it is taking us a week? Looking at these metrics over time tells a better story of whether the work and its quality are heading in the right direction.

This is all nice when it is business as usual. But what do we do when it is time for performance reviews? How do we provide useful feedback to individuals so they feel progress in their professional development? How do we do that without “cold objective numbers”? I think this is still part of the same discussion. We should keep hard metrics to the team and organisation levels to encourage those individuals and teams to work together. And 'measure' individual performance by the contribution to that team and its goals.

I guess the point I’d like to end with is: find the metrics that work for you and your organisation. And focus on delivering business value on a regular cadence as a team to encourage collaboration rather than competition.