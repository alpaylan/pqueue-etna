# pqueue — Injected Bugs

Reliable, persistent, fast priority queues based on a binomial heap (lspitzner/pqueue). Bug fixes mined from upstream history; modern HEAD is the base, each patch reverse-applies a fix to install the original bug.

Total mutations: 1

## Bug Index

| # | Variant | Name | Location | Injection | Fix Commit |
|---|---------|------|----------|-----------|------------|
| 1 | `mapmaybe_buggy_8fd23ba6_1` | `mapmaybe_breaks_heap_invariant` | `src/Data/PQueue/Internals.hs:182` | `patch` | `8fd23ba629b226bbb08c0799b5279a9c9ef3dfa1` |

## Property Mapping

| Variant | Property | Witness(es) |
|---------|----------|-------------|
| `mapmaybe_buggy_8fd23ba6_1` | `MapMaybeMinMatchesList` | `witness_map_maybe_min_matches_list_case_neg_odds`, `witness_map_maybe_min_matches_list_case_powers_of_two` |
| `mapmaybe_buggy_8fd23ba6_1` | `MapEitherMinPartitions` | `witness_map_either_min_partitions_case_mod3`, `witness_map_either_min_partitions_case_dense` |
| `mapmaybe_buggy_8fd23ba6_1` | `PrioMapMaybeWithKey` | `witness_prio_map_maybe_with_key_case_descending_keys`, `witness_prio_map_maybe_with_key_case_runs` |

## Framework Coverage

| Property | quickcheck | hedgehog | falsify | smallcheck |
|----------|---------:|-------:|------:|---------:|
| `MapMaybeMinMatchesList` | ✓ | ✓ | ✓ | ✓ |
| `MapEitherMinPartitions` | ✓ | ✓ | ✓ | ✓ |
| `PrioMapMaybeWithKey` | ✓ | ✓ | ✓ | ✓ |

## Bug Details

### 1. mapmaybe_breaks_heap_invariant

- **Variant**: `mapmaybe_buggy_8fd23ba6_1`
- **Location**: `src/Data/PQueue/Internals.hs:182` (inside `mapMaybe`)
- **Property**: `MapMaybeMinMatchesList`, `MapEitherMinPartitions`, `PrioMapMaybeWithKey`
- **Witness(es)**:
  - `witness_map_maybe_min_matches_list_case_neg_odds` — Min.mapMaybe (negate-odd, drop-even) on [3,1,2,5,4,7,6,8,9] must equal sort [-3,-1,-5,-7,-9].
  - `witness_map_maybe_min_matches_list_case_powers_of_two` — Min.mapMaybe (negate-odd, drop-even) on [1,2,4,8,16,3,7,15,31] must equal sort [-1,-3,-7,-15,-31].
  - `witness_map_either_min_partitions_case_mod3` — Min.mapEither (Left if mod 3==0 else Right, all negated) on [9,1,6,4,3,2,12,7,0] must split into two sorted queues.
  - `witness_map_either_min_partitions_case_dense` — Min.mapEither on [1,3,2,6,5,9,4,12,11] must split into two sorted queues.
  - `witness_prio_map_maybe_with_key_case_descending_keys` — PMin.mapMaybeWithKey (drop even keys, negate odd) on key-descending input [(9,0),(7,1),(5,2),(3,3),(1,4),(8,5),(4,6)] must return sorted-by-key pairs.
  - `witness_prio_map_maybe_with_key_case_runs` — PMin.mapMaybeWithKey on [(1,10),(2,20),(3,30),(4,40),(5,50),(8,80),(7,70)] must return sorted-by-key pairs.
- **Source**: internal — Fix mapMaybe and mapEither (#111)
  > Min.mapMaybe / Min.mapEither / PMin.mapMaybeWithKey re-fed their result through fromAscList from heap-order-traversal output. For non-monotonic transforms this violates fromAscList's precondition and produces a queue whose toAscList is no longer sorted.
- **Fix commit**: `8fd23ba629b226bbb08c0799b5279a9c9ef3dfa1` — Fix mapMaybe and mapEither (#111)
- **Invariant violated**: For any list xs and Maybe-returning transform f, Min.toAscList (Min.mapMaybe f (Min.fromList xs)) equals List.sort [y | x <- xs, Just y <- [f x]]. Analogous statements hold for Min.mapEither and PMin.mapMaybeWithKey.
- **How the mutation triggers**: Reverse-applying the patch swaps the BinomialQueue.insertEager-driven implementations of mapMaybe / mapEither / mapMaybeWithKey for naive `fromAscList . filter . toListU` versions. For any non-monotonic transform on a queue with at least two elements that survive the filter, the result heap's order invariant is broken and toAscList returns the elements in heap order rather than sorted order.
