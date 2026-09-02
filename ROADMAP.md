# Incremental Space Game — Roadmap

> **Engine:** Godot 4.7 · **Language:** GDScript
> **Last updated:** 2026-09-02

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

### UI
- [x] Shop revamp, all three phases — `TabContainer`, custom stretch `TabBar`,
      `FoldableContainer` accordion rows, `PurchaseLine`
- [x] Bulk purchase — x10, Shift for max
- [x] Range upgrade hover preview — blinking `Line2D` at next-level radius

### Feel & look
- [x] Hit flash, hit particles, death particles, floating damage numbers
- [x] Screen shake, mouse parallax camera, shop slide with camera counter-offset
- [x] Parallax starfield with twinkle shader (phase baked into blue channel)
- [x] Planet shield display
- [x] Randomized asteroid textures — `get_random_texture()` + `PlaceholderTexture2D` fallback

---

## Tier 2 — current block

### 2A · Next up

- [ ] **Perk integration**
  - [x] `PurchaseBlock.Reason.ALREADY_OWNED` + `PREREQS_NOT_MET`
  - [x] `PerkData.get_current_cost()` + `get_block_reason()`
  - [ ] `Game_Manager.purchase_perk()`
  - [ ] `ui.gd` — `perks_list` reference + `_populate_shop_panel()` branch
  - [ ] `shop_accordion_row.gd` — `setup_perk()`
  - [ ] `purchase_line.gd` — perk path
  - [ ] 2–3 actual perk `.tres` resources
- [ ] **Stat counters** — `asteroids_killed`, `total_resources_earned`, `damage_dealt`,
      `waves_survived`. Needed by the stats menu, save/load, and achievements.
- [ ] **Number formatting** — `format_number()` → `1.2K` / `3.4M`. Cost labels will
      overflow their containers otherwise.

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

**`active_stats` has a single-author problem.** It stores one *final* value per stat, and
`purchase_upgrade()` writes it absolutely from `base_value + val_per_level * (level - 1)`,
where `base_value` was synced once at registration. Any second contributor (perks) gets
silently overwritten on the next upgrade purchase. The cheap fix is for perks to shift
`UpgradeData.base_value` so they become part of the curve. The correct long-term fix is
splitting `active_stats` into base + modifier layers — deferred until it's actually needed.

**Placeholder art stays longer than feels comfortable.** Feel comes from motion, timing,
sound, and feedback far more than sprites.

---

## Recurring bug patterns

Things that have bitten more than once — check these first when something behaves oddly.

- **`@onready` before `add_child`** — initialize *after* adding to the scene tree
- **`duplicate()` + reassign** — shared resources (`CircleShape2D`, `ParticleProcessMaterial`)
  need duplicating *and* reassigning; forgetting the reassignment is the common miss
- **Guard clauses before side effects** — validate everything, *then* mutate
- **Off-by-one around level-up** — cost reads *before* the increment, value reads *after*
- **`DirAccess` folder scanning** — `.import` / `.remap` suffixes break in export builds;
  applies to the existing `.tres` scanning too
- **Texture sizing is an import-settings problem** — fixing it via `scale_ratio` silently
  breaks collision sizing
