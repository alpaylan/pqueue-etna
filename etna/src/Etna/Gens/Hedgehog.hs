module Etna.Gens.Hedgehog where

import           Hedgehog (Gen)
import qualified Hedgehog.Gen as Gen
import qualified Hedgehog.Range as Range

import Etna.Properties (MapMaybeArgs(..), MapEitherArgs(..), PrioMapMaybeArgs(..))

gen_map_maybe_min_matches_list :: Gen MapMaybeArgs
gen_map_maybe_min_matches_list = do
  xs <- Gen.list (Range.linear 0 50) (Gen.int (Range.linearFrom 0 (-100) 100))
  pure (MapMaybeArgs xs)

gen_map_either_min_partitions :: Gen MapEitherArgs
gen_map_either_min_partitions = do
  xs <- Gen.list (Range.linear 0 50) (Gen.int (Range.linearFrom 0 (-100) 100))
  pure (MapEitherArgs xs)

gen_prio_map_maybe_with_key :: Gen PrioMapMaybeArgs
gen_prio_map_maybe_with_key = do
  let intGen = Gen.int (Range.linearFrom 0 (-100) 100)
  kvs <- Gen.list (Range.linear 0 50) $ do
    k <- intGen
    v <- intGen
    pure (k, v)
  pure (PrioMapMaybeArgs kvs)
