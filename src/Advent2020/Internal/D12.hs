module Advent2020.Internal.D12
  ( Instruction (..),
    Action (..),
    Orientation (..),
    Direction (..),
    parse,
    Ship (..),
    initial,
    step,
    Navigation (..),
    initial',
    step',
  )
where

import Advent2020.Internal (Parser, Position, integralP, parseWithPrettyErrors)
import Relude
import Text.Megaparsec (eof, sepEndBy1)
import Text.Megaparsec.Char (char, newline)

data Instruction = Instruction
  { action :: Action,
    value :: Int
  }
  deriving (Show, Eq)

data Action
  = Move Orientation
  | Turn Direction
  | Forward
  deriving (Show, Eq)

data Orientation
  = North
  | South
  | East
  | West
  deriving (Show, Eq)

data Direction
  = DLeft
  | DRight
  deriving (Show, Eq)

parse :: Text -> Either Text [Instruction]
parse = parseWithPrettyErrors $ (moveP <|> turnP) `sepEndBy1` newline <* eof
  where
    moveP :: Parser Instruction
    moveP = do
      action <-
        (Move North <$ char 'N')
          <|> (Move South <$ char 'S')
          <|> (Move East <$ char 'E')
          <|> (Move West <$ char 'W')
          <|> (Forward <$ char 'F')
      value <- integralP
      return Instruction {..}
    turnP :: Parser Instruction
    turnP = do
      action <- (Turn DLeft <$ char 'L') <|> (Turn DRight <$ char 'R')
      value <- integralP
      return Instruction {..}

data Ship = Ship
  { orientation :: Orientation,
    position :: Position
  }
  deriving (Show, Eq)

initial :: Ship
initial = Ship {orientation = East, position = (0, 0)}

step :: Ship -> Instruction -> Ship
step s@Ship {position = (x, y), ..} Instruction {..} = case action of
  Move o -> s {position = move o value}
  Turn dir -> s {orientation = turn dir value orientation}
  Forward -> s {position = move orientation value}
  where
    move :: Orientation -> Int -> Position
    move North v = (x, y + v)
    move South v = (x, y - v)
    move East v = (x + v, y)
    move West v = (x - v, y)

    turn :: Direction -> Int -> Orientation -> Orientation
    turn DRight degrees o = turn DLeft (360 - degrees) o
    turn DLeft degrees o = if degrees == 90 then o' else turn DLeft (degrees - 90) o'
      where
        o' = case o of
          North -> West
          South -> East
          East -> North
          West -> South

data Navigation = Navigation
  { ship :: Position,
    waypoint :: Position
  }
  deriving (Show, Eq)

initial' :: Navigation
initial' = Navigation {ship = (0, 0), waypoint = (10, 1)}

step' :: Navigation -> Instruction -> Navigation
step' n@Navigation {ship = (x, y), waypoint = (wx, wy)} Instruction {..} = case action of
  Move o -> n {waypoint = moveWaypoint o value}
  Turn dir -> n {waypoint = rotateWaypoint dir value}
  Forward -> n {ship = moveShip value}
  where
    moveWaypoint :: Orientation -> Int -> Position
    moveWaypoint North v = (wx, wy + v)
    moveWaypoint South v = (wx, wy - v)
    moveWaypoint East v = (wx + v, wy)
    moveWaypoint West v = (wx - v, wy)

    rotateWaypoint :: Direction -> Int -> Position
    rotateWaypoint DRight degrees = rotateWaypoint DLeft $ 360 - degrees
    rotateWaypoint DLeft degrees = case degrees of
      90 -> (- wy, wx)
      180 -> (- wx, - wy)
      270 -> (wy, - wx)
      _ -> error $ "rotateWaypoint: impossible: invalid degrees" <> show degrees

    moveShip :: Int -> Position
    moveShip times = (x + times * wx, y + times * wy)
