# HealthBar2D

<p align="center">
  <img height="150px" src="https://user-images.githubusercontent.com/66784253/211197568-d4bd1a7b-f7cb-4046-b2a7-7dc829fc9343.png" alt="addon-icon"/>
</p>

> Note: this addon is under development/testing right now

A 2d Health bar implementation for the Godot Engine, written in GDScript.

This project is a Godot Engine addon that adds a HealthBar2D node to the editor. It extends the TextureProgress node and can be used to make various Progress bars that can represent Health, Stamina, Hunger, etc. It is released under the terms of the MIT License.

## Installation
- Clone this repository and move the content of the addons directory into the `res://addons` of your project
- In your project settings, enable the plugin

## Usage
After enabling, it will add a HealthBar2D node.
- Add this node as a child of the character you like
- As it extends from TextureProgress it will require texture. You can use the given `health_bar_texture.png` in the resources directory of the addon.
- resize the `Rect` control property by clicking the circular arrow in the Inspector
- Now you need two things in the parent character script. the `health` variable and the `health_changed` signal

```gdscript
extends KinematicBody2D  # example

signal health_changed

var health := 10
```
- Before running the project. you also need to call the `initialize` method from the parent

```gdscript
func _ready() -> void:
    $HealthBar2D.initialize()
```
- Now whenever the character takes damage, emit our `health_changed` signal with the current health

```gdscript
emit_signal("health_changed", health)
```

Thats it!

You can take a look at `example.tscn` scene in the `example` directory for a working example.
