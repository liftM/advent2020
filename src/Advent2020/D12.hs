module Advent2020.D12 (run, part1, part2) where

import Advent2020.Internal (simpleRun')
import Advent2020.Internal.D12 (Instruction, Navigation (..), Ship (..), initial, initial', parse, step, step')
import Relude

run :: ([Instruction] -> Int) -> Text -> Either Text Int
run = simpleRun' parse return

part1 :: [Instruction] -> Int
part1 instructions = let Ship {position = (x, y)} = foldl' step initial instructions in abs x + abs y

part2 :: [Instruction] -> Int
part2 instructions = let Navigation {ship = (x, y)} = foldl' step' initial' instructions in abs x + abs y
