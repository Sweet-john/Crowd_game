extends CanvasLayer

onready var gaming_hud = $GamingHud
onready var start_menu = $StartMenu
onready var pause_menu = $PauseMenu
onready var loading_screen = $LoadingScreen

export(int) var score = 0 setget score_set
export(int) var loading = 0 setget loading_set
export(int) var loading_max = 0

signal on_loading_100

var scorelabel = " score: %06d"

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	start_menu.show()
	pause_menu.hide()
	$PauseMenu/PauseBG.visible = false
	$LoadingScreen/LoadingBG.visible = false
	gaming_hud.hide()
	loading_screen.hide()
	$GamingHud/ScoreLabel.text = scorelabel %score

func _on_StartButton_pressed():
	loading_screen.show()
	$LoadingScreen/LoadingBG.visible = true
	$LoadingScreen/LoadingBar.max_value = loading_max
	start_menu.hide()
	gaming_hud.hide()
	pause_menu.hide()
	$PauseMenu/PauseBG.visible = false
	self.loading = 0

func _on_PauseButton_pressed():
	get_tree().paused = true
	pause_menu.show()
	$PauseMenu/PauseBG.visible = true
	gaming_hud.hide()
	start_menu.hide()
	loading_screen.hide()

func score_set(value):
	if(value >= 999999):
		score = 999999
	else:
		score = value
	$GamingHud/ScoreLabel.text = scorelabel %score

func loading_set(value):
	if(value == loading_max):
		emit_signal("on_loading_100")
	loading = value
	$LoadingScreen/LoadingBar.value = value

func _on_HUD_on_loading_100():
	score = 0
	$GamingHud/ScoreLabel.text = scorelabel %score
	$LoadingScreen/LoadingBG.visible = false
	get_tree().paused = false
	loading_screen.hide()
	start_menu.hide()
	gaming_hud.show()
	pause_menu.hide()
	$PauseMenu/PauseBG.visible = false


func _on_ResumeButton_pressed():
	$LoadingScreen/LoadingBG.visible = false
	get_tree().paused = false
	loading_screen.hide()
	start_menu.hide()
	gaming_hud.show()
	pause_menu.hide()
	$PauseMenu/PauseBG.visible = false


func _on_ExitButton_pressed():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)


func _on_TitleButton_pressed():
	pause_mode = Node.PAUSE_MODE_PROCESS
	start_menu.show()
	pause_menu.hide()
	$PauseMenu/PauseBG.visible = false
	$LoadingScreen/LoadingBG.visible = false
	gaming_hud.hide()
	loading_screen.hide()
	$GamingHud/ScoreLabel.text = scorelabel %score
