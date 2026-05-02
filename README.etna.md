# pqueue ETNA workload

`workloads/Haskell/pqueue` mines bug fixes from the upstream
`lspitzner/pqueue` git history (priority queues backed by a binomial
heap) and exposes each one as an ETNA mutation+property+witness
triplet, drivable by **QuickCheck**, **Hedgehog**, **Falsify**, and
**SmallCheck**.

## Layout

- The workload directory **is** the upstream fork (clone of
  `https://github.com/lspitzner/pqueue`). Upstream files
  (`pqueue.cabal`, `src/`, `tests/`, etc.) are untouched in the base
  state.
- `cabal.project` (ours) pins GHC 9.6.6 and ties `pqueue` (the upstream
  library) and `etna/` (our runner package) into one cabal context.
- `etna/etna-runner.cabal` builds:
  - a library exposing
    `Etna.{Result, Properties, Witnesses, Gens.QuickCheck,
            Gens.Hedgehog, Gens.Falsify, Gens.SmallCheck}`,
  - the `etna-runner` executable (CLI: `etna-runner <tool> <property>`),
  - the `etna-witnesses` test-suite (one frozen-input check per witness).
- `etna.toml` is the single source of truth for variants. `BUGS.md` and
  `TASKS.md` are derived (run
  `python3 scripts/check_haskell_workload.py --regen-docs <dir>`).
- `patches/<variant>.patch` contains the diff between the buggy and
  fixed states. The base tree contains the **fix**; `git apply -R
  patches/<variant>.patch` re-installs the bug.

## GHC toolchain

Falsify ≥ 0.2 requires `base >= 4.18`, i.e. GHC ≥ 9.6. `cabal.project`
points at GHC 9.6.6 (`with-compiler:`). Do not bump.

## Variants

Currently 1 variant (`mapmaybe_buggy_8fd23ba6_1`) covering 3 related
properties from upstream PR #111 ("Fix mapMaybe and mapEither"):

| Property | Library function | Witnesses |
|---|---|---|
| `MapMaybeMinMatchesList` | `Data.PQueue.Min.mapMaybe` | 2 |
| `MapEitherMinPartitions` | `Data.PQueue.Min.mapEither` | 2 |
| `PrioMapMaybeWithKey` | `Data.PQueue.Prio.Min.mapMaybeWithKey` | 2 |

The upstream bug: the prior implementations of these three functions
re-fed their post-filter result through `fromAscList` from a
heap-order traversal. For non-monotonic transforms this violates
`fromAscList`'s precondition and produces a queue whose `toAscList`
returns a permutation rather than the sorted result.

The injected bug replaces the modern
`BinomialQueue.insertEager`-driven implementations with naive
`fromAscList . filter . toListU` versions to recover that failure
mode.

## Running

```sh
cd workloads/Haskell/pqueue
cabal build all
cabal test etna-witnesses                  # base: all 6 witnesses pass

cabal run etna-runner -- quickcheck MapMaybeMinMatchesList
cabal run etna-runner -- hedgehog   MapMaybeMinMatchesList
cabal run etna-runner -- falsify    MapMaybeMinMatchesList
cabal run etna-runner -- smallcheck MapMaybeMinMatchesList
cabal run etna-runner -- etna       MapMaybeMinMatchesList   # witness replay
```

Install the bug:

```sh
git apply -R --whitespace=nowarn patches/mapmaybe_buggy_8fd23ba6_1.patch
cabal build all
cabal test etna-witnesses                  # variant: all 6 witnesses fail
git apply    --whitespace=nowarn patches/mapmaybe_buggy_8fd23ba6_1.patch
```

## Output contract

Each `etna-runner` invocation prints one JSON line to stdout and exits
0 (except on argv-parse error). Schema:

```
{"status":"passed|failed|aborted","tests":N,"discards":0,"time":"<us>us",
 "counterexample":STRING|null,"error":STRING|null,
 "tool":"etna|quickcheck|hedgehog|falsify|smallcheck",
 "property":"<PropName>"}
```

## Discover stage notes

`git log --all` over the upstream surface yields only a handful of
real correctness fixes; the bulk are CI / build / GHC-compat /
haddock fixes. Filtered candidates considered:

- `8fd23ba6` "Fix mapMaybe and mapEither (#111)" — included as
  `mapmaybe_buggy_8fd23ba6_1`. Three observable correctness invariants
  on public functions.
- `72f5bac6` "Restore shape invariant (#109)" — deferred. The shape
  invariant is internal (`other-modules`); the public API still
  returns correctly-ordered output even with the buggy spine, so the
  bug is not user-observable through the four backends.
- `dc07a216` "Force everything on extraction (#107)" — deferred.
  Strictness-only fix; no observable behavior difference under the
  property contracts we have.
- `9cfde6ea` "Fix Data.PQueue.Max.map (#76)" — deferred. The fix adds
  a missing function rather than correcting wrong runtime behavior;
  reverse-applying causes a *compile* error, not a property failure.
- `4d63eaba` "Fix Data instances" — deferred. Bug surfaces only via
  `gfoldl`/`gunfold` reconstruction, awkward to express as a
  framework-neutral property test.
- `2b447b22` "Remove PQueue.insertBehind, rewrite Prio.insertBehind"
  — deferred. `insertBehind` was removed entirely from upstream in
  PR #145 (2025-12-18, before our `base_commit`), so the buggy
  function no longer exists at HEAD.
