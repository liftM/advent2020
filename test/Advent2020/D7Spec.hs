module Advent2020.D7Spec (spec) where

import Advent2020.D7 (part1, part2)
import Advent2020.Internal.D7 (Rule (..), parse)
import Advent2020.Spec.Internal (shouldBe')
import Relude
import Test.Hspec (Spec, it)

exampleInput :: Text
exampleInput =
  unlines
    [ "light red bags contain 1 bright white bag, 2 muted yellow bags.",
      "dark orange bags contain 3 bright white bags, 4 muted yellow bags.",
      "bright white bags contain 1 shiny gold bag.",
      "muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.",
      "shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.",
      "dark olive bags contain 3 faded blue bags, 4 dotted black bags.",
      "vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.",
      "faded blue bags contain no other bags.",
      "dotted black bags contain no other bags."
    ]

exampleRules :: [Rule]
exampleRules =
  [ Rule {color = "light red", contains = fromList [("bright white", 1), ("muted yellow", 2)]},
    Rule {color = "dark orange", contains = fromList [("bright white", 3), ("muted yellow", 4)]},
    Rule {color = "bright white", contains = fromList [("shiny gold", 1)]},
    Rule {color = "muted yellow", contains = fromList [("faded blue", 9), ("shiny gold", 2)]},
    Rule {color = "shiny gold", contains = fromList [("dark olive", 1), ("vibrant plum", 2)]},
    Rule {color = "dark olive", contains = fromList [("dotted black", 4), ("faded blue", 3)]},
    Rule {color = "vibrant plum", contains = fromList [("dotted black", 6), ("faded blue", 5)]},
    Rule {color = "faded blue", contains = fromList []},
    Rule {color = "dotted black", contains = fromList []}
  ]

exampleInput2 :: Text
exampleInput2 =
  unlines
    [ "shiny gold bags contain 2 dark red bags.",
      "dark red bags contain 2 dark orange bags.",
      "dark orange bags contain 2 dark yellow bags.",
      "dark yellow bags contain 2 dark green bags.",
      "dark green bags contain 2 dark blue bags.",
      "dark blue bags contain 2 dark violet bags.",
      "dark violet bags contain no other bags."
    ]

exampleRules2 :: [Rule]
exampleRules2 =
  [ Rule {color = "shiny gold", contains = fromList [("dark red", 2)]},
    Rule {color = "dark red", contains = fromList [("dark orange", 2)]},
    Rule {color = "dark orange", contains = fromList [("dark yellow", 2)]},
    Rule {color = "dark yellow", contains = fromList [("dark green", 2)]},
    Rule {color = "dark green", contains = fromList [("dark blue", 2)]},
    Rule {color = "dark blue", contains = fromList [("dark violet", 2)]},
    Rule {color = "dark violet", contains = fromList []}
  ]

spec :: Spec
spec = do
  it "parses bag rules" $ do
    parse exampleInput `shouldBe'` exampleRules
    parse exampleInput2 `shouldBe'` exampleRules2

  it "computes bags that can hold shiny gold bag" $ do
    part1 exampleRules `shouldBe'` 4

  it "computes bags that held within a shiny gold bag" $ do
    part2 exampleRules `shouldBe'` 32
    part2 exampleRules2 `shouldBe'` 126
