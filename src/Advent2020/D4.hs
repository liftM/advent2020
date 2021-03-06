{-# LANGUAGE RankNTypes #-}

module Advent2020.D4 (run, part1, part2) where

import Advent2020.Internal (label)
import Advent2020.Internal.D4 (Passport (..), parse)
import Relude

run :: (Passport -> Bool) -> Text -> Either Text Int
run runner contents = label "parsing passports" (parse contents) <&> length . filter runner

checkPassport :: (forall a. Maybe (Either Text a) -> Bool) -> Passport -> Bool
checkPassport f Passport {..} =
  f birthYear
    && f issueYear
    && f expirationYear
    && f height
    && f hairColor
    && f eyeColor
    && f passportID

part1 :: Passport -> Bool
part1 = checkPassport isJust

part2 :: Passport -> Bool
part2 = checkPassport isOK
  where
    isOK (Just (Right _)) = True
    isOK _ = False
