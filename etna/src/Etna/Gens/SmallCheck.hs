{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Etna.Gens.SmallCheck where

import qualified Test.SmallCheck.Series as SC

import Etna.Properties (MapMaybeArgs(..), MapEitherArgs(..), PrioMapMaybeArgs(..))

-- SmallCheck enumerates by depth.  The bug shows up on small lists with
-- mixed odd/even values, so we keep the search space tight: lists up
-- to length depth, elements drawn from a small pool that contains
-- both odd and even, positive and negative integers.
intPool :: [Int]
intPool = [-3, -2, -1, 0, 1, 2, 3]

series_list_int :: Monad m => SC.Series m [Int]
series_list_int = do
  n <- SC.generate (\d -> [0 .. min d 5])
  replicateA n (SC.generate (\_ -> intPool))
  where
    replicateA :: Applicative f => Int -> f a -> f [a]
    replicateA 0 _ = pure []
    replicateA k f = (:) <$> f <*> replicateA (k - 1) f

series_map_maybe_min_matches_list :: Monad m => SC.Series m MapMaybeArgs
series_map_maybe_min_matches_list = MapMaybeArgs <$> series_list_int

series_map_either_min_partitions :: Monad m => SC.Series m MapEitherArgs
series_map_either_min_partitions = MapEitherArgs <$> series_list_int

series_prio_map_maybe_with_key :: Monad m => SC.Series m PrioMapMaybeArgs
series_prio_map_maybe_with_key = do
  n <- SC.generate (\d -> [0 .. min d 4])
  kvs <- replicateA n $ do
    k <- SC.generate (\_ -> intPool)
    v <- SC.generate (\_ -> intPool)
    pure (k, v)
  pure (PrioMapMaybeArgs kvs)
  where
    replicateA :: Applicative f => Int -> f a -> f [a]
    replicateA 0 _ = pure []
    replicateA k f = (:) <$> f <*> replicateA (k - 1) f
