# HealthBar2D

<p align="center">
  <img height="150px" src="https://user-images.githubusercontent.com/66784253/211215415-80537f1b-c3b8-42ea-90ea-bf20cdafd01e.png" alt="addon-icon"/>
</p>


> Note: this addon is under development/testing right now

A 2d Health bar implementation for the Godot Engine, written in GDScript.

This project is a Godot Engine addon that adds a HealthBar2D node to the editor. It extends the TextureProgress node and can be used to make various Progress bars that can represent Health, Stamina, Hunger, etc. It is released under the terms of the MIT License.

## Installation
- Clone this repository and move the content of the addons directory into the `res://addons` of your project
- In your project settings, enable the plugin

## Usage

There are two ways to connect a HealthBar2D to a value source: **declarative** (Inspector only, no code required on the bar) and **imperative** (calling `initialize()` from the parent script). Both approaches are fully supported.

---

### Approach 1 — Dependency injection (recommended for HUD bars)

Set `signal_source` and `tracked_signal` on the bar and it connects itself at runtime. The source node never needs a reference to the bar.

The key benefit is that the dependency can be injected from anywhere — the Inspector, a parent node, a scene manager, a level script — without the tracked node knowing anything about the bar. Inspector assignment is just the most common case.

**When to use:** HUD bars, stamina/fuel meters, or any bar that lives in a separate scene branch from the node it tracks (e.g. inside a `CanvasLayer`). Also useful when you want a third party (e.g. a game manager) to wire up UI to entities at runtime.

1. Add a `HealthBar2D` node wherever you like in the scene tree (it does not need to be a child of the tracked node).
2. In the Inspector, expand the **Tracked Value** group and set:
   - `Signal Source` — drag the node that emits the signal into this field
   - `Tracked Signal` — the name of that signal (e.g. `health_changed`)
   - `Max Value Property` — the property name on the source node to read `max_value` from (e.g. `max_health`)
   - `Current Value Property` — the property name on the source node to read the initial `value` from (e.g. `health`)
3. In the source node's script, declare the signal and emit it whenever the value changes:

```gdscript
extends CharacterBody2D

signal health_changed(value: float)

var health := 100.0

func take_damage(amount: float) -> void:
    health -= amount
    health_changed.emit(health)
```

That's it — no `initialize()` call needed, and the source node has no reference to the bar.

You can also wire this up entirely in code from any third party (a level script, a UI manager, etc.):

```gdscript
# e.g. in a level script or HUD manager
func _ready() -> void:
    var bar = $HUD/Screen/HealthBar2D
    bar.signal_source = $Player
    bar.tracked_signal = &"health_changed"
    bar.max_value_property = &"max_health"
    bar.current_value_property = &"health"
```

---

### Approach 2 — Imperative (original, entity-attached bars)

Add `HealthBar2D` as a **direct child** of the character it tracks. The bar uses its parent's position to follow the entity in world space.

**When to use:** floating health bars above enemies, players, or other game entities.

1. Add `HealthBar2D` as a child of the character node.
2. Assign the `health_bar_texture.png` from the resources directory as the texture.
3. Resize the `Rect` control property by clicking the circular arrow in the Inspector.
4. In the parent script, declare a signal and call `initialize()` in `_ready`:

```gdscript
extends CharacterBody2D  # example

signal health_changed

var health := 10

func _ready() -> void:
    $HealthBar2D.initialize("health_changed", health)
```

5. Emit the signal whenever the value changes:

```gdscript
health -= damage
emit_signal("health_changed", health)
```

> One can add multiple bars using `HealthBar2D` and handle value change logic inside the character script — just remember to `emit` the related signal.

You can take a look at `example.tscn` in the `examples` directory for a working example.

---

## Export Properties

| Property | Type | Description |
|---|---|---|
| `_static` | `bool` | If `true`, the bar is always visible. If `false` (default), it fades in on change and fades out after `_animation_timeout` seconds. |
| `_gradient` | `bool` | If `true`, the bar color shifts from green → yellow → red as the value decreases. |
| `_animation_timeout` | `float` | Duration of the fade animation in seconds (default `1.0`). |
| `_offset` | `Vector2` | World-space offset from the parent node when used in entity-attached mode (default `Vector2(0, -6)`). |
| `signal_source` | `Node` | *(Tracked Value group)* The node that emits the tracked signal. |
| `tracked_signal` | `StringName` | *(Tracked Value group)* The name of the signal to listen to. |
| `max_value_property` | `StringName` | *(Tracked Value group)* Property name on `signal_source` to read `max_value` from at startup. |
| `current_value_property` | `StringName` | *(Tracked Value group)* Property name on `signal_source` to read the initial `value` from at startup. |
