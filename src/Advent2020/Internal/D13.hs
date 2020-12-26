module Advent2020.Internal.D13
  ( Schedule (..),
    parse,
    earliestBusAfter,
    chinese',
  )
where

import Advent2020.Internal (parseWith, parseWithPrettyErrors, readInt)
import Math.NumberTheory.Moduli.Chinese (chinese)
import Relude
import qualified Relude.Unsafe as Unsafe
import Text.Megaparsec (eof, someTill)
import Text.Megaparsec.Char (char, digitChar, newline)

data Schedule = Schedule
  { earliestDeparture :: Int,
    buses :: [Maybe Int]
  }
  deriving (Show, Eq)

parse :: Text -> Either Text Schedule
parse = parseWithPrettyErrors $ do
  earliestDeparture <- parseWith readInt $ digitChar `someTill` newline
  buses <- ((Just <$> parseWith readInt (digitChar `someTill` separator)) <|> (char 'x' >> separator >> return Nothing)) `someTill` eof
  return Schedule {..}
  where
    separator = char ',' <|> newline

earliestBusAfter :: Int -> NonEmpty Int -> (Int, Int)
earliestBusAfter ready buses = foldr (min' snd) (head firstDepartureAfter) firstDepartureAfter
  where
    min' :: (Ord b) => (a -> b) -> a -> a -> a
    min' f a b = if f a < f b then a else b

    busDepartures :: NonEmpty (Int, [Int])
    busDepartures = (\busID -> (busID, iterate (+ busID) 0)) <$> buses

    firstDepartureAfter :: NonEmpty (Int, Int)
    firstDepartureAfter = second (Unsafe.fromJust . find (> ready)) <$> busDepartures

chinese' :: NonEmpty (Integer, Integer) -> Maybe (Integer, Integer)
chinese' ((n, m) :| []) = Just (n, m)
chinese' (x :| xt) = foldlM f x xt
  where
    f (nAcc, mAcc) (n, m) = do
      n' <- chinese (nAcc, mAcc) (n, m)
      return (n', mAcc * m)
