extends Area2D

onready var nozzle = $Nozzle

export(PackedScene) var bullet: PackedScene

var _target: Node2D
var _timer: Timer
func _ready():
	_config_timer()
	connect("body_entered", self, "_detected")
	connect("body_exited", self, "_lost")


func _config_timer() -> void:
	_timer = Timer.new()
	_timer.autostart = true
	_timer.wait_time = 0.5
	add_child(_timer)
	_timer.connect("timeout", self, "_shoot")


func _process(delta) -> void:
		yield(get_tree().create_timer(1.0), "timeout")


func _shoot() -> void:
	if _target:
		var dir = (_target.global_position - global_position).normalized()
		nozzle.rotation = dir.angle()
		var b = bullet.instance()
		b.global_position = nozzle.get_child(0).global_position
		b.direction = dir
		get_tree().get_root().add_child(b)
	_timer.start()


func _detected(body: Node2D) -> void:
	if body.name == "Player":
		_target = body


func _lost(body: Node2D) -> void:
	if body.name == "Player":
		_target = null
