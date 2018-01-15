module Sound where

import Wave

{- Teilaufgabe 1 -}

constant :: Double -> Signal
constant x = Signal (repeat x)

silence :: Signal
silence = constant 0

time2Rad :: Double -> Double
time2Rad f = 2*pi*f/sampleRate

-- sine Frequency
sine :: Double -> Signal
sine freq = Signal (map scaledSin [0..])
  where
    scaledSin t = sin (time2Rad (t*freq))

trim :: Signal -> Double -> Signal
trim (Signal signal) t = Signal (take (double2Int (time2Samples t)) signal)
  where
    double2Int :: Double -> Int
    double2Int = fromInteger . floor

{- Teilaufgabe 2 -}

instance Num Signal where
  (Signal signal1) + (Signal signal2) = Signal (zipWith (+) signal1 signal2)
  (Signal signal1) - (Signal signal2) = Signal (zipWith (-) signal1 signal2)
  (Signal signal1) * (Signal signal2) = Signal (zipWith (*) signal1 signal2)
  abs (Signal signal)    = Signal (map abs signal)
  signum (Signal signal) = Signal (map signum signal)
  fromInteger i          = constant (fromInteger i)

instance Fractional Signal where
  (Signal signal1) / (Signal signal2) = Signal (zipWith (/) signal1 signal2)
  fromRational x         = constant (fromRational x)

{- Teilaufgabe 3 -}

integrate :: Signal -> Signal
integrate (Signal s) = Signal (integrateSignal 0 0 s)
  where
    integrateSignal acc y [] = []
    integrateSignal acc y (x : xs) =
        acc : integrateSignal (acc + (x + y) / (2 * sampleRate)) x xs

-- modulatedSine carrierFrequency modulatorSignal
modulatedSine :: Double -> Signal -> Signal
modulatedSine freq s = modulate (integrate s)
  where
    modulate (Signal s') = Signal (zipWith combine s' [0..])
    combine df t = sin (freq * (time2Rad t + df))

{- Teilaufgabe 4 -}

append :: Signal -> Signal -> Signal
append (Signal signal1) (Signal signal2) = Signal (signal1 ++ signal2)

rampUp :: Double -> Signal
rampUp 0 = Signal [] -- this special case avoids a division by zero in the map
rampUp t = Signal (map (/(time2Samples t)) [0..time2Samples t])

-- ramp from to time
ramp :: Double -> Double -> Double -> Signal
ramp from to t = (constant from) + ((rampUp t) * (constant (to-from)))

-- hullCurve attack decay decayLevel release
hullCurve :: Double -> Double -> Double -> Double -> Signal
hullCurve attack decay decayLevel release
  = (rampUp attack) `append` (ramp 1.0 decayLevel decay) `append` (ramp decayLevel 0.0 release)

-- A synth instrument
-- synthLead freq
synthLead :: Double -> Signal
synthLead freq = base * hull
  where
    base = modulatedSine freq (sine freq)
    hull = hullCurve 0.004 0.2 0.625 2.0

{- Teilaufgabe 5 - Kür -}

type Instrument = Double -> Signal

empty :: Signal
empty = Signal []

-- play instrument [(noteFrequency,noteLength)]
play :: Instrument -> [(Double,Double)] -> Signal
play instrument notes
  = foldr (append . playNote) empty notes
  where
    playNote :: (Double,Double) -> Signal
    playNote (0,noteLength) = silence `trim` noteLength
    playNote (x,noteLength) = ((instrument x) `append` silence) `trim` noteLength

cMajor = 0.3 * (sine 261) + 0.3 * (sine 329) + 0.3 * (sine 392)
