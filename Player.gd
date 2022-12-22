extends KinematicBody2D

var velocity = Vector2.ZERO
const MAX_SPEED = 280
const ACCELERATION = 650
const FRICTION = 650

onready var animation_tree = $AnimationTree
onready var animation_State = animation_tree.get("parameters/playback")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left") 
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up") 
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_State.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_State.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)

	pass
