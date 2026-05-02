module Main where

import Etna.Result (PropertyResult(..))
import Etna.Witnesses
  ( witness_map_maybe_min_matches_list_case_neg_odds
  , witness_map_maybe_min_matches_list_case_powers_of_two
  , witness_map_either_min_partitions_case_mod3
  , witness_map_either_min_partitions_case_dense
  , witness_prio_map_maybe_with_key_case_descending_keys
  , witness_prio_map_maybe_with_key_case_runs
  )
import System.Exit (exitFailure, exitSuccess)

cases :: [(String, PropertyResult)]
cases =
  [ ("witness_map_maybe_min_matches_list_case_neg_odds",       witness_map_maybe_min_matches_list_case_neg_odds)
  , ("witness_map_maybe_min_matches_list_case_powers_of_two",  witness_map_maybe_min_matches_list_case_powers_of_two)
  , ("witness_map_either_min_partitions_case_mod3",            witness_map_either_min_partitions_case_mod3)
  , ("witness_map_either_min_partitions_case_dense",           witness_map_either_min_partitions_case_dense)
  , ("witness_prio_map_maybe_with_key_case_descending_keys",     witness_prio_map_maybe_with_key_case_descending_keys)
  , ("witness_prio_map_maybe_with_key_case_runs",                witness_prio_map_maybe_with_key_case_runs)
  ]

main :: IO ()
main = do
  let failures =
        [ (n, msg) | (n, Fail msg) <- cases ] ++
        [ (n, "discard") | (n, Discard) <- cases ]
  if null failures
    then do
      putStrLn $ "OK: all " ++ show (length cases) ++ " witnesses passed"
      exitSuccess
    else do
      mapM_ (\(n, m) -> putStrLn (n ++ ": FAIL: " ++ m)) failures
      exitFailure
