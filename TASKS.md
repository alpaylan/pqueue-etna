# pqueue — ETNA Tasks

Total tasks: 12

## Task Index

| Task | Variant | Framework | Property | Witness |
|------|---------|-----------|----------|---------|
| 001 | `mapmaybe_buggy_8fd23ba6_1` | quickcheck | `MapMaybeMinMatchesList` | `witness_map_maybe_min_matches_list_case_neg_odds` |
| 002 | `mapmaybe_buggy_8fd23ba6_1` | hedgehog | `MapMaybeMinMatchesList` | `witness_map_maybe_min_matches_list_case_neg_odds` |
| 003 | `mapmaybe_buggy_8fd23ba6_1` | falsify | `MapMaybeMinMatchesList` | `witness_map_maybe_min_matches_list_case_neg_odds` |
| 004 | `mapmaybe_buggy_8fd23ba6_1` | smallcheck | `MapMaybeMinMatchesList` | `witness_map_maybe_min_matches_list_case_neg_odds` |
| 005 | `mapmaybe_buggy_8fd23ba6_1` | quickcheck | `MapEitherMinPartitions` | `witness_map_either_min_partitions_case_mod3` |
| 006 | `mapmaybe_buggy_8fd23ba6_1` | hedgehog | `MapEitherMinPartitions` | `witness_map_either_min_partitions_case_mod3` |
| 007 | `mapmaybe_buggy_8fd23ba6_1` | falsify | `MapEitherMinPartitions` | `witness_map_either_min_partitions_case_mod3` |
| 008 | `mapmaybe_buggy_8fd23ba6_1` | smallcheck | `MapEitherMinPartitions` | `witness_map_either_min_partitions_case_mod3` |
| 009 | `mapmaybe_buggy_8fd23ba6_1` | quickcheck | `PrioMapMaybeWithKey` | `witness_prio_map_maybe_with_key_case_descending_keys` |
| 010 | `mapmaybe_buggy_8fd23ba6_1` | hedgehog | `PrioMapMaybeWithKey` | `witness_prio_map_maybe_with_key_case_descending_keys` |
| 011 | `mapmaybe_buggy_8fd23ba6_1` | falsify | `PrioMapMaybeWithKey` | `witness_prio_map_maybe_with_key_case_descending_keys` |
| 012 | `mapmaybe_buggy_8fd23ba6_1` | smallcheck | `PrioMapMaybeWithKey` | `witness_prio_map_maybe_with_key_case_descending_keys` |

## Witness Catalog

- `witness_map_maybe_min_matches_list_case_neg_odds` — Min.mapMaybe (negate-odd, drop-even) on [3,1,2,5,4,7,6,8,9] must equal sort [-3,-1,-5,-7,-9].
- `witness_map_maybe_min_matches_list_case_powers_of_two` — Min.mapMaybe (negate-odd, drop-even) on [1,2,4,8,16,3,7,15,31] must equal sort [-1,-3,-7,-15,-31].
- `witness_map_either_min_partitions_case_mod3` — Min.mapEither (Left if mod 3==0 else Right, all negated) on [9,1,6,4,3,2,12,7,0] must split into two sorted queues.
- `witness_map_either_min_partitions_case_dense` — Min.mapEither on [1,3,2,6,5,9,4,12,11] must split into two sorted queues.
- `witness_prio_map_maybe_with_key_case_descending_keys` — PMin.mapMaybeWithKey (drop even keys, negate odd) on key-descending input [(9,0),(7,1),(5,2),(3,3),(1,4),(8,5),(4,6)] must return sorted-by-key pairs.
- `witness_prio_map_maybe_with_key_case_runs` — PMin.mapMaybeWithKey on [(1,10),(2,20),(3,30),(4,40),(5,50),(8,80),(7,70)] must return sorted-by-key pairs.
