extends Node

var NPCScene = preload("res://NPC/NonePlayerCharacter.tscn")
var NPCInstance = NPCScene.instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(NPCInstance)	# Create NPC
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
