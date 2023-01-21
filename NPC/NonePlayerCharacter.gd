extends KinematicBody2D
var next_target: Vector2
var velocity = Vector2()
var new_velocity = Vector2()
var max_speed = 200
#var targetLocation = Vector2(randi() % (3968 + 17664) - 3968, randi() % (4544 + 10496) - 4544)
var targetLocation
var safe_zoon_pos : = PoolVector2Array()

onready var nav = $NavigationAgent2D

# Called when the node enters the scene tree for the first time.
func _ready():
	nav.set_navigation(get_node("/root/Level/WorldMap/Navi"))
	
	for i in get_node("/root/Level/WorldMap/EXIT").get_children():
		safe_zoon_pos.push_back(i.position)
	get_node("/root/Level/Camera2D/HUD").agent_n += 1
	randomize()
	targetLocation = safe_zoon_pos[randi()%safe_zoon_pos.size()-1]
	$NavigationAgent2D.set_target_location(targetLocation)
	yield(get_tree(), "idle_frame")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity = Vector2()
	next_target = nav.get_next_location()
	var dir = (next_target-position).normalized()
	velocity = max_speed * dir
	nav.set_velocity(velocity)
	
	move_and_slide(new_velocity)
	
	var player_position = get_node("/root/Level/MainCharacter").position
	if position.distance_to(player_position) < 192:
		get_node("/root/Level/Camera2D/HUD").score += 1
		queue_free()
	elif position.distance_to(targetLocation) < 512:
		get_node("/root/Level/Camera2D/HUD").agent_safe_n += 1
		queue_free()

func _exit_tree():
	get_node("/root/Level/Camera2D/HUD").agent_n -= 1


func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	new_velocity = safe_velocity
