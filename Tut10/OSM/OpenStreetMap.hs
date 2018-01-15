module OpenStreetMap where

import Data.List
import Data.Maybe
import Data.Ord
import Text.Read

import OSM

-- Haskell >= 4.8.0 hat diesen Operator in Data.Function eingebaut.
infixl 1 &
x & f = f x

-- siehe Hinweise
printList l = l & map show & unlines & putStr

-- Teil 1
hasKVWhere :: (Key -> Value -> Bool) -> OSMNode -> Bool
hasKVWhere pred (OSMNode _ _ _ kvs) = any (uncurry pred) kvs

hasKey :: Key -> OSMNode -> Bool
hasKey   key       = hasKVWhere (\k _ -> k == key)

hasValue :: Value -> OSMNode -> Bool
hasValue value     = hasKVWhere (\_ v -> v == value)

hasKV :: Key -> Value -> OSMNode -> Bool
hasKV    key value = hasKVWhere (\k v -> k == key && v == value)


-- Teil 2
countOpeningHours :: Int
countOpeningHours = length (filter (hasKey "opening_hours") karlsruhe)

studentAssociations :: [OSMNode]
studentAssociations = filter (hasKV "university" "student_association") karlsruhe

sundayBakeries :: [OSMNode]
sundayBakeries = karlsruhe
                 & filter (hasKV "shop" "bakery")
                 & filter (hasKVWhere (\k v -> k == "opening_hours" &&
                                               "Su" `isInfixOf` v))

-- Für einen fairen Vergleich sollten als Grundmenge nur die
-- Bäckereien herangezogen werden, die überhaupt Öffnungszeiten
-- eingetragen haben.
shareOfSundayBakeries :: Double
shareOfSundayBakeries =
  openOnSundays / hasOpeningHours
  where
    bakeriesWithOpeningHours = karlsruhe
                               & filter (hasKV "shop" "bakery")
                               & filter (hasKey "opening_hours")

    hasOpeningHours = fromIntegral (length bakeriesWithOpeningHours)

    openOnSundays = bakeriesWithOpeningHours
                    & filter (hasKVWhere (\k v -> k == "opening_hours" &&
                                                  "Su" `isInfixOf` v))
                    & length
                    & fromIntegral


-- Teil 3
counts :: (Ord a) => [a] -> [(a, Int)]
counts list = list & sort
                   & group
                   & map (\group@(first:_) -> (first, length group))
                   & sortBy (comparing snd)
                   & reverse

allKeys :: OSMNode -> [Key]
allKeys (OSMNode _ _ _ kvs) = map fst kvs

keysInKarlsruhe :: [(Key, Int)]
keysInKarlsruhe = karlsruhe
                  & concatMap allKeys
                  & counts

-- Teil 4

-- Erstmal noch ein paar Hilfsfunktionen
readMaybeInt :: String -> Maybe Int
readMaybeInt = readMaybe

getKeyValue :: Key -> OSMNode -> Maybe Value
getKeyValue key (OSMNode _ _ _ kvs) = do
  (k, v) <- find (\(k, v) -> k == key) kvs
  return v

distance :: OSMNode -> OSMNode -> Double
distance (OSMNode _ lat1 lon1 _) (OSMNode _ lat2 lon2 _) =
  sqrt ((111194 * (lat2 - lat1))**2 +
        ( 72927 * (lon2 - lon1))**2)

largestBench :: OSMNode
largestBench = karlsruhe
               & filter (hasKV "amenity" "bench")
               & map getSeats
               & catMaybes
               & sortBy (comparing fst)
               & map snd
               & last
  where
    getSeats node = do
      seatsStr <- getKeyValue "seats" node
      seats <- readMaybeInt seatsStr
      return (seats, node)

averageDistanceToPlayground :: Double
averageDistanceToPlayground =
  average (map minDist karlsruhe)
  where
    playgrounds = karlsruhe & filter (hasKV "leisure" "playground")
    minDist n = minimum (map (distance n) playgrounds)
    average l = sum l / fromIntegral (length l)

foodNearby :: Double -> Double -> Maybe [Value] -> Bool -> [OSMNode]
foodNearby lat lon cuisinesWanted requireTakeaway =
  karlsruhe & filter (\node -> hasKV "amenity" "fast_food" node ||
                               hasKV "amenity" "restaurant" node)
            & filter cuisineAcceptable
            & filterIfTakeawayRequired
            & sortBy (comparing (distance dummyNode))
  where
    cuisineAcceptable node =
      case cuisinesWanted of
        Nothing -> True
        Just cw ->
          case getKeyValue "cuisine" node of
            Nothing -> False
            Just c -> c `elem` cw

    filterIfTakeawayRequired =
      if requireTakeaway
      then filter (hasKV "takeaway" "yes")
      else id -- Do nothing

    -- distance braucht als Argument einen OSMNode, aber wir haben nur
    -- Koordinaten gegeben. Deshalb erzeugen wir hier einen
    -- Dummy-Node.
    dummyNode = OSMNode "" lat lon []

geocache :: OSMNode
geocache = error "Find it yourself ;)"
