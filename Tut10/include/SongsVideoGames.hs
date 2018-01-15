module SongsVideoGames where

import Wave
import Notes

{------------------------------------------------------------------------------
 - Bitte kopieren Sie ihre Funktionen an diese Stelle und kommentieren Sie    -
 - dann die folgende Zeile aus!                                               -
 ------------------------------------------------------------------------------}
import Sound
import SongCollection

bass :: Instrument
bass freq = base * hull
  where
    base = modulatedSine (2*freq) (sine (3*freq))
    hull = hullCurve 0.01 0.05 0.3 0.5

bass2 :: Instrument
bass2 freq = base * hull
  where
    base = modulatedSine (2*freq) (sine (3*freq))
    hull = hullCurve 0.01 0.1 0.3 0.5

bass3 :: Instrument
bass3 freq = base * hull
  where
    base = modulatedSine (2*freq) (sine (3*freq))
    hull = hullCurve 0.005 0.1 0.3 0.1

leadSynth :: Instrument
leadSynth freq = base * hull
  where
    base = abs (modulatedSine freq (sine (2*freq)))
    hull = hullCurve 0.01 0.1 0 0.0001

songSuperMario = 0.37*(play bass (pattern2Notes speed sm_bass_pattern))
                + 0.18*(play bass (pattern2Notes speed sm_steel_drums1))
                + 0.18*(play bass (pattern2Notes speed sm_steel_drums2))
                + 0.27*(play leadSynth (pattern2Notes speed sm_marimba))
    where speed = 24/50
   
songLegendOfZelda = play leadSynth (pattern2Notes speed loz)
    where speed = 24/50
   
songMegaMan = play leadSynth (pattern2Notes speed mm)
    where speed = 24/50
   
songTetris = play leadSynth (pattern2Notes speed tetris)
    where speed = 60/140
          tetris = tetris_pattern1 ++ tetris_pattern1 ++ tetris_pattern2

songNecrodancerLevel4_3 = 0.6*(play leadSynth (pattern2Notes speed wight))
                            + 0.4*(play bass2 (pattern2Notes speed wight_bass))
    where speed = 60/160

songNecrodancerDeathMetal = 0.5*(play bass3 (pattern2Notes speed dm1))
                            + 0.5*(play bass3 (pattern2Notes speed dm2))
                            + 0.5*(play leadSynth (pattern2Notes speed dm3))
    where speed = 120/175
