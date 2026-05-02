module Etna.Witnesses where

import Etna.Properties
import Etna.Result

-- Variant 1: Min.mapMaybe with non-monotonic Just/Nothing pattern.
witness_map_maybe_min_matches_list_case_neg_odds :: PropertyResult
witness_map_maybe_min_matches_list_case_neg_odds =
  property_map_maybe_min_matches_list (MapMaybeArgs [3, 1, 2, 5, 4, 7, 6, 8, 9])

witness_map_maybe_min_matches_list_case_powers_of_two :: PropertyResult
witness_map_maybe_min_matches_list_case_powers_of_two =
  property_map_maybe_min_matches_list (MapMaybeArgs [1, 2, 4, 8, 16, 3, 7, 15, 31])

-- Variant 2: Min.mapEither with non-monotonic Left/Right separator.
witness_map_either_min_partitions_case_mod3 :: PropertyResult
witness_map_either_min_partitions_case_mod3 =
  property_map_either_min_partitions (MapEitherArgs [9, 1, 6, 4, 3, 2, 12, 7, 0])

witness_map_either_min_partitions_case_dense :: PropertyResult
witness_map_either_min_partitions_case_dense =
  property_map_either_min_partitions (MapEitherArgs [1, 3, 2, 6, 5, 9, 4, 12, 11])

-- Variant 3: PMin.mapMaybeWithKey
witness_prio_map_maybe_with_key_case_descending_keys :: PropertyResult
witness_prio_map_maybe_with_key_case_descending_keys =
  property_prio_map_maybe_with_key
    (PrioMapMaybeArgs [(9, 0), (7, 1), (5, 2), (3, 3), (1, 4), (8, 5), (4, 6)])

witness_prio_map_maybe_with_key_case_runs :: PropertyResult
witness_prio_map_maybe_with_key_case_runs =
  property_prio_map_maybe_with_key
    (PrioMapMaybeArgs [(1, 10), (2, 20), (3, 30), (4, 40), (5, 50), (8, 80), (7, 70)])
