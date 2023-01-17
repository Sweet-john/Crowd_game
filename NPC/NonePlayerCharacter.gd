extends KinematicBody2D
export onready var velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1))

# Called when the node enters the scene tree for the first time.
func _ready():
	$DoubleTimer.wait_time = rand_range(15,3000)
	$DoubleTimer.start()
	velocity = (velocity.normalized()) * 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		if collision.collider.has_method("hit"):
			collision.collider.hit()
	var player_position = get_node("../../MainCharacter").position
	#print(position.distance_to(player_position))
	if position.distance_to(player_position) < 100:
		get_node("../../Camera2D/HUD").agent_n -= 1
		get_node("../../Camera2D/HUD").score += 1
		queue_free()

func _on_Area2D_body_entered(body):
	get_parent().npcCounter -= 1
	queue_free()


func _on_DoubleTimer_timeout():
	var scene = load("res://NPC/NonePlayerCharacter.tscn")
	var double_node = scene.instance()
	double_node.position.x = position.x + randi() % 10
	double_node.position.y = position.y + randi() % 10
	get_parent().add_child(double_node)
	get_node("../../Camera2D/HUD").agent_n += 1
