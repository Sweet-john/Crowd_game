extends Node

var NPCScene = preload("res://NPC/NonePlayerCharacter.tscn")
var is_loading = false
var NPCInstance = NPCScene.instance()
var PreloadNPCnumber = 5000
export var npcCounter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	get_parent().get_node("Camera2D/HUD").agent_n = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if npcCounter >= PreloadNPCnumber:
		is_loading = false
	if is_loading:
		get_parent().get_node("Camera2D/HUD").loading = 0
		get_parent().get_node("Camera2D/HUD").loading_max = PreloadNPCnumber
		for j in range(10):
			var NPCInstance = NPCScene.instance()
			NPCInstance.position.x = randi() % ((3968 + 17664) - 3968)
			NPCInstance.position.y = randi() % ((4544 + 10496) - 4544)
			add_child(NPCInstance)
			npcCounter += 1
			get_node("../Camera2D/HUD").loading = npcCounter
		get_node("../Camera2D/HUD").agent_n = npcCounter

func _on_HUD_Loading():
	is_loading = true
