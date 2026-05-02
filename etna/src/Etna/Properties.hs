module Etna.Properties where

import qualified Data.List as List
import qualified Data.Maybe as Maybe
import qualified Data.PQueue.Min as Min
import qualified Data.PQueue.Prio.Min as PMin

import Etna.Result

------------------------------------------------------------------------------
-- Variant 1: mapmaybe_buggy_8fd23ba6_1
-- "Fix mapMaybe and mapEither (#111)"
------------------------------------------------------------------------------

-- | Args: a list of Ints.  The property applies a fixed non-monotonic
-- transform @f x = if odd x then Just (negate x) else Nothing@ to
-- @Min.fromList xs@ via 'Min.mapMaybe' and checks that the resulting
-- queue's ascending toList equals the sorted list of @Maybe.mapMaybe f xs@.
--
-- The buggy 'Min.mapMaybe' (Issue #110) only worked for monotonic
-- transforms.  For inputs whose @f@-image is not monotonic in the
-- traversal order, the resulting heap loses elements or returns them in
-- a permutation rather than ascending order, so 'Min.toAscList' diverges
-- from the sorted @mapMaybe@ on the underlying list.
newtype MapMaybeArgs = MapMaybeArgs { mapMaybeXs :: [Int] }
  deriving (Show, Eq)

mapMaybeFn :: Int -> Maybe Int
mapMaybeFn x
  | odd x     = Just (negate x)
  | otherwise = Nothing

property_map_maybe_min_matches_list :: MapMaybeArgs -> PropertyResult
property_map_maybe_min_matches_list (MapMaybeArgs xs) =
  let q  = Min.fromList xs
      qm = Min.mapMaybe mapMaybeFn q
      got      = Min.toAscList qm
      expected = List.sort (Maybe.mapMaybe mapMaybeFn xs)
  in if got == expected
       then Pass
       else Fail $
         "Min.mapMaybe " ++ show xs ++ ": got " ++ show got
         ++ ", expected " ++ show expected

------------------------------------------------------------------------------
-- Variant 2: mapeither_buggy_8fd23ba6_2
-- "Fix mapMaybe and mapEither (#111)" — separation case
------------------------------------------------------------------------------

-- | Same fix commit as variant 1, but exercises 'Min.mapEither' (which
-- splits via 'Either') with a non-monotonic separator.  The buggy
-- implementation routed elements through the wrong sub-queue or lost
-- the heap order when the transform was non-monotonic.
newtype MapEitherArgs = MapEitherArgs { mapEitherXs :: [Int] }
  deriving (Show, Eq)

mapEitherFn :: Int -> Either Int Int
mapEitherFn x
  | x `mod` 3 == 0 = Left  (negate x)
  | otherwise      = Right (negate x)

property_map_either_min_partitions :: MapEitherArgs -> PropertyResult
property_map_either_min_partitions (MapEitherArgs xs) =
  let q          = Min.fromList xs
      (ql, qr)   = Min.mapEither mapEitherFn q
      gotL       = Min.toAscList ql
      gotR       = Min.toAscList qr
      (expL, expR) = ( List.sort [ y | Left  y <- map mapEitherFn xs ]
                     , List.sort [ z | Right z <- map mapEitherFn xs ]
                     )
  in if gotL == expL && gotR == expR
       then Pass
       else Fail $
         "Min.mapEither " ++ show xs ++ ": got " ++ show (gotL, gotR)
         ++ ", expected " ++ show (expL, expR)

------------------------------------------------------------------------------
-- Variant 3: prio_map_maybe_with_key_buggy_8fd23ba6_3
-- "Fix mapMaybe and mapEither (#111)" — prio variant
------------------------------------------------------------------------------

-- | Args: a list of (key, value) pairs.  The property applies a fixed
-- non-monotonic transform on keys via 'PMin.mapMaybeWithKey' and checks
-- that the resulting prio-queue's toAscList equals the sorted list of
-- the same transform applied to the input pairs.
newtype PrioMapMaybeArgs = PrioMapMaybeArgs { prioMapMaybeXs :: [(Int, Int)] }
  deriving (Show, Eq)

prioMapMaybeFn :: Int -> Int -> Maybe Int
prioMapMaybeFn k _v
  | odd k     = Just (negate k)
  | otherwise = Nothing

property_prio_map_maybe_with_key :: PrioMapMaybeArgs -> PropertyResult
property_prio_map_maybe_with_key (PrioMapMaybeArgs kvs) =
  let q   = PMin.fromList kvs
      qm  = PMin.mapMaybeWithKey prioMapMaybeFn q
      got = PMin.toAscList qm
      expected =
        List.sort
          [ (k, v')
          | (k, v) <- kvs
          , Just v' <- [prioMapMaybeFn k v]
          ]
  in if got == expected
       then Pass
       else Fail $
         "PMin.mapMaybeWithKey " ++ show kvs ++ ": got " ++ show got
         ++ ", expected " ++ show expected
