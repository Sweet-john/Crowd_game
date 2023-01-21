extends Node

var NPCScene = preload("res://NPC/NonePlayerCharacter.tscn")
#var NPCInstance = NPCScene.instance()
var maxNpcNum = 5000
var npcIncreasePerFrame = 50
var npcCounter = 0
var freeLocation: Vector2
var targetLocation: Vector2
var generateNPC = true
#onready var generateRandomPoints = get_node("../WorldMap").inPolygonRandomPointGenerator.new(get_node("../WorldMap").getFreeArea())

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	get_node("/root/Level/Camera2D/HUD").agent_n = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if generateNPC:
		if npcCounter < maxNpcNum:
			for j in range(npcIncreasePerFrame):
				freeLocation = Vector2(randi() % (18176 + 5120) - 5120, randi() % (14016 + 6592) - 6592)
				var NPCInstance = NPCScene.instance()
				NPCInstance.position = freeLocation
				add_child(NPCInstance)
			npcCounter = get_node("/root/Level/Camera2D/HUD").agent_n
		else:
			generateNPC = false
