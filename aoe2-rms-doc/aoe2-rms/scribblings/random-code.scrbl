#lang scribble/manual

@(require(except-in (for-label aoe2-rms) #%module-begin))

@title[#:tag "random-code"]{Random Code}

Can be used just about anywhere to add an element of randomness to your script.

@defform[(%random random-clause ...)
         #:grammar
         [(random-clause (code:line [percent-chance then-body ...]))]]{
 Game versions: All

 Arguments:

 @itemlist[
 @item{percent-chance - integer (0-99)}
 @item{then-body - anything}
 ]

 Specify a piece of code that has a @seclink["random-code"]{defined chance} of being chosen.

 @itemlist[
 @item{If the total percentages add up to less than 99%, there is a chance that none of them get chosen.}
 @item{If the total exceeds 99%, only the first 99% will have a chance of occurring.}
 @item{Random constructs can encompass individual arguments, or even whole blocks of code.}
 @item{They cannot be nested.  To achieve a non-integer chance, use a first random block to define (using @racket[%define]) which additional random block to run.}
 @item{BUG: if the first branch is 0, it is still chosen occasionally.  Do not include a 0 chance branch as the first branch.  Also note that the 100th percent is never chosen.}
 @item{BUG (AoC/HD/UP): Comments in dead branches are not ignored.  Do not include any underlying random syntax (ie. end_random) in such comments.  For more information, see this external article: @hyperlink["http://aok.heavengames.com/cgi-bin/forums/display.cgi?action=ct&f=26,42304,,365"]{Parser Pitfalls}}
 ]

 Example: Place 5 or 6 or 7 gold mines with 6 being the most likely.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'GOLD
                (%random [30 (number-of-objects 5)]
                         [50 (number-of-objects 6)]
                         [20 (number-of-objects 7)]))
 ]

 Example: Have a 10% chance of placing 5 gold mines (and a 90% of not doing so)
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (%random [10 (create-object 'GOLD
                             (number-of-objects 5))])
 ]
}

@defproc[(%random-number [min any/c] [max any/c]) string?]{
 Game versions: UP/DE
 Arguments:
 min - number
 max - number

 @seclink["random-code"]{Randomize} a numeric argument between min and max (inclusive).

 @itemlist[
 @item{Make sure max exceeds min.}
 @item{Cannot be used within @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.bqp5f3wcm40e"]{math operations.}}
 ]

 Example: Place 5 or 6 or 7 gold piles, and randomly change the amount of gold (it will be the same amount in all of them)
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'GOLD
                (number-of-objects (%random-number 5 7))
                (resource-delta (%random-number -200 300)))
 ]
}

