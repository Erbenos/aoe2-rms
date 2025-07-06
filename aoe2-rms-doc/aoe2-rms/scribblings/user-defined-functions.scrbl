#lang scribble/manual

@(require(except-in (for-label aoe2-rms) #%module-begin))

@title[#:tag "functions"]{User Defined Functions}

Let's assume you want to place many lands in your map that are constrained border-wise via the @racket[top-border], @racket[right-border], @racket[bottom-border] and @racket[left-border].

Such a script can look like this:

@racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-land
  (terrain-type 'WATER)
  (top-border 10) (right-border 20) (bottom-border 30) (left-border 40))

 (create-land
  (terrain-type 'DIRT)
  (top-border 11) (right-border 22) (bottom-border 11) (left-border 22))

 (create-land
  (terrain-type 'DIRT)
  (top-border 12) (right-border 24) (left-border 48))

 (create-land
  (terrain-type 'DIRT)
  (top-border 13) (right-border 13) (bottom-border 13) (left-border 13))
 ]

Obviously this can get really repetitive and error-prone quite quickly. Luckily for us, we can abstract away arbitrary declarations into a function.

Let's create a function which takes 4 parameters: top, right, bottom, left, and for each specified value creates the {side}-border attribute.

Such a function may look like this:

@margin-note{Beware that @racket[define] has different semantics compared to Random Map Scripting @racket[%define]. Former creates Racket variable, whereas latter creates Random Map Scripting condition label.}

@racketmod[
 aoe2-rms

 (define (inset-border top right bottom left)
   (when top (top-border top))
   (when right (right-border right))
   (when bottom (bottom-border bottom))
   (when left (left-border left)))

 <LAND-GENERATION>
 (create-land (terrain-type 'WATER) (inset-border 10 20 30 40))
 (create-land (terrain-type 'DIRT) (inset-border 11 22 11 22))
 (create-land (terrain-type 'DIRT) (inset-border 12 24 #f 48))
 (create-land (terrain-type 'DIRT) (inset-border 13 13 13 13))
 ]

This is actually equivalent to the first example. Notice that in third @racket[create-land] we pass @racket[#f] to the @italic{bottom} argument, which would result in no @racket[bottom-border] attribute being present.

Notice that no attributes or blocks actually return anything by looking the documentation. Or rather, they return @racket[void?] which is the representation of no value. Usually the functions in racket return result of their last body, but the way attributes (and most of the other @racket[aoe2-rms] constructs) work is that they register themselves into the place have have been called from. Such is enabled by @hyperlink["https://en.wikipedia.org/wiki/Scope_(computer_science)#Dynamic_scope"]{Dynamic Variable Scope}.

We can however go even further and make our function support multiple arities:

@racketmod[
 aoe2-rms

 (define inset-border
   (begin
     (define (fn top right bottom left)
       (when top (top-border top))
       (when right (right-border right))
       (when bottom (bottom-border bottom))
       (when left (left-border left)))
     (case-lambda
       [(x) (fn x x x x)]
       [(y x) (fn y x y x)]
       [(top right bottom left) (fn top right bottom left)])))

 <LAND-GENERATION>
 (create-land (terrain-type 'WATER) (inset-border 10 20 30 40))
 (create-land (terrain-type 'DIRT) (inset-border 11 22))
 (create-land (terrain-type 'DIRT) (inset-border 12 24 #f 48))
 (create-land (terrain-type 'DIRT) (inset-border 13))
 ]

This is also equivalent to earlier examples.

We can also abstract over the creation of the land itself. We can create a shorthand for a land thats always DIRT. To do that, we have to create a function that accepts another function as an argument.

@racketmod[
 aoe2-rms

 (define inset-border
   (begin
     (define (fn top right bottom left)
       (when top (top-border top))
       (when right (right-border right))
       (when bottom (bottom-border bottom))
       (when left (left-border left)))
     (case-lambda
       [(x) (fn x x x x)]
       [(y x) (fn y x y x)]
       [(top right bottom left) (fn top right bottom left)])))

 (define (create-dirt-land body-decl)
   (create-land (terrain-type 'DIRT) (body-decl)))

 <LAND-GENERATION>
 (create-land (terrain-type 'WATER) (inset-border 10 20 30 40))
 (create-dirt-land (lambda () (inset-border 11 22)))
 (create-dirt-land (lambda () (inset-border 12 24 #f 48)))
 (create-dirt-land (lambda () (inset-border 13)))
 ]

See more information in @secref["define" #:doc '(lib "scribblings/reference/reference.scrbl")] and @secref["lambda" #:doc '(lib "scribblings/reference/reference.scrbl")] sections.
