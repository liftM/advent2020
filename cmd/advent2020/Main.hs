module Main (main) where

import qualified Advent2020.D1 as D1
import qualified Advent2020.D10 as D10
import qualified Advent2020.D11 as D11
import qualified Advent2020.D12 as D12
import qualified Advent2020.D13 as D13
import qualified Advent2020.D14 as D14
import qualified Advent2020.D15 as D15
import qualified Advent2020.D16 as D16
import qualified Advent2020.D17 as D17
import qualified Advent2020.D18 as D18
import qualified Advent2020.D19 as D19
import qualified Advent2020.D2 as D2
import qualified Advent2020.D20 as D20
import qualified Advent2020.D22 as D22
import qualified Advent2020.D23 as D23
import qualified Advent2020.D3 as D3
import qualified Advent2020.D4 as D4
import qualified Advent2020.D5 as D5
import qualified Advent2020.D6 as D6
import qualified Advent2020.D7 as D7
import qualified Advent2020.D8 as D8
import qualified Advent2020.D9 as D9
import Options.Applicative (ParserInfo, auto, briefDesc, execParser, helper, info, long, option, progDesc, strOption)
import Relude

data Options = Options
  { day :: Int,
    part :: Int,
    inputFilepath :: FilePath
  }
  deriving (Show)

opts :: ParserInfo Options
opts =
  info
    (options <**> helper)
    (briefDesc <> progDesc "Advent 2020 solutions")
  where
    options =
      Options
        <$> option auto (long "day")
        <*> option auto (long "part")
        <*> strOption (long "input_file")

main :: IO ()
main = do
  Options {day, part, inputFilepath} <- execParser opts
  contents <- readFileText inputFilepath
  runnerFor day part contents
  where
    runnerFor :: Int -> Int -> (Text -> IO ())
    runnerFor day part = case day of
      1 -> case part of
        1 -> runEitherPretty $ D1.run D1.part1
        2 -> runEitherPretty $ D1.run D1.part2
        _ -> catchAll
      2 -> case part of
        1 -> runEitherPretty $ D2.run D2.part1
        2 -> runEitherPretty $ D2.run D2.part2
        _ -> catchAll
      3 -> case part of
        1 -> runEitherPretty $ D3.run D3.part1
        2 -> runEitherPretty $ D3.run D3.part2
        _ -> catchAll
      4 -> case part of
        1 -> runEitherPretty $ D4.run D4.part1
        2 -> runEitherPretty $ D4.run D4.part2
        _ -> catchAll
      5 -> case part of
        1 -> runEitherPretty $ D5.run D5.part1
        2 -> runEitherPretty $ D5.run D5.part2
        _ -> catchAll
      6 -> case part of
        1 -> runEitherPretty $ D6.run D6.part1
        2 -> runEitherPretty $ D6.run D6.part2
        _ -> catchAll
      7 -> case part of
        1 -> runEitherPretty $ D7.run D7.part1
        2 -> runEitherPretty $ D7.run D7.part2
        _ -> catchAll
      8 -> case part of
        1 -> runEitherPretty $ D8.run D8.part1
        2 -> runEitherPretty $ D8.run D8.part2
        _ -> catchAll
      9 -> case part of
        1 -> runEitherPretty $ D9.run D9.part1
        2 -> runEitherPretty $ D9.run D9.part2
        _ -> catchAll
      10 -> case part of
        1 -> runEitherPretty $ D10.run D10.part1
        2 -> runEitherPretty $ D10.run D10.part2
        _ -> catchAll
      11 -> case part of
        1 -> runEitherPretty $ D11.run D11.part1
        2 -> runEitherPretty $ D11.run D11.part2
        _ -> catchAll
      12 -> case part of
        1 -> runEitherPretty $ D12.run D12.part1
        2 -> runEitherPretty $ D12.run D12.part2
        _ -> catchAll
      13 -> case part of
        1 -> runEitherPretty $ D13.run D13.part1
        2 -> runEitherPretty $ D13.run D13.part2
        _ -> catchAll
      14 -> case part of
        1 -> runEitherPretty $ D14.run D14.part1
        2 -> runEitherPretty $ D14.run D14.part2
        _ -> catchAll
      15 -> case part of
        1 -> runEitherPretty $ D15.run D15.part1
        2 -> runEitherPretty $ D15.run D15.part2
        _ -> catchAll
      16 -> case part of
        1 -> runEitherPretty $ D16.run D16.part1
        2 -> runEitherPretty $ D16.run D16.part2
        _ -> catchAll
      17 -> case part of
        1 -> runEitherPretty $ D17.run D17.part1
        2 -> runEitherPretty $ D17.run D17.part2
        _ -> catchAll
      18 -> case part of
        1 -> runEitherPretty $ D18.run D18.part1
        2 -> runEitherPretty $ D18.run D18.part2
        _ -> catchAll
      19 -> case part of
        1 -> runEitherPretty $ D19.run D19.part1
        2 -> runEitherPretty $ D19.run D19.part2
        _ -> catchAll
      20 -> case part of
        1 -> runEitherPretty $ D20.run D20.part1
        -- 2 -> runEitherPretty $ D20.run D20.part2
        _ -> catchAll
      22 -> case part of
        1 -> runEitherPretty $ D22.run D22.part1
        2 -> runEitherPretty $ D22.run D22.part2
        _ -> catchAll
      23 -> case part of
        1 -> runEitherPretty $ D23.run D23.part1
        -- 2 -> runEitherPretty $ D23.run D23.part2
        _ -> catchAll
      _ -> catchAll

runEitherPretty :: (Show t) => (Text -> Either Text t) -> Text -> IO ()
runEitherPretty = runEitherPrettyT show

_runEitherPretty :: (Text -> Either Text Text) -> Text -> IO ()
_runEitherPretty = runEitherPrettyT id

runEitherPrettyT :: (t -> Text) -> (Text -> Either Text t) -> Text -> IO ()
runEitherPrettyT f run contents = putTextLn $ case run contents of
  Right r -> "OK: " <> f r
  Left err -> "ERROR: " <> err

catchAll :: a -> IO ()
catchAll _ = do
  putTextLn "ERROR: invalid puzzle or part"
  exitFailure
