class_name Zombie
extends Reference

var shape_id : RID
var velocity : Vector2
var new_velocity : Vector2
var current_position : Vector2
var target_position : Vector2
var speed : float
var path : PoolVector2Array

func _safe_velocity_set(safe_velocity : Vector3):
	new_velocity = Vector2(safe_velocity.x, safe_velocity.z)
