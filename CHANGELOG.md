# Changelog for steering-behaviors

## 2.0.0, 13 August 2013
* Alteration to feel_the_force() to accept hashed options to alter behavior (API change)
* A new combo pursuit/evasion demo showing both behaviors simultaneously
* Big cosmetic changes to example front-end
* Predictive interception lookahead tweaked slightly
* Bugfix: angle-limited steering could never be accelerative
* Demo characters move more slowly, helping make the examples more illustrative
* Separation demo includes danger-radius circle, smaller time lookahead
* Separation steering force scaled by speed for proper strength
* feel_the_force() returns immediately for zero-vector steering

## 1.0.7, 12 August 2013
* Fix embarrassing bug (left 'puts' statements uncommented in prior release)

## 1.0.6, 11 August 2013
* Refined 'separate' to employ forwardness as part of its calculation.

## 1.0.5, 11 August 2013
* Added 'separate', a predictive collision-avoidance steering behavior

## 1.0.4, 8 August 2013
* Rewrote 'arrive' to the more canonical behavior described by Reynolds

## 1.0.3, 31 July 2013
* Bugfixes in ortho/bside; cleanup of align/match

## 1.0.1, 31 July 2013
* Some mild optimizations in Vector (caching, Pi calcs)

## 1.0.0, 25 July 2013
* Initial Gem release
