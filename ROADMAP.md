# Incremental Space Game — Roadmap

> **Engine:** Godot 4.7 · **Language:** GDScript
> **Last updated:** 2026-09-04

## How to use this file

Tick boxes as things land. When a whole block completes, move it up to **Completed**
with a short note on what actually shipped. Keep the **Decisions log** current — it
exists so future-you doesn't relitigate settled arguments.

Tiers are about *scope and ordering*, not importance:

- **Tier 2** — the current block of work. Finish this and the game is a complete loop.
- **Tier 2.5** — audio, art, and theming. Deliberately deferred until the systems settle.
- **Tier 3** — bigger systems that change what the game *is*.
- **Tier 4** — far horizon. Fun to think about, not scheduled.

---

## Completed

### Architecture
- [x] Resource-based data system — `DefenseData` → `SatelliteData` / `DroneData`, plus
      `UpgradeData`, `PerkData`, `AsteroidData`, `StatusEffectsData`
- [x] Auto-scanning folder registration for Defenses, Upgrades, Perks, Asteroids
- [x] Constant ID classes — `StatIDs`, `DefenseIDs`, `EffectIDs`, `StatusEffectIDs`, `PurchaseBlock`
- [x] `PurchaseBlock.Reason` — one enum drives button disabling, cost-label text, and tooltips
- [x] Signal-based decoupling; `Game_Manager` + `WaveManager` autoloads
- [x] `game_reset()` rebuilds registries instead of leaving holes in `active_stats`
- [x] `StatIDs` constants migration (raw strings removed)
- [x] `@tool` debug settings in `main.gd` with `_validate_property()` hiding
- [x] **Recursive resource folder scanning** — `_scan_resource_folder()` walks subfolders via
      `DirAccess.get_files_at()` / `get_directories_at()`, handling `.remap` and `.res`
      export-build suffixes. Resource folders can be organised into subfolders freely.
- [x] **Generic folder registrar** — `_register_folder(path, type, registrar, label)` collapsed
      three near-identical 30-line scan functions into three one-liners, using `Callable`
      and `is_instance_of()`
- [x] **Layered stat system** — `perk_flat` / `perk_mult` hold perk contributions separately
      from `active_stats`; `get_base_stat()` + `recalculate_stat()` compute
      `final = (base + flat) * mult`. Single write path; nothing outside `Game_Manager` changed.
- [x] **Perk system** — `purchase_perk()`, FLAT and PERCENT types, prerequisite tree,
      `ALL` wildcard targeting, tier-grouped accordion rows, and `PREREQS_NOT_MET` tooltips
      that name the missing prerequisites
- [x] **`planet` / `tractor_beam` category split** — a `NON_DEFENSE_DEFAULTS` table replaced
      the `if category == PLANET` special cases in `get_base_stat()`,
      `_resolve_perk_categories()` and `register_perk_stats()`. Adding a non-defense category
      is now one dictionary entry. Planet tab groups its rows by category via
      `setup_upgrade_group()`, ordered by the const rather than folder scan order.
- [x] **Stat counters** — `StatsManager` autoload with `run` / `lifetime` dictionaries,
      `increment()` / `record_max()` / `reset_run()`, plus a `CounterIDs` constants class.
      No signal on increment (damage fires dozens of times a second); `debug_print()` covers
      display until the stats menu exists. Damage is clamped to remaining health so overkill
	  doesn't inflate the total.
- [x] `WaveManager.register_all_asteroids()` migrated to `_register_folder()` — Asteroids
	  can now use subfolders and survive export-build `.remap` renaming
- [x] **`global` → `planet` category rename** — `max_planet_shield` → `shield`.
	  `StatIDs.GLOBAL` is reserved, unused, for genuinely game-wide stats later.
- [x] **`shield_changed` / `planet_hit` signal split** — one signal was carrying both
	  "value changed, redraw" and "we got hit, shake", so a perk purchase couldn't refresh
	  the bar without faking a hit. Screen shake now scales with damage.
- [x] **`_apply_shield_gain()`** — raising max shield tops up current shield by the
	  difference, so it works for both FLAT and PERCENT sources
- [x] **Feature-unlock perks** — `PerkData.perk_effect` (`STAT_MODIFIER` / `UNLOCK`) splits perks
	  into stat modifiers and feature toggles. `UNLOCK` perks carry an `unlock_id` validated at
	  registration, so `purchase_perk()` never has to re-check it. `purchase_perk()` was
	  restructured into validate → charge → apply → notify, so both kinds share the cost, counter,
	  and signal bookkeeping and only the apply step branches. `Game_Manager.unlocked_features`
	  plus `is_feature_unlocked()` and a `feature_unlocked(unlock_id)` signal; `UnlockIDs`
	  constants class. See Decisions log.
- [x] `ResourceScanner` extracted — `register_folder()` / `scan_resource_folder()` now live in a
	  static class instead of being duplicated in `game_manager.gd` and `wave_manager.gd`

### Gameplay
- [x] Wave system — weighted spawn pool, boss waves, `min_wave` gating
- [x] Status effect system — `StatusEffectsData`, MODIFIER / PERIODIC families,
	  source-keyed `status_effects` dict on asteroid, per-asteroid resistances,
	  strongest-wins `get_modifier()`
- [x] Orbit ring system — type-grouped rings, even spacing, arc-motion tweening, `redistribute()`
- [x] Planet shield as a computed property proxying into `active_stats`
- [x] `ScalingType.SUBTRACTIVE` for fire-rate style upgrades
- [x] Frame-based claim arbitration for collector satellite gravity conflicts
- [x] `purchase_upgrade()` cost/value ordering — cost read before `level_up()`, value after
- [x] **Radial asteroid spawning** — spawns on a fixed-radius circle around the planet
	  (`planet.global_position + Vector2.from_angle(randf() * TAU) * radius`) instead of picking
	  a screen edge. Travel time is now identical for every asteroid and every player.
	  `asteroid.gd`'s despawn check matches the geometry: a scalar `despawn_dist` computed once
	  in `start()` from the spawn distance + margin, compared against `distance_to(planet)`.
	  Deleted `viewport_size`, `_on_viewport_resized()`, `margin`, and `screen_size` — the file
	  no longer reads viewport size at all, so resize can't break it. See Decisions log.

### UI
- [x] Shop revamp, all three phases — `TabContainer`, custom stretch `TabBar`,
	  `FoldableContainer` accordion rows, `PurchaseLine`
- [x] Bulk purchase — x10, Shift for max
- [x] Range upgrade hover preview — blinking `Line2D` at next-level radius
- [x] **Off-screen threat indicator** — `ThreatArrowManager` (`CanvasLayer`) draws edge arrows
	  for incoming asteroids outside the view, unlocked by an `UNLOCK` perk.
	  Ranks by *seconds until visible* (world-space distance to the visible rect divided by
	  `asteroid.speed`), so a fast Swarm outranks a slow Tank at the same distance. Arrows scale
	  with urgency and blink on appearance.
	  - Fixed pool of 20 built in `_ready()`; nothing is instanced or freed during play.
	  - **Stable assignment** — an `asteroid → arrow` Dictionary keeps each arrow with its
		asteroid for its whole lifetime. Indexing the pool by sort rank instead made arrows swap
		screen edges whenever two asteroids traded places, and let blink tweens run on
		reassigned arrows.
	  - Per-frame pass is five functions: collect → rank → release → assign → update.
		Release must run before assign, or the pool looks empty and new threats get nothing.
	  - A dot product of the asteroid's `direction` against the direction to screen centre drops
		arrows for anything already receding — mainly comets after they pass.

### Feel & look
- [x] Hit flash, hit particles, death particles, floating damage numbers
- [x] Screen shake, mouse parallax camera, shop slide with camera counter-offset
- [x] Parallax starfield with twinkle shader (phase baked into blue channel)
- [x] Planet shield display
- [x] Randomized asteroid textures — `get_random_texture()` + `PlaceholderTexture2D` fallback
- [x] **Aspect-ratio scaling** — `window/stretch/mode="canvas_items"` + `aspect="expand"`.
	  `canvas_items` renders UI natively at the screen's real resolution (the earlier `viewport`
	  setting upscaled from 1920×1080 and made text blurry on high-res displays — a known
	  Godot 4 behaviour). `expand` reveals extra world space on wider/taller screens instead of
	  cropping or black-barring, and `camera.gd._update_aspect_zoom()` counteracts it with a
	  clamped `Camera2D.zoom`, re-running on `size_changed`.
- [x] **Resize-safe UI positioning** — `ui.gd` derives `shop_origin` / `shop_hidden_pos` from
	  the panel's anchors × `get_parent_area_size()` instead of sampling live `global_position`
	  and `size`, then snaps the panel to the correct target on resize. `camera.gd` stores
	  `shop_open` so it can recompute `shop_offset` on resize without being told.
- [x] **Projectile HDR glow** — `SatelliteData.projectile_color` → `turret_satellite.gd`
	  → `projectile.gd`'s `modulate`, with a `WorldEnvironment` + Glow in `main.tscn`.
	  New projectile types set one export field; no code changes.

---

## Tier 2 — current block

### 2A · Next up

- [ ] **Partial-set perk targeting** — `target_category: String` → `target_categories: Array[String]`,
	  with `["all"]` as the wildcard. Lets a perk hit turrets + lasers but not collectors.
	  ~15 lines in `_resolve_perk_categories()` and `register_perk_stats()`.
	  Same shape will be reusable for filtering stat counters by defense type.
- [ ] **Number formatting** — `format_number()` → `1.2K` / `3.4M`. Cost labels will
	  overflow their containers otherwise.
- [ ] More perk `.tres` resources — currently 2; aim for 3 roots / 4 middles / 1 capstone
	  so the prerequisite tree and the `", ".join()` tooltip path actually get exercised
- [ ] `damage_perk_1.tres` says "increases ALL damage" but targets `turret_satellite` —
	  should be `"all"`

### 2B · Core

- [ ] **Save / load** — serialize a plain Dictionary via `FileAccess` + `JSON`.
	  Avoid `ResourceLoader` on user files (embedded scripts execute).
- [ ] Start screen
- [ ] Pause menu — `PauseMenu` input action is mapped to nothing
- [ ] Game speed control (1x / 2x / 4x) — interacts with `local_time_scale` slow effects
- [ ] Auto-start wave toggle
- [ ] Sell / refund defenses
- [ ] **Targeting modes** — `get_nearest_asteroid()` → `get_target()` with a mode enum
	  (nearest / lowest HP / highest HP / closest to planet)
- [ ] Wave preview panel
- [ ] **Game Stats menu** with wave-end summaries — depends on stat counters;
	  coordinate with save/load. `StatsMenu` input action is mapped to nothing.

### 2C · Content

- [ ] **Splitter asteroids** — `@export var splits_into : AsteroidData` + `split_count`,
	  branch in `die()`
- [ ] **Wave modifiers** — a `WaveModifierData` resource, auto-scanned like everything
	  else, applied in `start_wave()`
- [ ] **Boss health bar** — screen-top bar during boss waves; extends existing
	  `bwave_label` warning behavior
- [ ] **Marker drone** — attaches to the asteroid it marks, applying `EffectIDs.DAMAGE_TAKEN`.
	  The drone body *is* the visual indicator. Gives drones an identity distinct from
	  satellites (they leave the ring and commit to a target), and caps concurrent marks
	  at the number of drones owned.
	  - Don't reparent to the asteroid — `queue_free()` takes children with it.
		Track the target and set `global_position` instead.
	  - Decide source-key granularity: shared key = one mark per asteroid;
		`"marker_drone_%d" % get_instance_id()` = stacking.
	  - Needs `is_instance_valid()` retarget handling — build after targeting modes.
- [ ] Drone content — collector drone, turret drone (`DroneData` is still an empty
	  marker class; Drones tab is empty)
- [ ] Satellite variety — laser, missile
- [ ] Cryo / incendiary satellite

### 2D · Wiring gaps & debt

- [ ] Generic on-hit effects — `SatelliteData.on_hit_effect` + magnitude/duration stats
	  → `projectile.gd` + `turret_satellite.gd`. *(Parked since the status-effect session.
	  The marker drone is its first real customer.)*
- [ ] **Acid status effect** (PERIODIC family) — *parked until satellite/drone variety
	  exists; 2C unblocks this*
- [ ] `StatusEffectsData.stack_rule` is declared but never read — `apply_effect()`
	  overwrites unconditionally, so STRONGEST vs REFRESH does nothing
- [ ] `StatusEffectsData.tint` unused — no visual for a slowed asteroid
- [ ] Orbit radius upgrades don't work — `satellite_ring.update_stats()` only reads
	  `ORBIT_SPEED`; `my_orbit_radius` is set once in `initialize()` and never re-read
- [ ] Resolve `get_modifier()` direction contract — comment assumes consumers apply
	  `(1.0 - x)` as a reduction; a vulnerability debuff needs `(1.0 + x)`
- [ ] Orbit ring visualization — per-ring `Line2D` circle owned by `satellite_ring.gd`
- [ ] Starfield twinkle gradient softening follow-up
- [ ] `purchase_line._process()` polls Shift every frame on every row — move to one
	  broadcaster
- [ ] `_set_satellite_range_visible(false)` reaches into `sat.range_indicator` directly
	  while the `true` path uses `has_method()` guards — pick one
- [ ] `CounterIDs.RUNS_STARTED` — now increments in `Game_Manager._ready()`, but `game_reset()`
	  no longer counts a fresh run. Decide which moment the counter means and make it consistent.
- [ ] `StatsManager._ready()` connects to `WaveManager.wave_complete` for `debug_print()` —
	  undocumented autoload-order dependency; remove when the stats menu lands
- [ ] Delete `Scenes/*.tmp` editor artifacts; add `*.tmp` to `.gitignore`

---

## Tier 2.5 — audio & art

*Sound was deliberately moved here: a dedicated session once sprite work is further along.*

- [ ] **AudioManager autoload** — pool of `AudioStreamPlayer` nodes, signal-driven off
	  `shield_changed`, asteroid death, purchases
- [ ] **Universal `Theme` resource** — replaces per-node styling before the UI grows further
- [ ] Sprite work — cartoon style in Krita, then Inkscape; pixelation shader overlay
	  (not native pixel art)
- [ ] Consider dropping base viewport resolution if going for a chunky pixel look —
	  currently 1920×1080 with nearest-neighbour filtering
- [ ] Resource despawn flash *(parked pending sprite art)*
- [ ] **Planet rotation** — sphere-mapping shader (fisheye UV warp sampling an equirectangular
	  strip texture) once a planet surface texture exists. Strip size ≈ π × on-screen diameter
	  wide, half that tall (2:1 ratio); must tile left-right seamlessly.
- [ ] **Resource glint** — shimmer sweep shader on asteroid/resource sprites; doesn't need new
	  art, works on whatever texture is already assigned. Cheap win, can happen anytime.

---

## Tier 3 — bigger systems

- [ ] **Prestige / meta-progression** — the genre-defining feature. `game_reset()` already
	  does the hard part; add a currency it doesn't clear. Perks gain an `is_meta` flag
	  and a second tree rather than converting the run-scoped ones.
- [ ] **Visual perk tree** — `PerkData.tier` and `prerequisites` exist for exactly this
- [ ] Object pooling — projectiles, resources, damage numbers, hit particles
- [ ] Achievements / milestones — nearly free once stat counters exist
- [ ] **`PurchasableData` base class** — *revisit here*, see Decisions log
- [ ] Headless balance simulation tooling

---

## Tier 4 — far horizon

- [ ] Multiple planets / solar system map
- [ ] Modular satellite building from parts
- [ ] Roguelite draft-pick run structure
- [ ] Web export + leaderboards
- [ ] Offline progress

---

## Decisions log

**`PurchasableData` base class — parked.** A shared base Resource for `DefenseData` /
`UpgradeData` / `PerkData` would collapse the type-branching in `purchase_line.gd`, but
all three would fully override both methods anyway, so it hoists signatures and no
implementation. Break-even is roughly four purchasable types; there are three. Interim
approach: give `PerkData` the *same method names and shapes* (`get_current_cost()`,
`get_block_reason() -> PurchaseBlock.Reason`) so `purchase_line.gd` can duck-type on one
`var data`. Revisit if a fourth type appears — prestige upgrades, planet modules, or
drone loadouts.

**Perks are run-scoped for now.** Flat one-time purchases on a prerequisite tree, bought
with run currency, are a *build-choice* system — runs diverge based on which branches you
could afford. That's interesting without prestige. When prestige lands, add a second set
via `is_meta` rather than converting these. `game_reset()` keeps calling `perk.reset()`.

**`active_stats` has a single-author problem — SOLVED, keep it that way.** It stores one
*final* value per stat, so any second contributor gets silently overwritten. Resolved by
layering: `perk_flat` and `perk_mult` hold perk contributions separately, `get_base_stat()`
returns the pre-perk value (upgrade curve if one exists, else the registered default), and
`recalculate_stat()` computes `(base + flat) * mult`. **`recalculate_stat()` is the only
thing that may write `active_stats`.** Anything that changes a stat calls it instead of
assigning. This was the root cause of four separate bugs — treat any new direct write as a bug.

**Signals are named after what happened, not what should happen next.** `shield_changed`
was doing double duty as "redraw the bar" and "shake the screen", so a perk purchase couldn't
refresh the display without faking a hit. Split into `shield_changed` (state changed) and
`planet_hit(damage)` (event occurred). New feedback — sound, particles, vignette — hooks
the event, not the state change.

**Wildcard perk targeting over explicit lists.** `target_category = "all"` resolves against
whatever categories exist at purchase time, so a new defense carrying the same stat is
covered with no perk edits. An `Array[DefenseData]` would have needed manual maintenance and
failed silently when forgotten — against the drop-a-file-in-a-folder philosophy of the codebase.

**Aspect-ratio fairness — clamped zoom now, an off-screen indicator later, not raw `expand`.**
`expand` alone reveals extra space unevenly across axes (whichever axis the screen is
proportionally wider/taller than base on), giving some aspect ratios extra early warning for
free. Camera zoom compensation only takes the edge off — fully correcting for 21:9 would make
16:9 feel cramped by comparison, so `min_zoom_factor` / `max_zoom_factor` clamp it deliberately
rather than fully equalizing. The real fairness fix is screen-size-independent: the planned
off-screen threat indicator (Tier 2C, perk-gated) gives every player the same information
regardless of what's physically visible, which raw camera math can only approximate.
*(Shipped — see UI, Completed.)*

**Feature unlocks are an `Array[String]`, not a resource class.** An `UnlockableData` Resource
with `enable()` / `reset()` was drafted and rejected: it would have needed its own folder scan,
registration function, and reset lifecycle to store what is ultimately a boolean. The test that
settled it wasn't "how many unlocks will there be" — an array scales to fifty fine — but
"will an unlock ever carry data beyond on/off?" Today none do. `is_feature_unlocked()` fronts
the array so callers don't touch it, which means promoting it to a Dictionary or a resource
later is a one-function change. Same break-even reasoning as `PurchasableData` above.

**Unlockable features need both a signal and a `_ready()` check.** `feature_unlocked(unlock_id)`
only reaches nodes listening when it fires, so it handles "unlocked mid-run" but not "already
unlocked before I existed" (scene reload, or a node added later). Both paths call one
`_refresh_unlock_status()` so there's a single definition of what unlocked means. The signal
also lets a feature do one-time setup — flipping `set_process()` — instead of testing a flag
every frame. Note `game_reset()` clears `unlocked_features` without emitting anything, so
re-locking depends on the `reload_current_scene()` that follows it.

**Radial spawning over screen-edge spawning.** Screen-derived spawn points made travel time a
function of monitor shape — at 3440×1440 a side spawn was ~1495 units out and a top spawn ~626,
a 2.4× difference decided by a coin flip, shifting again on every different display. A circle
of fixed radius makes travel time identical for everyone. The tradeoff is real and accepted:
on a non-square screen you can equalize travel time *or* visible lead-in, not both — a circle
means top/bottom spawns stay off-screen longer than side spawns. That's the right side to land
on because the defenses are radial too (turret range is a radius, satellites orbit in rings),
so a circular spawn matches the geometry that actually decides difficulty. Visible lead-in is a
presentation problem, and the off-screen indicator perk (2C) is the place to solve it.

**Placeholder art stays longer than feels comfortable.** Feel comes from motion, timing,
sound, and feedback far more than sprites.

---

## Recurring bug patterns

Things that have bitten more than once — check these first when something behaves oddly.

- **State that outlives its validity window** — three shapes of the same bug. A value sampled
  once and reused after something changed it (the shop panel's `global_position` after a tween);
  a value cached at `_ready()` that a later event invalidated (viewport size across a resize);
  and a per-frame array that was appended to but never cleared (`tagged_asteroids` grew to 4000+
  entries holding freed asteroids). Ask of any stored value: what could change underneath this,
  and does anything rebuild it when that happens?
- **Computing a value the engine already knows** — four bugs in one session. Sampling
  `global_position` for a panel's resting spot when a tween had polluted it (the anchors were
  clean); rebuilding a Control's parent width from `get_viewport().size` when
  `get_parent_area_size()` reports it in the right coordinate space; deriving world positions
  from screen dimensions in the spawner and the despawn check. If you're re-deriving something
  Godot already computed, ask it instead.
- **Correct only because a value is currently 0 or 1** — `anchor_left * width` looked right
  while `anchor_left` was `0`; `get_viewport_rect().size / 2` matched the planet only while the
  canvas was exactly 1920×1080. Test formulas against a value that *isn't* the identity.
- **`queue_free()` is deferred, not immediate** — a freed-but-not-yet-removed node keeps
  receiving signals and physics callbacks for the rest of the frame. Anything with a one-shot
  side effect (decrementing a counter, dropping loot, emitting a signal) needs a guard flag,
  not just `queue_free()`.
- **`@onready` before `add_child`** — initialize *after* adding to the scene tree
- **`duplicate()` + reassign** — shared resources (`CircleShape2D`, `ParticleProcessMaterial`)
  need duplicating *and* reassigning; forgetting the reassignment is the common miss
- **Guard clauses before side effects** — validate everything, *then* mutate
- **Off-by-one around level-up** — cost reads *before* the increment, value reads *after*
- **Direct writes to `active_stats`** — only `recalculate_stat()` may assign; everything
  else calls it. Four bugs so far have come from bypassing it.
- **Loop variables that are never used in the body** — either the loop is wrong or it
  shouldn't exist (caused the duplicated perk tier rows)
- **`continue` followed by an indented block** — that block is unreachable; watch the
  Debugger's unreachable-code warning
- **`Dictionary.duplicate()` is shallow** — nested dictionaries stay shared references, so
  duplicate the inner block directly or pass `duplicate(true)`
- **`DirAccess` folder scanning** — `.import` / `.remap` suffixes break in export builds;
  applies to the existing `.tres` scanning too
- **Texture sizing is an import-settings problem** — fixing it via `scale_ratio` silently
  breaks collision sizing
- **Pooled objects assigned by sort rank are unstable** — if slot `i` means "the i-th most
  urgent thing right now", the object behind a slot changes whenever the ranking shuffles.
  Anything with per-object continuity (a running tween, a fade-in, a position lerp) breaks or
  lands on the wrong object. Map owner → pooled object explicitly when continuity matters.
