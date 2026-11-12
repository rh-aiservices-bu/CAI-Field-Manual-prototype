---
title: What is a Field Manual?
description: "The one thing you want in your pack when you head into the field: what a CAI Field Manual is, what it is not, and where it came from."
type: docs
footer_style: slim
weight: 10
icon: fa-solid fa-book-open
---

A CAI Field Manual is the one thing you want in your pack when you head into the field. It tells you what to do, in which order, and why you might want to do that instead of something else. It is rugged, and there might be some hand-written notes in the margins.

## What it is

A CAI Field Manual contains knowledge, tips, tricks, workarounds, warnings and other time-saving advice, accumulated from your peers, people who have already been where you are right now, or been in situations similar enough to be useful.

It is a collaborative effort, and you get back what you put into it.

## What it is not

- Official documentation
- Guaranteed to be 100% accurate 100% of the time
- Available ahead of a new release
- Always going to be right on everything; there are exceptions to every rule

## Who writes it

A CAI Field Manual is first and foremost what CAI create for themselves as we come to grips with new versions, new concepts, new challenges, and new jungle. As we trial and error, as we figure out where the dragons are and how to shortcut our way through technological complexities, we lay down markers behind us as we go, so we can find our path again in the future, more efficiently.

## Humans and their AI agents

We are no longer making this journey alone: we have AI agents that handle some of the logistically important but strategically boring tasks (regression testing, reporting bugs, updating statuses, reviewing content for clarity and accuracy). So we write our Field Manuals in a way that they can speak both to the humans and their AI agents, providing different but complementary information to each audience.

This site is built on that premise. Every page serves both audiences at once:

- The page action menu offers *Copy markdown* and *View markdown*, and hands the page to Claude, ChatGPT, or Gemini.
- The whole site is also readable as `llms.txt`, and every manual is available as one flattened markdown bundle, with every variant labeled and nothing filtered.
- [Chat]({{< relref "/chat" >}}) discusses any manual with your own OpenAI-compatible endpoint; the key stays in your browser.
- The boring tasks are already being delegated: comment `/omp <request>` on any issue or PR review thread and this repo's own agent drafts the change, gated by the same publication check as human PRs.

## Why it is open

As we evolve our practices, our tools evolve, and we want to ensure that we do not hold this as a mythical "secret sauce", but instead, and always before, make this available to those who need it: because it's the right thing to do, and because this is what Open Source is all about. Everything here stands on work other people shared.

## Where it came from

We worked our way up to the name "CAI Field Manual": different initiatives, ideas, directions, fits and starts, failed attempts, doubts and tribulations. It came out of that process, and it will keep evolving.

## See it in practice

- The [Hello World Field Manual]({{< relref "/field-manual/hello-world" >}}) is the blank skeleton: duplicate it and fill in your own field procedures.
- [Writing the field manual]({{< relref "/writing-the-field-manual" >}}) is the doctrine: the six conventions behind every manual here, with annotated examples and a first-manual walkthrough.
- [Why this approach]({{< relref "/why-this-approach" >}}) is the design rationale: what this prototype copies, changes on purpose, and why.
