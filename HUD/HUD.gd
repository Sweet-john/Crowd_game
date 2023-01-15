extends CanvasLayer

onready var gaming_hud = $GamingHud
onready var start_menu = $StartMenu
onready var game_menu = $GameMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	start_menu.visible = true
	game_menu.visible = false
	gaming_hud.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_StartButton_pressed():
	start_menu.visible = false
	gaming_hud.visible = true
	pass # Replace with function body.
