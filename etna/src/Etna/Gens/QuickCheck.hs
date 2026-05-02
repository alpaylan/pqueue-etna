module Etna.Gens.QuickCheck where

import qualified Test.QuickCheck as QC

import Etna.Properties (MapMaybeArgs(..), MapEitherArgs(..), PrioMapMaybeArgs(..))

gen_map_maybe_min_matches_list :: QC.Gen MapMaybeArgs
gen_map_maybe_min_matches_list = do
  n <- QC.choose (0, 50)
  xs <- QC.vectorOf n (QC.choose (-100, 100))
  pure (MapMaybeArgs xs)

gen_map_either_min_partitions :: QC.Gen MapEitherArgs
gen_map_either_min_partitions = do
  n <- QC.choose (0, 50)
  xs <- QC.vectorOf n (QC.choose (-100, 100))
  pure (MapEitherArgs xs)

gen_prio_map_maybe_with_key :: QC.Gen PrioMapMaybeArgs
gen_prio_map_maybe_with_key = do
  n <- QC.choose (0, 50)
  kvs <- QC.vectorOf n $ do
    k <- QC.choose (-100, 100)
    v <- QC.choose (-100, 100)
    pure (k, v)
  pure (PrioMapMaybeArgs kvs)
