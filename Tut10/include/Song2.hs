module Song2 where

import Wave
import Notes

{------------------------------------------------------------------------------
 - Schreiben Sie ihre Funktionen in einem Modul "Sound", oder                 -
 - kopieren Sie ihre Funktionen an diese Stelle und kommentieren Sie          -
 - dann die folgende Zeile aus!                                               -
 ------------------------------------------------------------------------------}
import Sound

leadPattern0 = [
  ("e4", 2),
  ("e4", 2),
  ("e4", 4),

  ("e4", 2),
  ("e4", 2),
  ("e4", 4),

  ("e4", 2),
  ("g4", 2),
  ("c4", 2),
  ("d4", 2),

  ("e4", 8),

  ("f4", 2),
  ("f4", 2),
  ("f4", 2),
  ("f4", 2),

  ("f4", 2),
  ("e4", 2),
  ("e4", 3),
  ("e4", 1),

  ("e4", 2),
  ("d4", 2),
  ("d4", 2),
  ("e4", 2),

  ("d4", 4),
  ("g4", 4)
  ]

leadPattern1 = [
  ("e4", 2),
  ("e4", 2),
  ("e4", 4),

  ("e4", 2),
  ("e4", 2),
  ("e4", 4),

  ("e4", 2),
  ("g4", 2),
  ("c4", 2),
  ("d4", 2),

  ("e4", 8),

  ("f4", 2),
  ("f4", 2),
  ("f4", 2),
  ("f4", 2),

  ("f4", 2),
  ("e4", 2),
  ("e4", 2),
  ("e4", 2),

  ("g4", 2),
  ("g4", 2),
  ("f4", 2),
  ("d4", 2),

  ("c4", 6)
  ]

bassPattern = [
  ("c3", 4),
  ("a2", 4),

  ("c3", 4),
  ("a2", 4),

  ("c3", 4),
  ("a2", 4),

  ("c3", 8),

  ("g2", 4),
  ("b2", 4),

  ("c3", 4),
  ("g2", 4),

  ("f#2",4),
  ("g2", 4),

  ("g2",4),
  ("b2",4),

  ("c3", 4),
  ("g2", 4),

  ("c3", 4),
  ("g2", 4),

  ("c3", 4),
  ("g2", 4),

  ("c3", 8),

  ("g2", 4),
  ("b2", 4),

  ("c3", 4),
  ("a2", 4),

  ("g2", 4),
  ("b2", 4),

  ("", 6),
  ("g2", 2)
  ]

completeBass = bassPattern
completeLead = leadPattern0  ++ leadPattern1

bass :: Instrument
bass freq = base * hull
  where
    base = modulatedSine (2*freq) (sine (3*freq))
    hull = hullCurve 0.01 0.05 0.3 0.5

leadSynth :: Instrument
leadSynth freq = base * hull
  where
    base = abs (modulatedSine freq (sine (2*freq)))
    hull = hullCurve 0.01 0.1 0 0.0001

speed = 6/50
song = 0.4*(play bass      (pattern2Notes speed completeBass)) +
       0.6*(play leadSynth (pattern2Notes speed completeLead))
