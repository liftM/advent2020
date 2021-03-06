module Advent2020.Internal.D17
  ( Pocket (..),
    numCubes,
    Cube,
    parse,
    step,
    stepN,
    Hypercube,
    parse',
    step',
    stepN',
  )
where

import Advent2020.Internal (gridMap, parseGrid, parseWithPrettyErrors, unsafeNonEmpty)
import Control.Lens ((^.))
import qualified Data.List as List
import qualified Data.Map as Map
import Relude
import Relude.Extra.Map
import Text.Megaparsec (eof)
import Text.Megaparsec.Char (char)

type Cube = (Int, Int, Int)

type Hypercube = (Int, Int, Int, Int)

newtype Pocket t = Pocket {activeCubes :: Set t}
  deriving (Show, Eq)

numCubes :: (Ord t) => Pocket t -> Int
numCubes (Pocket actives) = size actives

parse_ :: (Ord t) => ((Int, Int) -> t) -> Text -> Either Text (Pocket t)
parse_ interpretPosition = parseWithPrettyErrors $ do
  g <- parseGrid cubeP <* eof
  let cubes' = interpretPosition . fst <$> filter snd (Map.toList $ g ^. gridMap)
  return $ Pocket $ fromList cubes'
  where
    activeP = True <$ char '#'
    inactiveP = False <$ char '.'
    cubeP = activeP <|> inactiveP

parse :: Text -> Either Text (Pocket Cube)
parse = parse_ $ \(x, y) -> (x, y, 0)

parse' :: Text -> Either Text (Pocket Hypercube)
parse' = parse_ $ \(x, y) -> (x, y, 0, 0)

step_ :: (Ord t) => (t -> [t]) -> Pocket t -> Pocket t
step_ neighbors p@(Pocket actives) = Pocket $ fromList nextActives
  where
    actives' = toList actives
    -- Cubes only consider their neighbors, so iterate everything that's active
    -- plus everything that's a neighbor of something active.
    relevant = actives' ++ mconcat (neighbors <$> actives')
    next = zip relevant $ stepPosition neighbors p <$> relevant
    nextActives = fst <$> filter snd next

stepPosition :: (Ord t) => (t -> [t]) -> Pocket t -> t -> Bool
stepPosition neighbors (Pocket actives) position
  | isActive = activeNeighbors == 2 || activeNeighbors == 3
  | otherwise = activeNeighbors == 3
  where
    isActive = position `member` actives
    activeNeighbors = length $ filter (`member` actives) $ neighbors position

neighborsOf :: Cube -> [Cube]
neighborsOf (x, y, z) =
  List.delete
    (x, y, z)
    [ (x + dx, y + dy, z + dz)
      | dx <- [-1, 0, 1],
        dy <- [-1, 0, 1],
        dz <- [-1, 0, 1]
    ]

hyperNeighborsOf :: Hypercube -> [Hypercube]
hyperNeighborsOf (x, y, z, w) =
  List.delete
    (x, y, z, w)
    [ (x + dx, y + dy, z + dz, w + dw)
      | dx <- [-1, 0, 1],
        dy <- [-1, 0, 1],
        dz <- [-1, 0, 1],
        dw <- [-1, 0, 1]
    ]

step :: Pocket Cube -> Pocket Cube
step = step_ neighborsOf

step' :: Pocket Hypercube -> Pocket Hypercube
step' = step_ hyperNeighborsOf

stepN_ :: (Pocket t -> Pocket t) -> Int -> Pocket t -> Pocket t
stepN_ stepper n = head . unsafeNonEmpty . drop n . iterate stepper

stepN :: Int -> Pocket Cube -> Pocket Cube
stepN = stepN_ step

stepN' :: Int -> Pocket Hypercube -> Pocket Hypercube
stepN' = stepN_ step'
