extends KinematicBody2D

# Need to be added to use the HealthBar2D
signal health_changed

var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var speed = 100

# Need to be added to use the HealthBar2D
var health := 10

func _ready() -> void:
	# Need to be called to use the HealthBar2D
	$HealthBar2D.initialize()


func _process(delta) -> void:
	direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	
	velocity = direction.normalized() * speed
	
	velocity = move_and_slide(velocity, Vector2.ZERO)


func hurt() -> void:
	if health > 0:
		health -= 1
		emit_signal("health_changed", health)
