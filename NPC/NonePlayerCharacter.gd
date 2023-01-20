extends KinematicBody2D
export onready var velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1))
var path : = PoolVector2Array()
var hit_flag = 0
var next_target: Vector2
var ifEvacuation = false
#var targetLocation = Vector2(randi() % (3968 + 17664) - 3968, randi() % (4544 + 10496) - 4544)
var targetLocation
onready var speed = 200

var safe_zoon_pos : = PoolVector2Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_node("/root/Level/WorldMap/EXIT").get_children():
		safe_zoon_pos.push_back(i.position)
	get_node("/root/Level/Camera2D/HUD").agent_n += 1
	randomize()
	velocity = (velocity.normalized()) * speed
	yield(get_tree(), "idle_frame")
	targetLocation = safe_zoon_pos[randi()%safe_zoon_pos.size()]
	path = get_node("/root/Level/WorldMap/Navigation2D").get_simple_path(position, targetLocation)
	
	next_target = path[0]
	path.remove(0)
	$startEvacuation.wait_time = randf()*1.0+0.1
	$startEvacuation.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if ifEvacuation:
		var collision = move_and_collide(velocity * delta)
		if collision:
			velocity = velocity.bounce(collision.normal)
			hit_flag = 1
			$Timer.start()
			if collision.collider.has_method("hit"):
				collision.collider.hit()
		if position.distance_to(next_target) < 100 and hit_flag == 0:
			if path.size() != 0:
				next_target = path[0]
				velocity = path[0] - position
				velocity = (velocity.normalized()) * speed
				path.remove(0)
			else:
				velocity = Vector2(0,0)

		var player_position = get_node("/root/Level/MainCharacter").position
		#print(position.distance_to(player_position))
		if position.distance_to(player_position) < 192:
			get_node("/root/Level/Camera2D/HUD").score += 1
			queue_free()
		elif position.distance_to(targetLocation) < 512:
			get_node("/root/Level/Camera2D/HUD").agent_safe_n += 1
			queue_free()
	else:
		var collision = move_and_collide(velocity * delta)
		if collision:
			velocity = velocity.bounce(collision.normal)
			if collision.collider.has_method("hit"):
				collision.collider.hit()

func _exit_tree():
	get_node("/root/Level/Camera2D/HUD").agent_n -= 1

func _on_Timer_timeout():
	path = get_node("/root/Level/WorldMap/Navigation2D").get_simple_path(position, targetLocation)
	next_target = path[0]
	path.remove(0)
	if position.distance_to(next_target) < 100:
		if path.size() != 0:
			next_target = path[0]
			velocity = next_target - position
			velocity = (velocity.normalized()) * speed
			path.remove(0)
			hit_flag = 0
			$Timer.stop()
		else:
			velocity = Vector2(0,0)
			hit_flag = 0
			$Timer.stop()
	else:
		velocity = next_target - position
		velocity = (velocity.normalized()) * speed
		hit_flag = 0
		$Timer.stop()


func _on_startEvacuation_timeout():
	ifEvacuation = true
	$startEvacuation.queue_free()
