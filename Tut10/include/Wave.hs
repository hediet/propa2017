{- Simple module to write (audio-) wave Signals to ".wav"-files -}
{-# LANGUAGE BangPatterns #-}
module Wave where

import Data.Word
import Data.Binary.Put
import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString.Char8 as B
import qualified Data.Binary.Builder as BB
import System.IO as IO

-- Represents a wave signal.
-- For audio signals the values should be in the interval [-1.0, 1.0]
data Signal = Signal [Double] deriving(Show, Eq)

-- samples per second
sampleRate :: Double
sampleRate = 44100

-- Converts a time in seconds into a sample-position
time2Samples :: Double -> Double
time2Samples secs = secs * sampleRate

-- Create ".wav"-header
createHeader :: Integer -> BL.ByteString
createHeader nrOfsamples = runPut bytes
  where
    sampleSize = 2 -- sample size in bytes
    fmtChunkSize = 36
    sampleRate' = floor sampleRate
    dataLength = sampleSize * nrOfsamples
    bytes :: Put
    bytes = do
      putByteString (B.pack "RIFF")                         -- file-magic
      putWord32le (fromInteger (dataLength + fmtChunkSize)) -- file length
      putByteString (B.pack "WAVE")                         -- filetype
      putByteString (B.pack "fmt ")                         -- chunk "fmt " begins
      putWord32le 16                                        -- chunk length
      putWord16le 1                                         -- format: pcm
      putWord16le 1                                         -- channels
      putWord32le (fromInteger sampleRate')                 -- samplerate
      putWord32le (fromInteger (sampleRate'*sampleSize))    -- bytes per second
      putWord16le (fromInteger sampleSize)                  -- bytes per sample
      putWord16le (fromInteger (sampleSize*8))              -- bits per sample
      putByteString (B.pack "data")                         -- chunk "data" begins
      putWord32le (fromInteger dataLength)                  -- chunk length

writeToHandle :: Handle -> [Double] -> IO (Maybe String,Integer)
writeToHandle handle signal = wth signal Nothing 0
  where
    wth []     !err !length = return (err,length)
    wth (x:xs) !err !length = do
      BL.hPut handle $ BB.toLazyByteString $ BB.putWord16le xWord16
      wth xs newError (length + 1)
        where xWord16 = fromIntegral (round (x*max16))
              newError
               | validValue x = err
               | otherwise     =  Just "Warning: Your signal is not in the [-1,1] range everywhere"
    max16 :: Double
    max16 = fromIntegral ((maxBound::Word16) `div` 2)

-- It seems some people produce signals outside the [-1,1] range, try to warn
-- them...
validValue x = (-1-epsilon) <= x && x <= (1+epsilon)
  where epsilon      = 1e-10

-- Writes a .wav file to disk
-- writeWave filename signal
writeWave :: FilePath -> Signal -> IO ()
writeWave filename (Signal signal) = do
  waveFileHandle <- IO.openFile filename IO.WriteMode
  waveFileStart <- hGetPosn waveFileHandle
  BL.hPut waveFileHandle (createHeader 0)
  (err,length) <- writeToHandle waveFileHandle signal
  hSetPosn waveFileStart
  BL.hPut waveFileHandle (createHeader length)
  case err of (Just msg) -> putStrLn msg
              Nothing    -> return ()
  hClose waveFileHandle
