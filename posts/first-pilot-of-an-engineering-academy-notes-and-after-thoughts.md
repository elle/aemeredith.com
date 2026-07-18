---
title: First pilot of an engineering academy notes and after thoughts
date: 2018-04-19
description: An overview of the Qantas Hotels engineering academy programme
---
# First pilot of an engineering academy notes and after thoughts
Technology companies survive by their ability to hire and retain fantastic employees. With software engineers that means delivering an environment that offers autonomy, opportunities for learning, and values craft. Additionally, every new software engineer needs to understand the technology platform, company culture and shared vocabulary more swiftly so they can meaningfully contribute earlier.

Many companies employ a sink or swim approach, relying on on-the-job learning to educate less experienced employees. This leaves critical gaps in knowledge. Business As Usual assignments are vital for the product(s) but do not reliably offer opportunities to pick up new skills, or to keep up with the changing nature of our industry.

Hooroo (now Qantas Hotels, and will be referred to using that name) recognised this and engaged [Blackmill] to deliver a pilot [engineering academy] over six months. The pilot completed in March 2018. Here are some of my notes from the program.

[Blackmill]: https://blackmill.co/
[engineering academy]: http://academy.qantashotels.com

## Why?

### Recruit great candidates

I worked with Qantas Hotels (both Engineering and HR) to create a better interview process, delivering better, more consistent, results in less time. That whole process should be another blog post.

We hired three committed full-time employees, and offered better support for one existing employee who had recently career-switched into development. The four apprentice developers progressed rapidly, with visible improvement in how they approach each problem by the end of the academy's second week.

### Increased engagement and retention

An important part of the plan was to ensure the current software engineers were interested and involved in the program and the success of its students. The apprentice developers did rotations with product teams. We found that keeping the rotation time to two months worked well. The teams reported increased enthusiasm and positive energy by having them on the team. The apprentices were able to contribute product work, providing value from the start.

Existing team members engaged with the program, developing and delivering some of the course material. Team members also volunteered to be mentors for the apprentices.

Additional objectives were:

- Diversify the engineering team with regards to gender and experience
- Benefit from introducing fresh perspectives and ideas (for example reconsidering pair programming practices)
- Investing in the team
- A program to be used in the future

## Who were we looking for?
In order to establish a common baseline of knowledge across the students, we looked for very specific characteristics in candidates. Firstly, that they aligned well with Qantas Hotels' company values.

Secondly, that they were people looking to start their career in software. We wanted them to have some basic programming skills, particularly in Ruby (the most common language used at Qantas Hotels), but not necessarily previous commercial experience. Graduates from programming bootcamps, RailsGirls, university, or career changers fit this criteria well.

Lastly, we looked for personality traits we thought would help to succeed in a program like this. We looked for people who:

- demonstrate self-learning,
- have a growth mindset,
- have drive,
- demonstrate initiative, and
- communicate well.

## How the program was run
The program ran for six months, and was a paid apprenticeship.
It was a blend of structured learning and on-the-job work. We alternated academy weeks with product work, and found that full weeks with the team gave the apprentice developers enough time to take ownership of story cards as well as a break from the intense learning periods.

During academy weeks, we started each day with a coding exercise from [Exercism] and followed the [Gradual Release of Responsibility] model. We used mob programming initially, continued with pairing (two groups of two) and within two months had moved to doing the exercises individually. Each day we compared the solutions and discussed suggestions for improvement.

[Exercism]: http://exercism.io/
[Gradual Release of Responsibility]: https://en.wikipedia.org/wiki/Gradual_release_of_responsibility

Most days also consisted of theory sessions, code alongs, and self-work periods. Other notable activities were:

- The developer apprentices gave presentations every week which they also took to local community events to present.
- They did a personal project (what [Apprenticeship Patterns] calls "breakable toy"), where they practiced what they learnt, and allowed me to evaluate and assess their knowledge and understanding.
- We followed engineering team workflows, for example running retros every academy week and iterating on what worked and what didn't to continuously improve how the academy operated.

[Apprenticeship Patterns]: http://shop.oreilly.com/product/9780596518387.do

During team weeks, the apprentice developers built, deployed, and supported software for Qantas Hotels with the guidance of a dedicated mentor and the product teams. They wrote automated tests and engaged in all the product team's practices, for example standups, retrospectives, showcases, user story kick-offs, design discussions, and 10% time to express creativity and try things out.

## Program content
Creating the content for the academy was the bane of my existence for the past so many months. It takes a lot of work!

I relied on [Turing School]'s [curriculum] for some topics, while for others I wrote the content from scratch using various articles, books, videos, and other resources. The full breakdown of curriculum modules (including links to further resources) is available in this [Trello board].

[Turing School]: https://www.turing.io/
[curriculum]: https://github.com/turingschool/curriculum
[Trello board]: https://trello.com/b/oRii8I9h/apprenticeship-programme

Qantas Hotels team members helped with writing content and running sessions on specific topics, such as Splunk, DevOps, SQL, Event Sourcing, security, and more.

## After thoughts
Looking at our original metrics, the program is a success. All the academy grads have been employed by Qantas Hotels. They are productive in the Qantas Hotels engineering ecosystem. Senior developers had opportunities to mentor.

The team rotations enabled the team to examine engineering practices from their colleagues. It created shallow silos of product information and cross-pollination. The apprentices experienced a detailed orientation in each product and developed cross-team knowledge.

The academy fostered a sustainable team culture that involves supporting new team members. It streamlined and standardised the interview process and provided a great on-boarding experience. The scope of the program allowed for more in-depth instruction in the Qantas Hotels technology stack than was previously possible. For example, three days of deliberate instruction for DevOps and how Qantas Hotels uses AWS.

With the personal projects, we started quite slow, creating wire frames, a back log of user stories, UML and sequence diagrams, before writing the code. Once the apprentice developers started working on their individual "breakable toy" projects, we once again followed engineering best practices with working in feature branches, creating pull requests for code reviews, using linters and CI. We found that this more direct application of the material is extremely beneficial for learning, understanding, and retaining new knowledge. In the next academy installation, I recommend starting the personal projects earlier in the program.

This brings me back to the last objective: a program to be used in the future. I would still like to tweak the curriculum based on the last program, but all in all it is ready for a new instalment. So, who's with me?

PS: If you're looking to career-switch into development and you'd like some resources,
you will find wonderful resources
[in this Trello board](https://trello.com/b/oRii8I9h/apprenticeship-programme),
and a great [Ruby community here](https://ruby.org.au/).

UPDATE: I also wrote an article on
[how to get started with web development](/articles/so-you-want-to-get-into-web-dev).

If you're responsible for a technology team or company and would like
to chat about how we can help you, [get in touch](mailto:gday@blackmill.co).
