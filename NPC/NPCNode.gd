extends Node

var NPCScene = preload("res://NPC/NonePlayerCharacter.tscn")
var NPCInstance = NPCScene.instance()
var npcCount = 0
var maxNpcNum = 1000
var npcIncreasePerFrame = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(NPCInstance)	# Create NPC
	#var npcCount = get_node(Camera2D/npcCount)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if npcCount < maxNpcNum:
		npcCount += npcIncreasePerFrame
		for j in range(npcIncreasePerFrame):
			var NPCInstance = NPCScene.instance()

			NPCInstance.position.x = randi() % 4000
			NPCInstance.position.y = randi() % 4000

			add_child(NPCInstance)
