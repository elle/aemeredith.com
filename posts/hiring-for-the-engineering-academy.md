---
title: Hiring for the Engineering Academy
date: 2019-09-24
description: The hiring process for Qantas Hotels engineering academy in detail
---
# Hiring for the Engineering Academy

Last year I wrote about [running an apprenticeship program for Hooroo](/resources/first-pilot-of-an-engineering-academy-notes-and-after-thoughts) (now Qantas Hotels, and will be referred to using that name). The feedback I received on that article from [Stu Liston](https://twitter.com/stuliston), the engineering manager at the time, was that there was so much more to the process of developing the program, and a lot of thought had been put into the choices and decisions we made, none of which had made it into that first article. In this article, I elaborate on the hiring process we used for this apprenticeship program. 

This is also a follow up to last week's article on [starting your own apprenticeship program](/resources/start-your-own-apprenticeship-program).

## Job description

One of the early steps in any hiring process is a job description. We put up a page outlining:

- how we work,
- our values,
- culture and perks,
- who we are looking for,
- how the program works,
- how the application process works, and
- what you should send in your application.

We ran the job description through [Textio](https://textio.com) to minimise how gendered and biased the language we used was. As Textio says:

> Language is culture. You use words constantly: emailing, writing, texting. Every word you choose reveals who you are. The way you ask a question determines who will answer you. The way you present a job changes who can see themselves in it. Everything about your company culture is built on language.

![How we work, our values, and culture and perks](/images/20190924-our-values.png)

When looking for work, people sometimes lose track that this process should be a two-way conversation and agreement between the workplace and the potential candidate. The interview process can be used for the candidate to decide which company to work with, in the same way the company can choose which candidate to employ. We listed Qantas Hotels' values so that candidates were able to decide from the get-go whether they were a fit for the culture and whether they wanted to work with us.

![Who we are looking for](/images/20190924-who-we-are-looking-for.png)

The next section described who we were looking for. One of the key foundations of a good job description is to define exactly that, what you are looking for. That definition should not be too wordy, long, or restrictive. It should also not be tied too closely to existing technologies. Technologies come and go. It is more important to look for someone that can adapt and learn, rather than someone who knows the current stack. I believe that knowledge is not enough, and that success in life depends on both knowledge and character. Especially since we were hiring for an apprenticeship program where successful candidates would learn on the go, it was more important for us to concentrate on desired personality characteristics.

Another important factor in the hiring process is open and useful communication with the candidates. Throughout the process, we aimed to be transparent about who we were looking for, how the program would work, what each step entails and what was expected, and what steps will follow.

## Application process

How many times have you been interviewing for a company and the interview process dragged for too long? It was important for us to be timely and prompt with our interactions with the apprenticeship candidates. It also helped that we had a two month deadline before the program was due to start.

We defined the various steps in the hiring process, set dates for each step, created structured and consistent interview templates and response rubrics, created email response templates, assembled a hiring committee (different people for each of the various interviews), and I oversaw all the moving parts to ensure every phase was working well and on time.

The application process included seven steps:

1. Applications are open for submission until a specific date
1. Application screening
1. Non-technical interview
1. Technical interview
1. In-office visit
1. Reference checks and send out letters of offer
1. Program starts

![How the application process works](/images/20190924-how-the-process-works.png)

### Application review

For their application, we asked candidates to send us their résumé, answers to four questions, and a coding sample. We asked that the answers to the questions be submitted as a markdown file on [GitHub Gist](https://gist.github.com). Once again, being open about what we are looking for, we outlined what the answers to the questions and the code sample should demonstrate. Since each question was selected because we were looking for something specific, it was easy to define what we wanted the answers to be:

> Your answers should demonstrate:

> - grit and determination to work as a software developer,
> - exposure to the field,
> - the ability to learn from mistakes, and
> - embracing the new and unfamiliar in order to accomplish a given task.

Being mindful of people with time constraints, we asked for an existing code sample, something that the candidate would be proud to show off. If they did not have their own sample, we offered two small [coding challenges](https://gist.github.com/elle/b9739bc21eb348916a60622f3fb6e2e4) to choose from. Applicants could submit either or both.

![Rubric example](/images/20190924-rubric-example.png)

I also created a rubric to rate answers to the four questions. It defined what average, good, and great answers looked like.

I wanted to involve as many people from the team in the process as we could because they would be the ones working with the people we selected. We used a Github repo to keep track of the interview process materials, and used GitHub Issues to keep track of each candidate's progress. Every person on the Qantas Hotels engineering team had access to this information, could provide feedback, and be part of the process. Team members were encouraged to provide feedback.

Almost every step of the hiring process was utilising two people, to try to reduce individual biases. We also aimed to have a man and woman in those pairs. The only phase that had two men was the non-technical chat that was conducted by Stu, the engineering manager and Warren, the HR manager.

### Non-technical and technical interviews

We implemented two sets of interviews (non-technical and technical), and both were structured. Structured interviews are better predictors of later work success. For the non-technical interview, we selected questions based on the personality characteristics we were looking for and Warren was instrumental in selecting valuable questions. For example: 

> Tell us about a time you worked as part of a team. What was your contribution? What did you like/dislike about the team environment? What was the outcome of the team’s work?

> _Look for signs they know their own strengths and weaknesses, and can empathise with others. Someone who can appreciate the benefits we receive from others on the team, with a wish to reciprocate._

We also personalised that interview with a couple of questions specific to each candidate. These two questions were again prepared beforehand. Lastly we allowed for extra time so the candidates could ask us questions.

The aim of one question on the non-technical interview checked what the candidate would like to get out of this program, and the question's aim was to see if we could match what we offered to what the candidate needed and wanted.

The technical interview was written with set questions, and was designed with beginners in mind. We ran the questions past [Melissa Kaulfuss](https://twitter.com/MelissaKaulfuss), as she was then still early in her career as a developer, and asked for her feedback whether the questions were suitable for beginners.

I provided instructions on how to run the interview and what to look for in the candidate. [Jackie Camomot](https://twitter.com/jacki3lene) and [Phil Windeyer](http://philipwindeyer.com) ran this phase of the interview. And once again we allocated time so the candidates could ask the team questions. The answers to each question were recorded on a scoring worksheet, and I asked Jackie and Phil to add their individual notes and thoughts on each candidate.

### In-office visit

The last part of the interview was an in-office visit, which included two pairing sessions and was a chance to meet and interact with the rest of the engineering team. It assisted in getting team buy-in. Once again, we defined what we were looking for: problem solving skills, communication style, code quality, ability to collaborate and work as part of a team, care about learning and being curious, and mainly, is this someone you would like to work with.

To prepare Qantas Hotels' senior developers for pairing with what we assumed would be mostly beginners, I ran a session on [how to pair program](https://speakerdeck.com/aemeredith/two-heads-are-better-than-one) in one of the team’s weekly tech meetings.

One of the pairing interviews was on a work problem, which was the same for every candidate who made it so far. This pairing session was done with either [Dave Healy](https://github.com/healsjnr) or [Andy Nicholson](http://andrewdotni.ch) and work was on an experiment the team conducted to check various solutions for improving search functionality. The second pairing session was with me and again a constant: we worked on one of the code challenges we suggested the candidates provide as a code sample –- the Luhn credit card checker. The advantage of using the same problem in each case was that we could compare candidates in a more fair manner, give ourselves time to develop a solid grasp of the problem to be solved and how to communicate it effectively to the candidate as well as remove the total surprise of the code to be written, since they were aware of this exercise from the application submission phase.

For the pairing sessions, we set up one computer, with two monitors, two keyboards, and two trackpads. This allows the applicant to drive as much of the session as they would like to. Most of them had never paired with anyone before, and since many teams at Qantas Hotels pair on a regular basis, it was even more important to see how comfortable they were with a pairing session.

The candidates knew that TDD (Test Driven Development) was something we were looking for, but not everyone knew how to get started with it. So I generally set up the stage for us to work together. In some cases, I would write the spec, and we would then explore how to make that test pass. We looked for people that are curious to see how things worked, and weren’t afraid of looking up documentation, or asking questions. We also looked how they interacted with their pair, and the rest of the team. Feedback I got from candidates was that they learnt from our pairing sessions, for example learnt how to pair and how to test drive a code solution.

## Continuous communication

Since we wanted to be timely in the hiring process, each phase took about a week, and feedback to the candidates was provided at every step. I wrote the email templates to be sent out for successful and unsuccessful applicants before we started the hiring process. In each email, I offered to provide feedback if desired, and as it happened almost all the applicants asked for the feedback. Writing each individual feedback took a while. Half way through, I ended up writing a list of common issues and suggested readings.

A note about sending feedback to rejected candidates: try to remember that no one wants to hear they did not get the job, especially when they are looking for their first position and the apprenticeship program was such a good opportunity. Sending an interview feedback email to rejected candidates helps end things on a positive note and build relationships for future job openings. You want the feedback to be honest, kind, and specific. Vague responses will not help the candidate with their next job application. Keeping the feedback specific to job requirements will help avoid unnecessary discriminatory comments and legal issues. Be sincere and keep the wording positive.

We used [Calendly](http://calendly.com) for scheduling all the different interviews, making it quicker and easier for the candidates to select the date and time that worked best for them. With the exception of the in-office interview, all the other steps could be done remotely. For the in-office visit, we flew the candidates in to Melbourne. Perks of working for an airline parent company!

## Recap

From advertising the program to starting took about two months. It was about a month between closing the applications to sending letters of offer (i.e. the majority of the active interview phases). Considering the volume of applications we had, that is quite reasonable and not a small feat.

No process of hiring is ever perfect and what works for one person or company will not work for all. This is just one example of what worked for the Qantas Hotels Engineering Academy. Hopefully you can take some pointers away with you. If you need any help with your hiring process, please contact me to chat!

_Over the past two years, [Elle](https://blackmill.co/about-us#elle-meredith) and [Lachlan](https://blackmill.co/about-us#lachlan-hardy) have given talks about better hiring practices at Web Directions Code Leaders 2017 and Full Stack Toronto 2018. They ran a workplace culture and hiring for diversity workshops at Web Direction Culture 2017. Recently Elle gave a talk at RubyConf Thailand 2019 about starting an apprenticeship program and the associated hiring process._
