module OSM where
import System.IO.Unsafe

type Key = String
type Value = String

data OSMNode = OSMNode String Double Double [(Key, Value)]
  deriving (Show, Eq, Read)

-- OpenStreetMap data, (c) OpenStreetMap contributors, see http://www.openstreetmap.org/copyright
karlsruhe :: [OSMNode]
-- don't do this at home, kids
karlsruhe = unsafePerformIO $ read <$> readFile "OSM.data"
