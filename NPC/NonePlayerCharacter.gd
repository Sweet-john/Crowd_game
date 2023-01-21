extends KinematicBody2D
export onready var velocity = Vector2(0,0)
var path : = PoolVector2Array()
var hit_flag = false
var path_line = Line2D.new()
var next_target: Vector2
var ifEvacuation = false
#var targetLocation = Vector2(randi() % (3968 + 17664) - 3968, randi() % (4544 + 10496) - 4544)
var targetLocation: Vector2
onready var speed = 200
onready var hitCount = 0
var hitCountThreshole = 50
var targetRadius = 500
var player_position: Vector2
var collision: KinematicCollision2D
var isNpcGone = false
var eliminateDistance = 100

var safe_zoon_pos : = PoolVector2Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

	for i in get_node("/root/Level/WorldMap/StaticBody2D").get_children():
		if Geometry.is_point_in_polygon(position,i.polygon):
			queue_free()
			isNpcGone = true
		else:
			continue
	
	var nerestDistance = 1e10
	for i in get_node("/root/Level/WorldMap/EXIT").get_children():
		if position.distance_to(i.position) < nerestDistance:
			targetLocation = i.position
			nerestDistance = position.distance_to(i.position)
		else:
			continue
	
	if isNpcGone == false:
		yield(get_tree(), "idle_frame")
		path = get_node("/root/Level/WorldMap/Navigation2D").get_simple_path(position, targetLocation)
		
		if path.size() == 0:
			queue_free()
		else:
			get_node("/root/Level/Camera2D/HUD").agent_n += 1
			
			path_line.width = 5
			path_line.points = path
			
			next_target = path[0]
			path.remove(0)
			$startEvacuation.wait_time = randf()*(nerestDistance/100)+5.0
			$Timer.wait_time = randf()*1.0+0.1
			$startEvacuation.start()
	

func _process(delta):
	collision = move_and_collide(velocity * delta)


func _physics_process(delta):
	if ifEvacuation:
		if collision:
			velocity = Vector2(0,0)
			hit_flag = true
			hitCount += 1
			$Timer.start()

		if position.distance_to(targetLocation) < targetRadius:
			get_node("/root/Level/Camera2D/HUD").agent_n -= 1
			get_node("/root/Level/Camera2D/HUD").agent_safe_n += 1
			queue_free()
		
		if hitCount > hitCountThreshole and hit_flag == true:
			print("replanning for " + str($Zombie))
			path = get_node("/root/Level/WorldMap/Navigation2D").get_simple_path(position, targetLocation)
			path_line.points = path
			next_target = path[0]
			path.remove(0)
			hit_flag = false
			hitCount = 0
			if position.distance_to(next_target) < 100:
				if path.size() != 0:
					next_target = path[0]
					velocity = next_target - position
					velocity = (velocity.normalized()) * speed
					path.remove(0)
					hit_flag = false
					$Timer.stop()
				else:
					get_node("/root/Level/Camera2D/HUD").agent_safe_n += 1
					get_node("/root/Level/Camera2D/HUD").agent_n -= 1
					queue_free()
			else:
				velocity = next_target - position
				velocity = (velocity.normalized()) * speed
				hit_flag = false
				$Timer.stop()
			
		if position.distance_to(next_target) < 100 and hit_flag == false:
			if path.size() != 0:
				next_target = path[0]
				velocity = path[0] - position
				velocity = (velocity.normalized()) * speed
				path.remove(0)

	player_position = get_node("/root/Level/MainCharacter").position
	if position.distance_to(player_position) < eliminateDistance:
		get_node("/root/Level/Camera2D/HUD").score += 1
		get_node("/root/Level/Camera2D/HUD").agent_n -= 1
		queue_free()


func _exit_tree():
	#get_node("/root/Level/Camera2D/HUD").agent_n -= 1
	pass


func _on_Timer_timeout():
	if position.distance_to(next_target) < 100:
		if path.size() != 0:
			next_target = path[0]
			velocity = next_target - position
			velocity = (velocity.normalized()) * speed
			path.remove(0)
			hit_flag = false
			$Timer.stop()
		else:
			velocity = Vector2(0,0)
			hit_flag = false
			$Timer.stop()
	else:
		velocity = next_target - position
		velocity = (velocity.normalized()) * speed
		hit_flag = false
		$Timer.stop()


func _on_startEvacuation_timeout():
	ifEvacuation = true
	$startEvacuation.stop()
