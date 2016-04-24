---
title: Celebrating Shakespeare's 400 anniversary in Docker
date: 2016-04-23
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
published: true
excerpt: >
  This weekend marks the 400th anniversary of Shakespeare's death. In this blog post,
  we'll be using his language to perform simple computational tasks such as calculating
  primes and Fibonacci numbers up to 400.
categories:
  - Docker
  - Shakespeare
  - language
authorIsRacker: true
---

This weekend marks the 400th anniversary of Shakespeare's death. As one of
the giants of English literature, his works have inspired and shaped
generations of lives, perhaps more than any other; and the fact
that his plays and poems still continue to reach out and affect us testifies to
his enduring genius. But if he is _truly_ universal, how does he affect those in
technology? Is there any way that Shakespeare can influence software engineers
and even help them get things done? The answer, it seems, is an unequivocal "Yea"!

In this blog post we'll be using an experimental programming language called
[Shakespeare](http://shakespearelang.sourceforge.net/) to parse Shakespearean
English into C programs, which we can then compile and execute. This allows
us to run basic algorithms and computations with nothing else apart from a
Dramatis Personæ, stage actions, and speech.

We'll be using Docker to simplify installation and configuration, and using
disposable Docker containers to run our Shakespeare files.

### Getting the examples

First, clone the language into a local directory:

```
$ git clone https://github.com/jamiehannaford/shakespeare
```

You will see the following Dockerfile inside:

```
FROM ubuntu

MAINTAINER Jamie Hannaford <jamie.hannaford@rackspace.com>

RUN apt-get -y update
RUN apt-get -y install gcc make bison flex

COPY . /code
WORKDIR /code

RUN make install > /dev/null 2>&1

ENTRYPOINT ["/bin/bash", "run.sh"]
CMD ["fibonacci"]
```

We are extending from the Ubuntu 14.04 base image and performing the following actions:

- Installing make, gcc, bison and flex, which are required to build the C binaries
- Moving the codebase to a root directory
- Running the codebase's Makefile which builds the parser binary
- Setting the entry point as a Bash file that accepts arguments
  and builds the corresponding example file
- Setting ``fibonacci`` as the default

### Calculating the first 400 primes

What better way to kick off our computational adventures than prime numbers?
A prime number is a positive integer that has no divisor other than
itself and one. Many algorithms over the years have
vied to be the most efficient, but how many of them have used stage
instructions and Jacobean insults to do so?

The first step is to open the `examples/primes.spl` file. You can then run
execute the file with Docker like so:

```
docker run --rm jamiehannaford/shakespeare primes
```

The final argument, `examples/primes`, corresponds to the filename of the example
we are running.

For this algorithm we need four variables, or characters, on stage:

- A limiting factor, or the Ghost, who will ensure we do not exceed 400
- A controlling variable, or Juliet, who delegates tasks and controls the execution flow
- A counter variable, or Romeo, who represents an integer being investigated for prime-ness
- A temporary variable, or Hamlet, who stores temporary state, such as the upper bound of
  factors for a specific integer and the ASCII number for a space character

Only two characters are allowed to be on stage at one point. `Enter` brings variables into
scope, `Exit` releases them, and `Exeunt` releases all active variables. A variable
is used to store an integer value. A variable is allowed to set the value of another variable,
as well as performing tasks on it like output operations, pushing and popping values
to a variable's value stack, and asking conditional statements. It can also jump
to different sections of the algorithm.

But first thing's first: Juliet needs to set the Ghost's upper bound value:

```
Juliet:
 You are the square of the sum of a proud gentle pony and the square of a
 lying fat pig.
```

A positive or neutral noun (as defined by the files in the `include` directory)
represents `1`, and any negative noun represents `-1`. Any corresponding
adjective multiples that value by `2`. You can chain them, too, so a lying fat pig,
which contains two adjectives, has the value `-4` (`2 * (2 * -1)`), and its square
is `16`. The value of a proud gentle pony is also `4`, and when added to `16`
makes `20`, which, when squared again, makes `400`. We can count in Shakespearean insults!

Each act represents a discrete section of our algorithm. The first act sets
Romeo, our counter, to `2` (a sunny summer's day). In the next act Juliet asks,
in full rhetorical flow, whether he's more cunning than Hamlet's Ghost? In
computational terms, this a conditional statement that tests whether Romeo's
current value exceeds our set limit. If it does, the execution jumps to Scene 5
(like a `goto` statement), which terminates the algorithm.

The next step is to find the internal upper bound for factorization. For example,
to find out whether 37 is a prime, 6 should be the largest integer we use to divide
37 by, since we'd otherwise be duplicating operations. This is where Hamlet enters
the picture: he represents this upper boundary (that is, the square root of Romeo).
Juliet is then cast as 2, the lowest possible divisor for a non-prime.

Act II Scene II is a loop that runs while Juliet, the divisor being incremented,
is less than Hamlet (the square root). Whilst Juliet is lower, we figure out
whether Romeo can be divided by the current value of Juliet. If it divides,
we know Romeo is not a prime, and we move on to Scene IV where Romeo is incremented
by 1 and the loop re-run.

If Romeo _cannot_ be divided by the current value of Juliet, we increment
Juliet and re-run the loop until the point where Juliet is greater than Hamlet, the
square root. When this happens, we know that no integer has been able to divide
Romeo, and so a prime has been found.

At that point, we tell Romeo to `Open your heart`, which instructs him to output
his current numeric value to STDOUT. We then assign Hamlet, our temporary variable from
Denmark, the value of `10`, which is the ASCII numerical representation for a new line.
We then tell him to `Speak your mind!` which instructs him to output the associated
character (`\n`) for the numerical value he represents.

### Calculating Fibonacci up to 400

Ah, Fibonacci. In this step, we will calculate all the Fibonacci numbers up to 400.
The first step is to open the `fibonacci.spl` file and see what it contains.
You can run the script through the language parser by executing the following Docker
command:

```
docker run --rm jamiehannaford/shakespeare fibonacci
```

First we need to define our Dramatis Personæ, or variable list:

- An accumulator variable, or Romeo, who stores the latest Fibonacci number
- A controlling variable, or Juliet, who delegates tasks and controls the execution flow
- A limiting factor, or Hamlet, who will ensure we do not exceed 400
- A returning character, or Othello

In the first scene Juliet and Romeo are arguing. She calls him nothing, which
coincidentally sets his value to `0`. She then tells him to `Remember yourself`,
which causes the variable being addressed to push its current value
into its internal stack (FILO). As we already know, a leech is `-1` and a
fat-kidneyed toad is `-2`. Their difference is `1`, which is Romeo's new value. He
is then told to `Open your heart!`.

Hamlet, our limit, is then set. We then assign Othello, our return man, the
value of `10`, which is the ASCII code for a new line.

We then enter the next Act where Juliet is assigned the same value of Romeo. She
tells him to `Recall your innermost fears`, which pops a value (the previous Fibonacci
number) from his stack. Juliet then tells Romeo that his new value is the sum of his
current value (`x`) and Juliet's value (`x+1`), which makes the next Fibonacci digit.
She then ensures he is worse (less) than Hamlet (400), our limiting factor.

If he is less than 400, we output the Fibonacci number, then output Othello's ASCII
return carriage, and repeat the Scene up to the point where Romeo exceeds Hamlet, where
we move to our final scene and termination.

### Wrap-up

So I guess this is cool and all, but what's the point?

One of Shakespeare's greatest achievements was his remarkable, if ruthless, talent of
manipulating language to suit his poetic agenda. His works are constantly testing
the bounds of language with tools like metaphor, simile, rhyme, and scansion to
explore all those universal issues that still affect us. It is the plasticity of language
itself that allows Shakespeare to open up worlds onstage and fulfill his professional
obligations as an artist.

But on an elemental level, doesn't language do the same for _all_ professions, including
software engineering? We manipulate language to make computers run. We craft specially
designed input, with all its formalized grammar rules, in the hope of achieving some
kind of meaningful output or change.

I think learning new programming languages - whether traditional or experimental, serious or
flippant - serves to remind us of how powerful human language itself is, and that it can be
made to do extraordinary things. Things that are unimaginable to previous generations
are invaluable to future ones.

## Further links

- [Shakespeare Language specification](http://shakespearelang.sourceforge.net/report/shakespeare/)
- [A Python Compiler for Shakespeare Language](https://github.com/drsam94/Spl)
- [Overview to Shakespeare Language](https://en.wikipedia.org/wiki/Shakespeare_Programming_Language)
- [Know Your Language: Coding Toil and Trouble with Shakespeare](http://motherboard.vice.com/read/know-your-language-coding-toil-and-trouble-with-shakespeare)
