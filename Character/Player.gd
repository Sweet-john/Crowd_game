extends KinematicBody2D

var state = MOVE
var velocity = Vector2.ZERO
const MAX_SPEED = 280
const ACCELERATION = 650
const FRICTION = 650
var movable = 0
enum{
	MOVE,
	ATTACK
}

var tpp_pos : = PoolVector2Array()
var tpa_pos : = PoolVector2Array()

onready var animation_tree = $AnimationTree
onready var animation_State = animation_tree.get("parameters/playback")

func _ready():
	animation_tree.active = true
	for i in get_node("/root/Level/WorldMap/TP/tpp").get_children():
		tpp_pos.push_back(i.position)
	for i in get_node("/root/Level/WorldMap/TP/tpa").get_children():
		tpa_pos.push_back(i.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)

func _physics_process(delta):
	for i in range(tpa_pos.size()):
		if position.distance_to(tpa_pos[i]) < 128:
			position = tpp_pos[i - (randi()%(tpa_pos.size() - 1) + 1)]


func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") 
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_State.travel("Run")
		velocity = input_vector * MAX_SPEED * movable
		#velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_State.travel("Idle")
		velocity = Vector2.ZERO
		#velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
func attack_state(delta):
	velocity = Vector2.ZERO
	animation_State.travel("Attack")
	
func attack_animation_finished():
	state = MOVE


func _on_HUD_loading_end():
	movable = 1
	
