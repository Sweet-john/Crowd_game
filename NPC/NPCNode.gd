extends Node

#var NPCInstance = NPCScene.instance()
var maxNpcNum = 5000
var npcIncreasePerFrame = 10
var npcCounter = 0
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
			get_node("/root/Level/NPC_Generator").generate_zombie()
			npcCounter += 1
		else:
			generateNPC = false
