extends CanvasLayer

# preset
onready var gaming_hud = $GamingHud
onready var start_menu = $StartMenu
onready var pause_menu = $PauseMenu
onready var loading_screen = $LoadingScreen
onready var agent_counter = $AgentCounter

# export elements
export(int) var score = 0 setget score_set
export(int) var agent_n = 0 setget agn_set
export(int) var loading = 0 setget loading_set
export(int) var loading_max = 0

# signal settings
signal on_loading_100

# label format
var scorelabel = " score: %06d"
var agentlabel = " current agent number: %04d"

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	state_title()

# Node signal
func _on_StartButton_pressed():
	state_load()

func _on_PauseButton_pressed():
	state_pause()

func _on_HUD_on_loading_100():
	state_start()

func _on_ResumeButton_pressed():
	state_resume()

func _on_ExitButton_pressed():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func _on_TitleButton_pressed():
	state_title()

# menu state settings
func state_start():
	agent_counter.show()
	self.score = 0
	self.agent_n = 0
	$LoadingScreen/LoadingBG.visible = false
	get_tree().paused = false
	loading_screen.hide()
	gaming_hud.show()

func state_pause():
	get_tree().paused = true
	pause_menu.show()
	$PauseMenu/PauseBG.visible = true
	gaming_hud.hide()

func state_resume():
	get_tree().paused = false
	gaming_hud.show()
	pause_menu.hide()
	$PauseMenu/PauseBG.visible = false

func state_load():
	loading_screen.show()
	$LoadingScreen/LoadingBG.visible = true
	$LoadingScreen/LoadingBar.max_value = loading_max
	start_menu.hide()
	self.loading = 0

func state_title():
	get_tree().paused = true
	gaming_hud.hide()
	start_menu.show()
	pause_menu.hide()
	loading_screen.hide()
	agent_counter.hide()
	$LoadingScreen/LoadingBG.visible = false
	$PauseMenu/PauseBG.visible = false

# setter & getter
func score_set(value):
	if(value >= 999999):
		score = 999999
	else:
		score = value
	$GamingHud/ScoreLabel.text = scorelabel %score

func agn_set(value):
	agent_n = value
	if(value > 9999):
		$AgentCounter.text = "current agent number over 10000"
	else:
		$AgentCounter.text = agentlabel %agent_n

func loading_set(value):
	if(value == loading_max):
		emit_signal("on_loading_100")
	loading = value
	$LoadingScreen/LoadingBar.value = value
