extends KinematicBody2D

# Need to be added to use the HealthBar2D
signal health_changed
signal stamina_changed

var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var speed := 100
var sprint_speed := 150
# Need to be added to use the HealthBar2D
var health := 10
var max_stamina := 50.0
var stamina := max_stamina

func _ready() -> void:
	# Need to be called to use the HealthBar2D
	$HealthBar2D.initialize("health_changed", health)
	$HealthBar2D2.initialize("stamina_changed", max_stamina)


func _process(delta) -> void:
	direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	velocity = direction.normalized() * speed
		
	if Input.is_action_pressed("sprint") and stamina > 0:
		velocity = direction.normalized() * sprint_speed
		stamina -= 0.5
		emit_signal("stamina_changed", stamina)
	elif stamina < max_stamina:
		stamina += 0.2
		emit_signal("stamina_changed", stamina)
	
	velocity = move_and_slide(velocity, Vector2.ZERO)


func hurt() -> void:
	if health > 0:
		health -= 1
		emit_signal("health_changed", health)
