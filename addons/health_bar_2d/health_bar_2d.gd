extends TextureProgressBar

# if false, health bar will only show itself when value is changed
@export var _static:bool = false
# if set true, health bar color will change as value decreases
@export var _gradient:bool = false
# time out for show/hide health bar animation
@export var _animation_timeout:float = 1.0
# offset of health bar from player
@export var _offset:Vector2 = Vector2(0, -6)

# Colors #
const _colors = {
	"neutral": "#00489d",
	"danger": "#9d0000",
	"success": "#009d36",
	"caution": "#d1ce00"
}

var _parent: Node
var _center_offset: Vector2 = size/2
#var _tween: Tween
var _timer: Timer


func _ready() -> void:
	_setup()


func _setup() -> void:
	"""Connects value_changed signal to _tween_fade or _color
	method according to exported _static and _gradient variables.
	"""
	if not _static:
#		_tween = Tween.new()
#		add_child(_tween)
		connect("value_changed", _show)
		modulate.a = 0
		
		_timer = Timer.new()
		add_child(_timer)
		_timer.connect("timeout", _fade)
		_timer.wait_time = _animation_timeout

	if _gradient:
		connect("value_changed", _color)


func _process(delta) -> void:
	"""Initialize the health bar for use in game.
	It must be called for HealthBar2D to work.
	"""
	if _parent:
		set_rotation(-_parent.rotation)
		set_global_position(_parent.position + _offset - _center_offset)


func initialize(signal_string: String, conneted_bar_max_value) -> void:
	"""Initialize the health bar for use in game.
	It must be called for HealthBar2D to work.
	"""
	print("Info: Initialized %s %s signal" % [name, signal_string])
	_parent = get_parent()
	_parent.connect(signal_string, _handle_value)
	max_value = conneted_bar_max_value
	value = max_value


func _handle_value(val: int) -> void:
	"""Sets the parent health to texture progress value.
	"""
	if max_value >= val:
		value = val


func _show(val: float) -> void:
	"""Method handles the health bar visibility.
	"""
	_timer.start()
	_tween(1)


func _fade() -> void:
	"""Method handles the health bar visibility.
	"""
	_tween(0)


func _color(val: float) -> void:
	"""Method handles the color of health bar.
	"""
	if _prc(val, 30):
		tint_progress = _colors.danger
	elif _prc(val, 55):
		tint_progress = _colors.caution
	else:
		tint_progress = _colors.success


func _prc(val: float, percentage: int) -> bool:
	"""Method returns true if health bar is in certain percentage."""
	return val <= max_value*(percentage/100.0)


func _tween(value: float) -> void:
	"""Method handles the tween animations.
	"""
	var tween := create_tween()
#	_tween.stop(self, "modulate:a")
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	
	tween.tween_property(
		self, "modulate:a", value, _animation_timeout
	)
