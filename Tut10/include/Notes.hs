module Notes where

-- Notes C4..B4
notes4 = [
  ("c4",  261.63),
  ("c#4", 277.18),
  ("d4",  293.66),
  ("d#4", 311.13),
  ("e4",  329.63),
  ("f4",  349.23),
  ("f#4", 369.99),
  ("g4",  392.00),
  ("g#4", 415.00),
  ("a4",  440.00),
  ("a#4", 466.16),
  ("b4",  493.88)
  ]
-- We can generate the other octaves by doubling/halving the frequencies
notes5 = map (\(name, freq) -> ((init name)++"5", freq*2.0)) notes4
notes6 = map (\(name, freq) -> ((init name)++"6", freq*2.0)) notes5
notes3 = map (\(name, freq) -> ((init name)++"3", freq/2.0)) notes4
notes2 = map (\(name, freq) -> ((init name)++"2", freq/2.0)) notes3
notes1 = map (\(name, freq) -> ((init name)++"1", freq/2.0)) notes2
notes = notes1 ++ notes2 ++ notes3 ++ notes4 ++ notes5 ++ notes6 ++ [ ("", 0) ]

note2Freq :: String -> Double
note2Freq name = case lookup name notes of
  (Just x)  -> x
  (Nothing) -> error ("note2Freq: Invalid note name " ++ name)

pattern2Notes :: Double -> [(String, Double)] -> [(Double, Double)]
pattern2Notes speed = map (\(noteName, l) -> (note2Freq noteName, l*speed))
