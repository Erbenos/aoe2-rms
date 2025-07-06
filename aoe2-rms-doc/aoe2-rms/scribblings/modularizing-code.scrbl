#lang scribble/manual

@(require(except-in (for-label aoe2-rms) #%module-begin))

@title[#:tag "modularizing-code"]{Modularizing Code}

Its relatively common that multiple maps from the same author have similar aspects, behavior wise. One such example is notion of disabling trade in team games, as trade can be source of infinite resources, which may promote turtle-ish strategies. Indeed, lets take a look at some maps:

@itemlist[
 #:style 'compact
 @item{@hyperlink["https://github.com/Alchemy-AOE-Community/CHEM-Random-Map-Scripts/blob/0b51e08c7997279bbaa02665adb7706c24d3d713/Workshop_Zetnus/Antarctica/ZN%40Antarctica.rms#L78"]{Antarctica by Zetnus}}
 @item{@hyperlink["https://github.com/Alchemy-AOE-Community/CHEM-Random-Map-Scripts/blob/6ed4d496fc11b0ca81e971ef44600cdf3fdbfe2a/Workshop_TechChariot/ESC_Saranac/ESC_Saranac.rms#L35"]{Saranac by TechChariot}}
 @item{@hyperlink["https://github.com/Alchemy-AOE-Community/CHEM-Random-Map-Scripts/blob/e4cc4779e9cb4acc523f9fd37fcdb7780b41a113/Workshop_Magico/ESR_04_Paradise_Island/ESR_04_Paradise_Island.rms#L160"]{Paradise Island by Magico}}
 @item{@hyperlink["https://github.com/Alchemy-AOE-Community/CHEM-Random-Map-Scripts/blob/dc761bd4fac0afaa5481306e43245558c6f8d7ff/Kroraina/Kroraina.rms#L129"]{Kroraina by XingXing}}
 @item{@etc}
 ]

Notice how all of them have a variation of trade disabling section:

@margin-note{I have no clue why the ATTR_DISABLE is followed up by number literal again.}

@code-inset{
 @verbatim{
  /* Disabling Trade Carts and Cogs for Multi-team Games */
  if 2_TEAM_GAME
  else
  #const TRADE_CART_ENABLER 161
  #const TRADE_COG_ENABLER 180
  #const TRADE_CARAVAN_ENABLER 48
  #const HINDU_CARAVANSERAI_ENABLER 518
  #const PERSIAN_CARAVANSERAI_ENABLER 552
  #const SILK_ROAD 499
  effect_amount DISABLE_TECH TRADE_COG_ENABLER ATTR_DISABLE 180
  effect_amount DISABLE_TECH TRADE_CART_ENABLER ATTR_DISABLE 161
  effect_amount DISABLE_TECH TRADE_CARAVAN_ENABLER ATTR_DISABLE 48
  effect_amount DISABLE_TECH HINDU_CARAVANSERAI_ENABLER ATTR_DISABLE 518
  effect_amount DISABLE_TECH PERSIAN_CARAVANSERAI_ENABLER ATTR_DISABLE 552
  effect_amount DISABLE_TECH SILK_ROAD ATTR_DISABLE 499
  endif
 }
}

Copy pasting this magical invocation is quite annoying a only clutters the contents of the file the author actually cares about.

Lets make it more seamless to re-use a chunk of code across many files.

First abstract above snippet (or most of it) into a function, just like was shown in @secref["functions"]:

@racketmod[
 #:file "map.rkt"
 aoe2-rms

 (define (disable-trade)
   (define (disable-tech tech-name)
     (effect-amount 'DISABLE_TECH tech-name 'ATTR_DISABLE tech-name))
   (%const 'DISABLE_TRADE_TRADE_CART_ENABLER 161)
   (%const 'DISABLE_TRADE_TRADE_COG_ENABLER 180)
   (%const 'DISABLE_TRADE_TRADE_CARAVAN_ENABLER 48)
   (%const 'DISABLE_TRADE_HINDU_CARAVANSERAI_ENABLER 518)
   (%const 'DISABLE_TRADE_PERSIAN_CARAVANSERAI_ENABLER 552)
   (%const 'DISABLE_TRADE_SILK_ROAD 449)
   (disable-tech 'DISABLE_TRADE_TRADE_CART_ENABLER)
   (disable-tech 'DISABLE_TRADE_TRADE_COG_ENABLER)
   (disable-tech 'DISABLE_TRADE_TRADE_CARAVAN_ENABLER)
   (disable-tech 'DISABLE_TRADE_HINDU_CARAVANSERAI_ENABLER)
   (disable-tech 'PERSIAN_CARAVANSERAI_ENABLER)
   (disable-tech 'SILK_ROAD))

 (%unless '2_TEAM_GAME (disable-trade))
 ]

This is nicer, however still, we want to make this callable from many maps. To archieve that, we can put the function
into a separate file:

@racketmod[
 #:file "trade.rkt"
 aoe2-rms

 (define (disable-trade)
   (define (disable-tech tech-name)
     (effect-amount 'DISABLE_TECH tech-name 'ATTR_DISABLE tech-name))
   (%const 'DISABLE_TRADE_TRADE_CART_ENABLER 161)
   (%const 'DISABLE_TRADE_TRADE_COG_ENABLER 180)
   (%const 'DISABLE_TRADE_TRADE_CARAVAN_ENABLER 48)
   (%const 'DISABLE_TRADE_HINDU_CARAVANSERAI_ENABLER 518)
   (%const 'DISABLE_TRADE_PERSIAN_CARAVANSERAI_ENABLER 552)
   (%const 'DISABLE_TRADE_SILK_ROAD 449)
   (disable-tech 'DISABLE_TRADE_TRADE_CART_ENABLER)
   (disable-tech 'DISABLE_TRADE_TRADE_COG_ENABLER)
   (disable-tech 'DISABLE_TRADE_TRADE_CARAVAN_ENABLER)
   (disable-tech 'DISABLE_TRADE_HINDU_CARAVANSERAI_ENABLER)
   (disable-tech 'PERSIAN_CARAVANSERAI_ENABLER)
   (disable-tech 'SILK_ROAD))

 (provide (all-defined-out))
 ]

This file can then be required from other files, bringing the @racket[disable-trade] function into scope:

@racketmod[
 #:file "map.rkt"
 aoe2-rms

 (require "trade.rkt")

 (%unless '2_TEAM_GAME (disable-trade))
 ]

Read  @secref["modules" #:doc '(lib "scribblings/guide/guide.scrbl")] for more information.

@section["Gotchas"]

Anything you want to reuse from other files HAS to be wrapped into functions that are called from the
"main" file, otherwise it does not get included into the generated script.

Following would NOT work:

@racketmod[
 #:file "setup.rkt"
 aoe2-rms

 (require "trade.rkt")

 (%unless '2_TEAM_GAME (disable-trade))
 ]

And then including such into map file:

@racketmod[
 #:file "map.rkt"
 aoe2-rms

 (require "setup.rkt")
 ]

Transpiling the "map.rkt" file would result into empty result.
