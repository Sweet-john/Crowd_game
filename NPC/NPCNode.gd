extends Node

var NPCScene = preload("res://NPC/NonePlayerCharacter.tscn")
#var NPCInstance = NPCScene.instance()
var maxNpcNum = 5000
var npcIncreasePerFrame = 500
export var npcCounter = 0
var freeLocation: Vector2
var targetLocation: Vector2
#onready var generateRandomPoints = get_node("../WorldMap").inPolygonRandomPointGenerator.new(get_node("../WorldMap").getFreeArea())

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	get_parent().get_node("Camera2D/HUD").agent_n = 0
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().get_node("Camera2D/HUD").agent_n < maxNpcNum:
		for j in range(npcIncreasePerFrame):
#			var freeSpawnArea = get_node("../WorldMap/StaticBody2D").get_children()
#			var chosenArea = freeSpawnArea[randi() % freeSpawnArea.size()]
			
			freeLocation = Vector2(randi() % 18176 - 5120, randi() % 14016 - 6592)
#			targetLocation = Vector2(randi() % (3968 + 17664) - 3968, randi() % (4544 + 10496) - 4544)
#			var path = get_node("../WorldMap/Navigation2D").get_simple_path(freeLocation, targetLocation)
			var NPCInstance = NPCScene.instance()
#			NPCInstance.init(path)
			#print(generateRandomPoints)
			NPCInstance.position = freeLocation
			add_child(NPCInstance)
			get_parent().get_node("Camera2D/HUD").agent_n += 1
	#get_parent().get_node("Camera2D/HUD").agent_n = npcCounter
	
	
