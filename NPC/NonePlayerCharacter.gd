extends KinematicBody2D
export onready var velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1))
var path : = PoolVector2Array()
var hit_flag = 0
var path_line = Line2D.new()
var next_target: Vector2
var ifEvacuation = 0
var targetLocation = Vector2(randi() % (3968 + 17664) - 3968, randi() % (4544 + 10496) - 4544)
onready var speed = 200



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	velocity = (velocity.normalized()) * speed
	

	
	yield(get_tree(), "idle_frame")

	

#	var freeSpawnArea = get_node("../../WorldMap/StaticBody2D").get_children()
#	var chosenArea = freeSpawnArea[randi() % freeSpawnArea.size()]
#	var randomLocationX = rand_range((chosenArea.polygon)[0][0], (chosenArea.polygon)[2][0])
#	var randomLocationY = rand_range((chosenArea.polygon)[0][1], (chosenArea.polygon)[2][1])
			
#	if not (Geometry.is_point_in_polygon(position,chosenArea.polygon)):
#		get_parent().npcCounter -= 1
#		queue_free()
#	else:
#		path = get_node("../../WorldMap/Navigation2D").get_simple_path(position, targetLocation)
#
#		path_line.width = 5
#		path_line.points = path
#		#get_node("../../WorldMap/Navigation2D").add_child(path_line)
#		#path_line.show_on_top
#
#		next_target = path[0]
#		path.remove(0)
#		$startEvacuation.wait_time = randf()*6.0+0.5
#		$startEvacuation.start()
	
	path = get_node("../../WorldMap/Navigation2D").get_simple_path(position, targetLocation)
	#print(path)

	path_line.width = 5
	path_line.points = path
	
	next_target = path[0]
	path.remove(0)
	$startEvacuation.wait_time = randf()*1.0+0.1
	$startEvacuation.start()
	
#	for i in get_node("../../WorldMap/StaticBody2D").get_children():
#		if Geometry.is_point_in_polygon(position,i.polygon):
#			get_parent().npcCounter -= 1
#			queue_free()
#		else:
#			continue



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
		
		
		var player_position = get_node("../../MainCharacter").position
		#print(position.distance_to(player_position))
		if position.distance_to(player_position) < 100:
			get_node("../../Camera2D/HUD").score += 1
			get_parent().npcCounter -= 1
			queue_free()
			
	else:
		var collision = move_and_collide(velocity * delta)
		if collision:
			velocity = velocity.bounce(collision.normal)
			if collision.collider.has_method("hit"):
				collision.collider.hit()

	

func _on_Timer_timeout():
	path = get_node("../../WorldMap/Navigation2D").get_simple_path(position, targetLocation)
	path_line.points = path
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
	ifEvacuation = 1
	$startEvacuation.stop()
