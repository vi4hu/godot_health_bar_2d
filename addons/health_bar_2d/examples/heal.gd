extends Area2D

@export var _heal_power := 10


func _ready() -> void:
	connect("body_entered", _heal)


func _heal(body: Node) -> void:
	if body.name == "Player":
		body.health = _heal_power
		body.emit_signal("health_changed", body.health)
