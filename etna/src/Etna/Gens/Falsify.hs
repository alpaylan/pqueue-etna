module Etna.Gens.Falsify where

import qualified Test.Falsify.Generator as F
import qualified Test.Falsify.Range as FR

import Etna.Properties (MapMaybeArgs(..), MapEitherArgs(..), PrioMapMaybeArgs(..))

gen_int :: F.Gen Int
gen_int = fromIntegral <$> F.inRange (FR.between (-100 :: Int, 100))

gen_map_maybe_min_matches_list :: F.Gen MapMaybeArgs
gen_map_maybe_min_matches_list = do
  xs <- F.list (FR.between (0 :: Word, 50)) gen_int
  pure (MapMaybeArgs xs)

gen_map_either_min_partitions :: F.Gen MapEitherArgs
gen_map_either_min_partitions = do
  xs <- F.list (FR.between (0 :: Word, 50)) gen_int
  pure (MapEitherArgs xs)

gen_prio_map_maybe_with_key :: F.Gen PrioMapMaybeArgs
gen_prio_map_maybe_with_key = do
  kvs <- F.list (FR.between (0 :: Word, 50)) $ do
    k <- gen_int
    v <- gen_int
    pure (k, v)
  pure (PrioMapMaybeArgs kvs)
