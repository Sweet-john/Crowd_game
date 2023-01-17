extends Node

var NPCScene = preload("res://NPC/NonePlayerCharacter.tscn")
var NPCInstance = NPCScene.instance()
var maxNpcNum = 1000
var npcIncreasePerFrame = 100
export var npcCounter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(NPCInstance)	# Create NPC
	get_parent().get_node("Camera2D/HUD").agent_n = 0
	#var npcCount = get_node(Camera2D/npcCount)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if npcCounter < maxNpcNum:
		for j in range(npcIncreasePerFrame):
			var NPCInstance = NPCScene.instance()
			NPCInstance.position.x = randi() % (3968 + 17664) - 3968
			NPCInstance.position.y = randi() % (4544 + 10496) - 4544
			add_child(NPCInstance)
			npcCounter += 1
	get_parent().get_node("Camera2D/HUD").agent_n = npcCounter
