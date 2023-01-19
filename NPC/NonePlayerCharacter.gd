extends KinematicBody2D
export onready var velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1))

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = (velocity.normalized()) * 100
	for i in get_node("../../WorldMap/StaticBody2D").get_children():
		if Geometry.is_point_in_polygon(position,i.polygon):
			get_node("../../Camera2D/HUD").agent_n -= 1
			queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		if collision.collider.has_method("hit"):
			collision.collider.hit()
	
	var player_position = get_node("../../MainCharacter").position
	#print(position.distance_to(player_position))
	if position.distance_to(player_position) < 100:
		get_node("../../Camera2D/HUD").agent_n -= 1
		queue_free()
