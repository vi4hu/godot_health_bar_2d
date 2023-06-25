extends Area2D

@onready var vn = $VN

var direction := Vector2.ZERO
var _speed := 200


func _ready() -> void:
	connect("body_entered", _detected)
	vn.connect("screen_exited", queue_free)
	rotation = direction.angle()


func _process(delta) -> void:
	position += direction * delta * _speed


func _detected(body: Node2D) -> void:
	if body.name == "Player":
		body.hurt()
		queue_free()
