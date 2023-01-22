extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	Navigation2DServer.map_set_active(get_node("WorldMap/Navigation2D").get_rid(), true)
	get_node("/root/Level/Camera2D/HUD").agent_n = 0

func _on_HUD_load_npc():
	var npcCounter = 0
	var generatePerFrame = 50
	var generateFrame = 100
	for i in range(generateFrame):
		for j in range(generatePerFrame):
			get_node("NPC_Generator").generate_zombie()
		yield(get_tree().create_timer(0.1), "timeout")
