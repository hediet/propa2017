import Wave

import Song
import Song2
import Song3
import Song4
import SongsVideoGames

songs :: [(FilePath, Signal)]
songs = [("song.wav", Song.song),
         ("song2.wav", Song2.song),
         ("song3.wav", Song3.song),
         ("song4.wav", Song4.song),
         ("songSuperMario.wav", songSuperMario),
         ("songLegendOfZelda.wav", songLegendOfZelda),
         ("songMegaMan.wav", songMegaMan),
         ("songTetris.wav", songTetris),
         ("songNecrodancerLevel4_3.wav", songNecrodancerLevel4_3),
         ("songNecrodancerDeathMetal.wav", songNecrodancerDeathMetal)
        ]

writeAllSongs :: IO ()
writeAllSongs = mapM_ writeSong songs

writeSong :: (FilePath, Signal) -> IO ()
writeSong (file, s) = do
    writeWave file s
    putStrLn ("Wrote " ++ file)

main :: IO ()
main = writeAllSongs
