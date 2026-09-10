# Incremental Space Game — Roadmap

> **Engine:** Godot 4.7 · **Language:** GDScript
> **Last updated:** 2026-09-09

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
- [x] Auto-scanning folder registration for Defenses, Upgrades, Perks, Asteroids, Resource types
- [x] Constant ID classes — `StatIDs`, `DefenseIDs`, `EffectIDs`, `StatusEffectIDs`, `PurchaseBlock`, `UnlockIDs`
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
- [x] **Wave difficulty scaling framework** — one normalized progress function feeding every
	  wave-derived number, replacing scattered ad-hoc formulas. `wave_progress(wave)` returns
	  0.0 at wave 1 and 1.0 at `SCALING_END_WAVE`, clamped at both ends. Two families sit on
	  top of it:
	  - **Bounded** — `lerpf(start, end, pow(progress, curve))` for anything with a real
		ceiling: `speed_multiplier()` (1.0 → `MAX_SPEED_SCALE`), spawn interval
		(`max_spawn_interval` → `MIN_SPAWN_INTERVAL`), swarm group size, tank spawn weight.
	  - **Unbounded** — `pow(2.0, (wave - 1) / X2_WAVE)` for stats the player's own power
		multiplies against: `health_multiplier()`, `damage_multiplier()`. Expressed as a
		*doubling period* rather than a raw growth rate, because "doubles every 13 waves" is
		something you can reason about and `1.055` isn't.
	  `SCALING_END_WAVE` typed as `float` so the division promotes; the curve exponent only
	  bends the middle (`pow(0, n) = 0`, `pow(1, n) = 1`), so endpoints are fixed by the lerp.
- [x] **`global` → `planet` category rename** — `max_planet_shield` → `shield`.
	  `StatIDs.GLOBAL` was reserved for genuinely game-wide stats; it now holds `drop_amount`.
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
- [x] **Resource tiers** — `ResourceData` (`resource_type` enum, `value`, `textures`, `min_wave`,
	  `base_weight`) auto-scanned from `Resources/ResourceTypes/`. Grey 1 / Blue 5 / Gold 10 /
	  Red 20, with Red gated behind `min_wave = 20`.
	  - `AsteroidData.drop_weights : Dictionary[ResourceData.ResourceType, float]` overrides a
		type's `base_weight` per asteroid, so harder enemies skew toward better drops.
		`drop_weight.get(type, base_weight)` gives per-entry override with fallback — no need to
		specify every type on every asteroid.
	  - `asteroid.die()` → `_get_next_resource()` (weighted roll, wave-filtered) → instantiate →
		`initialize(data, pos)`. All three deferred, in that order, so the node is in the tree
		before its data arrives.
	  - `resource.gd` has no `_ready()`: it ran during `add_child()`, *before* the deferred
		`initialize()`, so it read `my_data` while still null. Setup lives in `initialize()`.
	  - `collector_satellite` awards `resource.value` instead of a hardcoded 1.
	  - Per-asteroid `drop_weights` configured: Common `95/5/0/0`, Swarm `85/10/2/0`,
		Tank `65/25/8/2`, Boss `0/70/20/10`. Weight `0` keeps a type eligible but unwinnable.
		Drop counts scale with difficulty too (Common 0–3 → Boss 50–75).
	  - `ResourceData.glow` / `glow_color` drive a `PointLight2D` on `resource.tscn`, enabled in
		`initialize()`. Gold and Red glow; Grey and Blue don't.
	  - Four hand-drawn texture variants per tier, picked at random via `get_random_texture()`.
	  - Fixed alongside: `resource.gd`'s despawn check was still a screen-space box in world
		coordinates (the `asteroid.gd` bug, unfixed here), silently deleting most drops.
- [x] **Asteroid speed re-tune** — `speed_multiplier` was `0.1 * current_wave`, so wave 1 ran at
	  a tenth speed and every asteroid clamped to `min_speed`. Combined with base speeds authored
	  for a smaller spawn radius, a wave-1 asteroid took ~106s to arrive and ~80s of that was
	  off-screen. Fixed by starting the multiplier at 1.0 and re-deriving all five `max_speed`
	  values from `radius / target_seconds` (Comet 177 ≈ 12s, Swarm 118 ≈ 18s, Common 96 ≈ 22s,
	  Tank 71 ≈ 30s, Boss 47 ≈ 45s). `speed_variance` moved to `AsteroidData` as a *fraction*
	  (±12%) instead of an absolute ±15 px/s shared by every type. The `min_speed`/`max_speed`
	  clamp was deleted for a `push_warning` — a silent clamp disguises bugs as mistuning, and
	  `max_speed = 300` would have quietly eaten comet scaling from ~wave 35 on. See Decisions log.
- [x] **Group spawning** — `AsteroidData.group_size_start` / `group_size_end` (`Vector2i` min/max
	  pairs) + `group_ramp_end_wave` + `group_curve` → `get_group_size(wave)`. Progress is measured
	  from `min_wave`, not wave 1, so a type unlocking at wave 10 starts at 0% of its own ramp.
	  `Vector2i(1, 1)` defaults mean every existing `.tres` behaved identically with no migration.
	  Swarms run 2–3 → 6–7 by wave 70.
	  - `spawn_next()` rolls **one base angle per group**; `spawn_asteroid()` jitters ±7° around it
		plus ±90px radially. The radial jitter is what staggers arrivals — without it the whole
		group lands in the same frame and reads as one hit, not a swarm.
	  - Speed variance is rolled once per group and shared, so members hold formation.
- [x] **Spawn count bookkeeping** — `get_next_asteroid()` incremented the counters by exactly 1,
	  an assumption group spawning breaks. Counting moved to `register_spawns(count) -> int`, which
	  clamps the group to the remaining budget and returns how many the spawner may actually create.
	  The wave-end check went from `==` to `>=`: an exact-equality guard on a counter anything can
	  touch means one overshoot hangs the wave forever with no error. The two picker functions had
	  `asteroid_death()` calls compensating for the old increment — removing the increment turned
	  those into an active undercount.
- [x] **Tank spawn-weight ramping** — `spawn_weight_end` / `weight_ramp_end_wave` / `weight_curve`
	  → `get_spawn_weight(wave)`, with `-1.0` as a "no ramp" sentinel so untouched `.tres` files
	  need no migration. A static weight can only hold a share constant; it can't produce "rare
	  early, common late." Worse, with swarm group sizes inflating the population, a static tank
	  weight made tanks *decline* from 18.9% to 11.8% between waves 10 and 70.
- [x] `pick_asteroid_type()` and `get_boss_asteroid()` rebuilt on parallel `eligible` / `weights`
	  arrays built in one pass, same as `_get_next_resource()`. Both previously computed each weight
	  twice — harmless with a static field, a live desync hazard once the weight is wave-dependent.
- [x] **Drop scaling is perk-driven, not wave-driven** — `StatIDs.GLOBAL` (`"global"`) activated
	  as a `NON_DEFENSE_DEFAULTS` category holding `drop_amount`, default `1.0`. Ten FLAT perks of
	  `0.05` give exactly `(1.0 + 0.5) * 1.0 = 1.5`; PERCENT perks would have stacked
	  multiplicatively to `1.05¹⁰ = 1.63` and never landed on a round cap. See Decisions log.
	  - `asteroid.die()` uses **stochastic rounding** — `floori(exact)` plus a `randf()` chance on
		the remainder. `roundi(randi_range(1,3) * 1.05)` returned identical values to `* 1.0`, so the
		first three economy perks would have done literally nothing, and the tenth would have
		overdelivered at +67% instead of +50%.
- [x] **Perk-gated resource tiers** — `ResourceData.unlock_id` replaces `min_wave` as the tier
	  gate; an empty string means always available (Grey). `_get_next_resource()` filters on
	  `is_feature_unlocked()` and builds parallel `eligible` / `weights` arrays in one pass instead
	  of computing each weight twice. Zero-weight entries are skipped, and an `is_empty()` guard
	  replaces an `eligible.back()` that would have errored on an empty array.
- [x] **Projectile speed upgrade** — `projectile_speed` in `turret_satellite` defaults through
	  `StatIDs.PROJ_SPEED` → `update_satellite_stats()` → `shoot()` → `projectile.start()`.
- [x] **Projectile despawn made world-relative** — was comparing world coordinates against a fixed
	  1920×1080 screen box anchored at the origin, which only worked because the camera happens to
	  sit centred on the planet. The box reached 740px above/below the planet, so a `range` upgrade
	  past ~580 would have made projectiles vanish mid-flight on the vertical axis while working
	  fine horizontally. Now bounded by distance travelled from the firing point.

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
- [x] **Full-screen pixelation shader** — `PixelationLayer` (`CanvasLayer`, layer 2) with a
	  full-rect `ColorRect` reading `hint_screen_texture` at `filter_nearest`, snapping
	  `SCREEN_UV` to a grid and sampling each block's centre. `block_size = 3`.
	  Layer ordering decides what gets quantized: world (0) and `ThreatArrowManager` (1) are
	  pixelated, `UI` (3) stays crisp. `mouse_filter = Ignore` or the ColorRect eats every click.
	  Chosen full-screen because per-sprite grids can't work here — `scale_ratio` and the
	  aspect-compensation zoom both change on-screen sprite size, so no fixed art-pixel-to-block
	  ratio exists. See Decisions log.
- [x] **Nebula background** — two `Parallax2D` layers (`scroll_scale` 0.05 / 0.1) holding
	  `NoiseTexture2D` sprites with `FastNoiseLite` + a `color_ramp` `Gradient` carrying alpha,
	  so clouds sit as wisps over the navy base. Mid layer blends additively; Far randomizes its
	  seed per run. `repeat_size` must match the *scaled* sprite size (2560×1440 at 5× → 12800×7200)
	  or the layers drift out of view, since `autoscroll` never wraps without it.
	  Seams were fixed by raising `frequency` and scaling the sprite up rather than widening
	  `seamless_blend_skirt` — more, smaller noise features give the seamless blend more to work with.
	  Node `texture_filter` is overridden to Linear; the project default is Nearest, which
	  produced 6px chunks at 5× scale, far coarser than the 3px pixelation grid.
- [x] **Starfield twinkle fix** — the shader multiplied RGB by `brightness_mult` but passed
	  `tex_color.a` through untouched, so dimming stars went *dark and opaque* rather than
	  transparent. Invisible against a near-black background; obvious the moment a bright nebula
	  sat behind them. Alpha now carries the dimming.

---

## Tier 2 — current block

### 2A · Next up

- [x] **Partial-set perk targeting** — `target_category: String` → `target_categories: Array[String]`,
	  with `["all"]` as the wildcard, plus a `_try_add_category()` dedupe helper. Note
	  `_resolve_perk_categories()` skips every `NON_DEFENSE_DEFAULTS` category when resolving `"all"`,
	  so `"all"` does **not** include `"global"` — correct, but surprising given how close the two
	  names read in `StatIDs`.
- [x] **Number formatting** — `NumberFormat` static class with `compact()` and trailing-zero
	  stripping, wired to all display call sites.
- [ ] More perk `.tres` resources — currently 3; aim for 3 roots / 4 middles / 1 capstone
	  so the prerequisite tree and the `", ".join()` tooltip path actually get exercised
- [ ] **Economy perk branch** — the plumbing is done and only the Blue unlock exists.
	  Needs: ten FLAT `drop_amount` perks at `0.05` each (→ exactly +50%), plus Gold and Red
	  `UNLOCK` perks. Planned tree shape: economy perk 3 gates Blue, 6 gates Gold, 8 gates Red,
	  with a second branch of per-tier drop-chance perks unlocking after each tier does.
	  Until these exist `drop_amount` sits at `1.0` and the branch is one node.
- [ ] **Wave length pacing** — wave duration is `events × spawn_interval`, and nothing tunes the
	  product. `max_asteroids = 3 + wave * 2` grows linearly and unbounded while the interval is
	  floored, so length humps at ~3.9 min around wave 35–50 and collapses to ~40s by wave 100.
	  Raising `MIN_SPAWN_INTERVAL` doesn't help (the mid-game interval is nowhere near the floor)
	  and stretching the ramp to wave 200 makes it monotonically worse (6.7 min at wave 100).
	  Real options: bound `max_asteroids`, or derive the interval from a target wave duration
	  (`interval = target_seconds / expected_events`) so length is tuned directly. 203 asteroids
	  in one wave is also the most likely framerate problem before object pooling exists.
- [ ] **Threat arrows are perk-gated during the waves that need them most** — radial spawning
	  means a wave-1 asteroid is hidden for ~16s, and the mitigation is behind
	  `UnlockIDs.THREAT_INDICATOR`. Options: ungate the base arrows and sell the urgency scaling /
	  glow / `max_arrows` as the perk; grant it free after wave N; or accept it because early waves
	  are forgiving. Design call, not a bug.
- [ ] **Wave 1 is not clearable** — confirmed in play. Three independent gates, all currently failing.
	  Fixing any one alone is not enough; the first two are the blockers.
	  - **Shots can't connect.** Projectiles fire at a position snapshot, so
		`effective_range = hit_radius × projectile_speed / asteroid_speed`. At base 300 that's ~94px
		against a 250 range — 62% of the range fires blanks, each costing a full cooldown.
		**Raising base `projectile_speed` to ~800 makes the full range usable at wave 1.** *(in progress)*
	  - **Kills don't fit the window.** A turret at orbit radius 160 with range 250 gets ~1.4s of
		expected firing time per asteroid (see Decisions log for the coverage math). Damage 1.5 vs a
		3.0 HP common needs two shots at 2.4s apart. **Damage must reach 3.0** to one-shot a wave-1
		common so the window only has to contain one trigger pull. The damage upgrade is
		MULTIPLICATIVE ×1.5, so level 2 is 2.25 and level 3 is 3.375 — one free tutorial upgrade
		doesn't cross it. Either grant two, or switch the upgrade to ADDITIVE (level 2 = exactly 3.0).
	  - **The opening is a forced move.** Turret 5 + collector 10 = exactly 15, and without a
		collector there's no income at all. Fine *as a tutorial*, but real wave 1 then starts with one
		turret. Two turrets is a bigger jump than it sounds: `redistribute()` keeps them 180° apart,
		so one is always within 90° of any incoming asteroid and worst-case engagement distance goes
		from d=90 to d=192. Test real wave 1 via debug injection at 15 / 22 / 33 (1, 2, 3 turrets
		plus collector), find the loadout that works, then make the tutorial hand that over.

### 2B · Core

- [ ] **Save / load** — serialize a plain Dictionary via `FileAccess` + `JSON`.
	  Avoid `ResourceLoader` on user files (embedded scripts execute).
- [ ] **Tutorial** — scripted opening before real wave 1. Buy a collector and a turret (the 15
	  starting resources make this a forced move, which is what a tutorial wants), run a one-asteroid
	  wave, teach the tractor beam on the drop, then hand over a free upgrade and a free perk.
	  Doubles as the delivery mechanism for whatever loadout real wave 1 actually needs — see 2A.
- [ ] **Shield recovery** — currently shield only ever decreases, so a rough early wave permanently
	  narrows the margin and the run spirals with no way back. Planned: shop heal item + a
	  between-waves healing perk + a heal-dropping asteroid variant. Design note: at least one
	  source should be **automatic** (~10–20% of max per wave), because the player who most needs
	  a paid heal is the one who couldn't afford it. Automatic regen is the floor; the shop item and
	  perk are acceleration. Auto-regen also makes shield upgrades better, since it scales with max.
	  The heal-dropping asteroid is the most interesting of the three — it makes one enemy type
	  *wanted* rather than only feared, which nothing else in the game currently does.
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

- [ ] **Predictive targeting perk** — turrets solve the intercept instead of firing at a position
	  snapshot. This is the permanent fix for `effective_range` (see Decisions log); raising
	  `projectile_speed` only buys time, because effective range shrinks as asteroid speed scales
	  (×2.2 by wave 100) and range upgrades push acquisition far past where direct fire connects.
	  The perk therefore becomes *more* valuable the deeper the run goes, with no balancing needed.
	  - Use the iterative solve, not the quadratic — easier to read and it degrades gracefully if
		the target changes direction, where the closed form doesn't:
		```gdscript
		var t : float = global_position.distance_to(target.global_position) / proj_speed
		for i in 3:
			var predicted : Vector2 = target.global_position + target.direction * target.speed * t
			t = global_position.distance_to(predicted) / proj_speed
		```
	  - Reads `target.direction` and `target.speed`, both already public on `asteroid.gd`.
	  - **Known inaccuracy:** the tractor beam's slow is applied inside `asteroid._physics_process()`
		via `get_modifier(TIME_SCALE)`, not to `speed` itself, so slowed asteroids get over-led.
		Either expose an effective-speed getter on the asteroid or accept the drift.
- [ ] **Hold-fire satellite** — reserve the "don't shoot at what you can't hit" behaviour as a
	  *distinct weapon identity* rather than baking it into the base turret. Filters targeting to
	  within effective range and waits, instead of spending cooldowns on shots that miss. Reads as
	  deliberate rather than broken, and pairs naturally with a slow, heavy shot — explosive or
	  burst-fire are the candidates. Contrast with the base turret, which fires constantly and
	  relies on projectile speed to connect.
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

- [ ] Fill in `drop_weights` on the asteroid `.tres` files — *done; see Completed.*
	  Balance pass still outstanding: a Boss now yields ~50–75 drops weighted toward Blue/Gold/Red,
	  which is a very large jump from a Common's 0–3 Grey. Verify in play before tuning further.
- [ ] **Range upgrade is currently a trap purchase** — miss distance scales *with* flight distance,
	  so buying range widens the band where a turret acquires targets it cannot hit and burns
	  cooldowns on them. `max_value = 1500` against an effective range of ~250 means the upgrade is
	  net-negative past a point. Resolves itself once predictive targeting exists (2C); until then,
	  either cap `max_value` near effective range or accept that the upgrade is mistuned.
- [ ] **Damage upgrade has no diminishing returns** — `val_per_level = 1.5` (MULTIPLICATIVE) and
	  `cost_multiplier = 1.5` are the same number, so damage-per-resource-spent is *constant
	  forever*. There is never a reason to buy anything else, which removes the diversification
	  decision that makes the shop interesting. Either lower `val_per_level` below `cost_multiplier`
	  or switch to ADDITIVE (which also fixes the wave-1 damage threshold — see 2A).
- [ ] **Verify turret damage reconciles** — a wave-35 log showed 13.5 damage. That matches ADDITIVE
	  level 9 with *no* perk applied (`1.5 × 9`) exactly, but not MULTIPLICATIVE (level 6 = 12.53 with
	  the 10% perk, level 7 = 18.80). Either the `.tres` changed after that log, or `damage_perk_1`
	  (`target_categories = ["all"]`) isn't reaching `turret_satellite`. Print
	  `active_stats["turret_satellite"]["damage"]` to settle it.
- [ ] **Income vs cost curve check** — income now grows roughly linearly (asteroid count × a
	  capped +50% from perks × rarity-unlock step changes), but `UpgradeData.get_current_cost()`
	  is `base_cost * pow(cost_multiplier, level - 1)` — geometric. Geometric costs against linear
	  income means the player eventually hard-stalls unless `max_cost` flattens the curve. Plot
	  `income_per_wave / cost_of_next_upgrade` across waves 1–100; if it isn't roughly flat,
	  purchases stop being meaningful decisions.
- [ ] **Per-tier drop-chance perks** — planned as `weight_stat_id` on `ResourceData`, letting the
	  build loop do `resource_weight *= active_stats[GLOBAL].get(id, 1.0)` with no tier knowledge in
	  `asteroid.gd`. Derive the string from `ResourceType.keys()[resource_type].to_lower()` rather
	  than storing a third encoding of "blue" alongside the enum and `unlock_id`. Deliberately not
	  added yet — an unused export on every resource until the first such perk exists. Note the
	  tradeoff: renaming an enum member silently changes every derived key, including in save files.
- [ ] Zero-weight entries aren't skipped in `pick_asteroid_type()` / `get_boss_asteroid()` —
	  inert today (nothing has weight 0) but a `roll` of exactly `0.0` would pick the first entry
	  regardless of its weight. `_get_next_resource()` already guards this.
- [ ] Comet's `start()` comment says they fly past *"avoiding the Planet"* — the intent is the
	  opposite. Comets are aimed near the planet with a ±9° offset so a bad roll is a direct hit;
	  that's why damage is 15 and they're rare and profitable. Fix the comment.
- [ ] Blue's `base_weight = 20.0` is the fallback for any asteroid whose `drop_weights` omits
	  Blue — against Grey's 95 that's ~17%, generous for the tier a perk unlocks. Confirm every
	  asteroid lists Blue explicitly, or lower the fallback.
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
	  (not native pixel art). *Shader is built — see Feel & look. Rules that follow from it:*
	  draw at display size (not small-then-upscaled), don't hand-place pixels, keep strokes and
	  gaps ≥4px at scale 1.0, flat tones over gradients, and greyscale anything that gets
	  `modulate`-tinted.
- [ ] Directional projectile art — currently a square, so the `rotation` already being set
	  reads as nothing. An elongated bar shows travel direction for the same effort.
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

**Full-screen pixelation, not per-sprite.** Matching an art pixel to a shader block requires a
fixed on-screen sprite size, and this project has none: `AsteroidData.scale_ratio` renders the
same texture at 0.5× / 1.0× / 1.5×, and `camera.gd`'s aspect compensation adds a further
0.9–1.15× that varies per player's monitor. A screen-space pass quantizes after scaling,
rotation and zoom have all happened, so every element shares one grid automatically. It also
fixes rotating sprites, which normally destroy a hand-drawn pixel grid. Consequence for art:
hand-placed pixel art only makes sense for fixed-size, non-rotating elements (UI icons);
everything else is painted and let the shader do the pixelating.

**HDR 2D was tried for glow and reverted.** `WorldEnvironment` glow needs RGB above 1.0, but
Godot's 2D renderer clamps to LDR unless `rendering/viewport/hdr_2d` is on — which is why
`projectile_color = Color(2.0, 2.0, 0.5)` was silently arriving as `(1, 1, 0.5)`. Enabling it
works, but it's a project-wide colour-space change: every existing overbright value starts
blooming (the `Color(4,4,4)` hit flash especially), and shader colour samplers need
`source_color` hints. Rebalancing the whole project to serve two effects wasn't worth it.
Current approach is baked glow — an additive radial gradient sprite behind the shape — which is
per-object, needs no global setting, and quantizes predictably under the pixelation pass.
Note bloom never lights *surrounding* objects regardless; that needs `PointLight2D`.

**Asteroid speed stays in px/s, not "seconds to arrive."** Storing `approach_time` and deriving
`speed = distance / time` was drafted and rejected. It decouples the data from `radius` cleanly,
but only while every trip is identical. A splitter fragment spawning 400px out would compute
`400 / 30 = 13 px/s` and crawl; a boss dropped in close for drama would slow down for it. **Speed
is intrinsic to the asteroid; approach time is a property of one particular journey.** The
reciprocal also fights the difficulty scale — `speed_multiplier` is a multiply, so in time-space
it becomes a divide and equal multiplier steps produce shrinking time steps. The root cause was
never the unit: it was one bug (`0.1 * current_wave`) plus five numbers authored for a smaller
radius. A doc comment on `max_speed` records the `radius / seconds` conversion so tuning can
still be reasoned about in seconds.

**Drop scaling is a player choice, not an automatic curve.** The original plan had a wave-based
`drop_multiplier()` alongside rarity bias, but income already scales on four axes that multiply:
asteroid count, drops per asteroid, rarity weighting, and resource value. Each looked reasonable
alone and together they produced ~100× income by wave 50 against ~14× enemy health. Moving the
multiplier into the perk tree cuts it to two axes — asteroid count (automatic) and player
purchases — and makes runaway income structurally hard rather than a tuning accident. It also
converts invisible pacing into agency: `ResourceData.min_wave` used to unlock tiers silently,
where a perk makes it a decision with a cost. Rejected doing it with `UpgradeData` (which has
levels and cost curves built in) because perks are where build-choice belongs; ten chained
prerequisite nodes *are* the tree, not a workaround for it.

**FLAT perks for capped multipliers, PERCENT for open-ended ones.** `recalculate_stat()` computes
`(base + flat) * mult`, and `perk_mult` accumulates as `mult * (1.0 + value)` — multiplicative.
Ten 5% PERCENT perks give `1.05¹⁰ = 1.629`, not 1.5. Percentages that stack by multiplication
never land on the round number you designed. FLAT against a base of `1.0` is additive and hits
the cap exactly.

**Sentinel defaults over renames, for zero-migration exports.** `spawn_weight_end = -1.0` meaning
"no ramp" and `group_size_start = Vector2i(1, 1)` meaning "no group" both let every existing
`.tres` keep working untouched. The alternative — renaming `spawn_weight` to `spawn_weight_start`
for symmetry — would leave Godot unable to map the old property on load, silently zeroing all
five values. Naming asymmetry is cheaper than a migration, and a doc comment covers it.

**Turret reach is `effective_range`, not `range` — and range is the wrong lever.** `shoot()` passes
`target.global_position`, a snapshot, and the projectile then flies a fixed straight line while the
asteroid keeps moving. A shot connects only when
`asteroid_speed × (flight_distance / projectile_speed)` is smaller than the combined collision
radius, which rearranges to:

```
effective_range = hit_radius × projectile_speed / asteroid_speed
```

The consequence that isn't obvious: **miss distance scales with flight distance, so buying range
extends acquisition without extending the kill zone.** A longer range just means more shots fired
at targets that cannot be hit, each costing a full cooldown — range upgrades currently *reduce*
damage-on-target. Projectile speed is the lever, and predictive targeting is the real fix.

The related geometry, which is why one turret is so much weaker than two: a turret orbits at radius
160 with range 250, so it engages an asteroid from `d = 410` when on the same side but only from
`d = 90` when on the far side — a 4.5× swing decided by orbit phase the player doesn't control.
Time-weighted, that's ~1.4s of expected firing time per asteroid at wave 1. Because
`redistribute()` spaces satellites evenly, **two turrets are always 180° apart**, so one is always
within 90° of any incoming asteroid and worst-case engagement rises from `d = 90` to `d = 192`.
The second turret is worth far more than the first — relevant to any "how much should the player
have by wave N" question.

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
- **Multipliers must initialize to `1.0`, additive bonuses to `0.0`** — the inverse of the above.
  A bare `var health_mult : float` is `0.0`, and `data.max_health * 0.0` is a silent zero with no
  error: asteroids die to any hit and deal no damage. Use the identity value for the operation.
- **A local sharing a name with a `data.` field** — three bugs in one session. `max_speed` (the
  clamp ceiling) vs `data.max_speed` (the stat) collapsed speed variance; `speed_variance` (a
  rolled offset) vs `data.speed_variance` (a configured fraction) reduced ±15% to ±0.15 px/s;
  `resource` as a `ResourceData` in one loop and an index in the next produced `weights[resource]`.
  The compiler is happy and the meaning quietly shifts. Name the local for what it *is*
  (`speed_offset`, `i`), not for the field it came from.
- **Rounding a small integer destroys a small multiplier** — `roundi(randi_range(1,3) * 1.05)`
  returns exactly what `* 1.0` returns, so the first several upgrade levels do nothing, and large
  multipliers overshoot (`roundi(1.5)` is +100% on that roll). Use stochastic rounding: `floori()`
  plus a `randf()` chance on the remainder. The average is then exact at every scale.
- **Two reasonable curves multiplying into an untuned third** — income scaling on four independent
  axes reached ~100× while each axis looked mild; wave length is `events × interval` and humps in
  the middle because neither curve is tuned against the product. When two scaling systems feed one
  outcome, plot the outcome, not the inputs.
- **A doc comment describing intent rather than behaviour** — `spawn_weight_end = -1.0` was
  documented as "no ramp" and the function never checked for it, so every unmodified asteroid's
  weight lerped toward `-1` and went negative around wave 68. Stale comments do the same thing
  (`DROP_X2_WAVE` was referenced by a comment after the constant stopped being used). The comment
  makes the gap invisible during review — verify against the code, not the description.
- **Integer division in scaling math** — `(wave - min_wave) / (end_wave - min_wave)` with all-`int`
  operands returns `0` until the final wave, then `1`. No warning, and the symptom looks like a
  step function instead of a ramp. Force one operand to `float` (`maxf()` on the denominator is
  the tidiest, since it doubles as the divide-by-zero guard).
- **`pow()` of a negative base with a fractional exponent is `NaN`** — and `NaN` survives
  `clampf()` untouched, since every comparison against it is false. Clamp the *progress* before
  `pow()`, not the result after. Relevant anywhere a wave number could fall below a `min_wave`,
  which wave-preview features will do.
- **`queue_free()` is deferred, not immediate** — a freed-but-not-yet-removed node keeps
  receiving signals and physics callbacks for the rest of the frame. Anything with a one-shot
  side effect (decrementing a counter, dropping loot, emitting a signal) needs a guard flag,
  not just `queue_free()`.
- **`@onready` before `add_child`** — initialize *after* adding to the scene tree. The mirror
  case bites too: `add_child()` runs `_ready()` **synchronously inside the call**, so a `_ready()`
  that reads data supplied by a later `initialize()` sees null. Either defer both in order, or
  don't put externally-supplied data in `_ready()` at all.
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
