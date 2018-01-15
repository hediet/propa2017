module Main where

import Sound
import Song2
import Wave
import Notes

main :: IO ()
main = writeWave "./out.wav" (play leadSynth (pattern2Notes speed leadPattern0))

