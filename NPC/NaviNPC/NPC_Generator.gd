class_name NPC_Generator
extends Node2D

export (Texture) var zombie_image

onready var navigation_map = get_node("/root/Level/WorldMap/Navi") as Navigation2D

var zombies : Array = []
var eliminateDistance = 96
var targetRadius = 512

# =========================== Lifecycle =========================== #

func _exit_tree():
	for zombie in zombies:
		Navigation2DServer.free_rid((zombie as Zombie).shape_id)
	zombies.clear()

func _physics_process(delta : float) -> void:
	
	var zombie_queued_for_destruction : Array = []
	var player_pos = get_node("/root/Level/MainCharacter").position
	
	for i in range(0, zombies.size()):
		var zombie = zombies[i] as Zombie
		if zombie.current_position.distance_to(player_pos) < eliminateDistance:
			zombie_queued_for_destruction.append(zombie)
			get_node("/root/Level/Camera2D/HUD").score += 1
			continue
			
		elif zombie.current_position.distance_to(zombie.target_position) < targetRadius:
			zombie_queued_for_destruction.append(zombie)
			get_node("/root/Level/Camera2D/HUD").agent_safe_n += 1
			continue
			
		elif zombie.path.size() > 0:
			var velocity : Vector2
			var dir = (zombie.path[0] - zombie.current_position).normalized()
			velocity = zombie.speed * dir
			Navigation2DServer.agent_set_velocity(zombie.shape_id, velocity)
			zombie.current_position += zombie.safe_velocity * delta
	
	for i in zombie_queued_for_destruction:
		Navigation2DServer.free_rid(i.shape_id)
		get_node("/root/Level/Camera2D/HUD").agent_n -= 1
		zombies.erase(i)
	
	update()

func _draw():
	var offset = zombie_image.get_size() / 2
	for zombie in zombies:
		draw_texture(zombie_image, zombie.current_position - offset)

# =========================== Configure =========================== #

# register a new zombie in the array
func generate_zombie(speed := 200, i_movement:= Vector2.ZERO) -> void:
	var zombie : Zombie = Zombie.new()
	var target_position : Vector2
	zombie.velocity = i_movement
	zombie.speed = speed
	
	var temp_pos : Vector2
	var flag_pos : bool
	while true:
		temp_pos = Vector2(randi() % (18176 + 5120) - 5120, randi() % (14016 + 6592) - 6592)
		flag_pos = true
		for i in get_node("/root/Level/WorldMap/StaticBody2D").get_children():
			flag_pos = flag_pos && Geometry.is_point_in_polygon(temp_pos,i.polygon)
		if flag_pos:
			break
	
	var nerestDistance = 1e10
	for i in get_node("/root/Level/WorldMap/EXIT").get_children():
		if position.distance_to(i.position) < nerestDistance:
			target_position = i.position
			nerestDistance = position.distance_to(i.position)
	
	zombie.current_position = temp_pos
	zombie.target_position = target_position
	_configure_navigation_for_zombie(zombie)
	
	get_node("/root/Level/Camera2D/HUD").agent_n += 1
	zombies.append(zombie)

# set the navigation for every zombie
func _configure_navigation_for_zombie(zombie : Zombie) -> void:
	var used_transform1 := Transform2D(0,position)
	var used_transform2 := Transform2D(0,position)
	used_transform1.origin = zombie.current_position
	used_transform2.origin = zombie.target_position
	
	var _circle_shape = Navigation2DServer.agent_create()
	Navigation2DServer.agent_set_radius(_circle_shape, 12.8)
	Navigation2DServer.agent_set_map(_circle_shape, navigation_map.get_rid())
	Navigation2DServer.agent_set_callback(_circle_shape, zombie, "safe_velocity")
	Navigation2DServer.agent_set_max_neighbors(_circle_shape, 10)
	Navigation2DServer.agent_set_max_speed(_circle_shape, zombie.speed)
	Navigation2DServer.agent_set_neighbor_dist(_circle_shape, 128)
	Navigation2DServer.agent_set_position(_circle_shape, zombie.current_position)
	Navigation2DServer.agent_set_velocity(_circle_shape, zombie.velocity)
	zombie.path = Navigation2DServer.map_get_path(navigation_map, used_transform1.origin, used_transform2.origin, true)
	
	zombie.shape_id = _circle_shape
