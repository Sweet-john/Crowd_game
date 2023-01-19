extends Node

var NPCScene = preload("res://NPC/NonePlayerCharacter.tscn")
var NPCInstance = NPCScene.instance()
var maxNpcNum = 5000
var npcIncreasePerFrame = 100
var freeLocation: Vector2
var loading = false
#onready var generateRandomPoints = get_node("../WorldMap").inPolygonRandomPointGenerator.new(get_node("../WorldMap").getFreeArea())

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("../Camera2D/HUD").agent_n = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if loading:
		for j in range(npcIncreasePerFrame):
			var NPCInstance = NPCScene.instance()
			#freeLocation = generateRandomPoints.get_random_point()
			freeLocation = Vector2(randi() % (3968 + 17664) - 3968, randi() % (4544 + 10496) - 4544)
			print(freeLocation)
			NPCInstance.position = freeLocation
			add_child(NPCInstance)
			get_node("../Camera2D/HUD").agent_n += 1
		if get_node("../Camera2D/HUD").agent_n > maxNpcNum:
			loading = false

func _on_HUD_load_npc():
	loading = true
