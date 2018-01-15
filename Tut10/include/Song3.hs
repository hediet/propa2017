module Song3 where

import Wave
import Notes

{------------------------------------------------------------------------------
 - Schreiben Sie ihre Funktionen in einem Modul "Sound", oder                 -
 - kopieren Sie ihre Funktionen an diese Stelle und kommentieren Sie          -
 - dann die folgende Zeile aus!                                               -
 ------------------------------------------------------------------------------}
import Sound

leadPattern0 = [
  ("", 4),
  ("c4", 4),
  ("e4", 4),
  ("a4", 4),
  ("b4", 4),
  ("e4", 4),
  ("c4", 4),
  ("b4", 4),
  ("c5", 4),
  ("e4", 4),
  ("c4", 4),
  ("c5", 4),
  ("f#4",4),
  ("d4", 4),
  ("a3", 4),
  ("f#4",4),
  ("e4",4),
  ("c4",4),
  ("a3",4),
  ("c4",4),
  ("", 4),
  ("e4",4),
  ("c4",4),
  ("a3",4),
  ("b3",4),
  ("c4",4),
  ("c4",4)
  ]

leadPattern1 = [
  ("", 4),
  ("", 4),
  ("", 4),
  ("", 4),
  ("", 4),
  ("", 4),
  ("", 4),
  ("", 4),
  ("", 4),
  ("", 4),
  ("", 4),
  ("", 4),
  ("",4),
  ("", 4),
  ("", 4),
  ("", 4),
  ("",4),
  ("",4),
  ("",4),
  ("",4),
  ("",4),
  ("",4),
  ("",4),
  ("",4),
  ("g3",4),
  ("a3",4),
  ("a3",4)
  ]

bassPattern = [
  ("g3",  4),
  ("",    4),
  ("",    4),
  ("",    4),
  ("g#3", 4),
  ("",    4),
  ("",    4),
  ("",    4),
  ("g3",  4),
  ("",    4),
  ("",    4),
  ("",    4),
  ("f#3", 4),
  ("",    4),
  ("",    4),
  ("",    4),
  ("f3",  4),
  ("",    4),
  ("",    4),
  ("",    4),
  ("",    4),
  ("f#3", 4),
  ("",    4),
  ("",    4),
  ("b2",  4),
  ("a2",  4),
  ("a2",  4)]

completeBass = bassPattern
completeLead = leadPattern0  ++ leadPattern1

leadSynth :: Instrument
leadSynth freq = base * hull
  where
    base = modulatedSine freq (sine (2 * freq))
    hull = hullCurve (0.25 * speed) (0.5 * speed) 0.8 (5.0 * speed)

guitar :: Instrument
guitar freq = base * hull
  where
    base = modulatedSine freq (sine freq)
    hull = exponentialHull (2 * speed)

exponentialHull :: Double -> Signal
exponentialHull halflife = Signal (map scaledExp [0..])
  where
    scaledExp t = exp (λ*t)
    λ = (log 0.5)/(halflife*sampleRate)

speed = 6/50
song = 0.33*(playOverlap overlap guitar (pattern2Notes speed completeBass)) +
       0.33*(playOverlap overlap guitar (pattern2Notes speed leadPattern0)) +
       0.33*(playOverlap overlap guitar (pattern2Notes speed leadPattern1))
  where overlap = 6 * speed




-- play ohne "clicks" für instrumente mit vernünftiger Lautstärkenhülle
-- Implementierung ist allerdings recht ineffizient
playOverlap :: Double -> Instrument -> [(Double,Double)] -> Signal
playOverlap overlapLength instrument notes = foldr plusfill empty prefixedSamples
  where
    plusfill (Signal a) (Signal b) = Signal (pf a b)
      where pf l [] = l
            pf [] r = r
            pf (x:xs) (y:ys) = (x+y):(pf xs ys)

    indexedNotes = zipWith combine notes (scanl (+) 0 [ length | (pitch,length) <- notes])
      where combine (pitch,length) index = (pitch, length, index)

    prefixedSamples = [
         (silence `trim` index) `append` (((instrument x) `append` silence) `trim` (noteLength + overlapLength))
       | (x, noteLength, index) <- indexedNotes
     ]
