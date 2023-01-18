extends KinematicBody2D
export onready var velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1))

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = (velocity.normalized()) * 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		if collision.collider.has_method("hit"):
			collision.collider.hit()


func _on_Area2D_body_entered(body):
	get_parent().npcCounter -= 1
	queue_free()
