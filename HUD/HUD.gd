extends CanvasLayer

# preset
onready var gaming_hud = $GamingHud
onready var start_menu = $StartMenu
onready var pause_menu = $PauseMenu
onready var loading_screen = $LoadingScreen
onready var agent_counter = $AgentCounter
onready var game_end_screen = $GameEndScreen

# export elements
export(int) var score = 0 setget score_set
export(int) var agent_n = 0 setget agn_set
export(int) var agent_safe_n = 0 setget agn_safe_set
export(int) var loading = 0 setget loading_set
export(int) var loading_max = 0

# signal settings
signal on_loading_100
signal load_npc
signal loading_end
signal game_end

# label format
var scorelabel = " score: %06d"
var agentlabel = " current zombie number: %04d"
var agentsafelabel = " safe zombie number: %04d"
var bbtextlabel = "[shake rate=4 level=24][center]%s[/center][/shake]"
var huntlabel = "[shake rate=4 level=24][center]You have Hunted: %d [/center][/shake]"
var safelabel = "[shake rate=4 level=24][center]zombies have escaped: %d[/center][/shake]"

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	state_title()

# Node signal
func _on_StartButton_pressed():
	emit_signal("load_npc")
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

func _on_HUD_game_end():
	state_end()

# menu state settings
func state_start():
	agent_counter.show()
	self.score = 0
	self.agent_n = 0
	$LoadingScreen/LoadingBG.visible = false
	loading_screen.hide()
	gaming_hud.show()
	get_tree().paused = false
	prepare_timer()

func prepare_timer():
	$GamingHud/Message.show()
	$GamingHud/Message.bbcode_text = bbtextlabel %"Prepare for hunting"
	yield(get_tree().create_timer(5), "timeout")
	$GamingHud/Message.bbcode_text = bbtextlabel %"5"
	yield(get_tree().create_timer(1), "timeout")
	$GamingHud/Message.bbcode_text = bbtextlabel %"4"
	yield(get_tree().create_timer(1), "timeout")
	$GamingHud/Message.bbcode_text = bbtextlabel %"3"
	yield(get_tree().create_timer(1), "timeout")
	$GamingHud/Message.bbcode_text = bbtextlabel %"2"
	yield(get_tree().create_timer(1), "timeout")
	$GamingHud/Message.bbcode_text = bbtextlabel %"1"
	yield(get_tree().create_timer(1), "timeout")
	emit_signal("loading_end")
	$GamingHud/Message.bbcode_text = bbtextlabel %"let's start hunting"
	yield(get_tree().create_timer(3), "timeout")
	$GamingHud/Message.bbcode_text = bbtextlabel %"don't let them leave"
	yield(get_tree().create_timer(3), "timeout")
	$GamingHud/Message.hide()

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
	game_end_screen.hide()
	$LoadingScreen/LoadingBG.visible = false
	$PauseMenu/PauseBG.visible = false

func state_end():
	get_tree().paused = true
	gaming_hud.hide()
	game_end_screen.show()
	$GameEndScreen/PauseBG.visible = true
	$GameEndScreen/ExitButton.hide()
	$GameEndScreen/Hunted.bbcode_text = huntlabel % score
	yield(get_tree().create_timer(1), "timeout")
	$GameEndScreen/Safe.bbcode_text = safelabel % agent_safe_n
	yield(get_tree().create_timer(1), "timeout")
	$GameEndScreen/ExitButton.show()
	for i in get_node("/root/Level/NPCNode").get_children():
		i.free()

# setter & getter
func score_set(value):
	if(value >= 999999):
		score = 999999
	else:
		score = value
	$GamingHud/ScoreLabel.text = scorelabel %score

func agn_set(value):
	
	if(value > 9999):
		$AgentCounter.text = "current zombie number over 10000"
	else:
		$AgentCounter.text = agentlabel %value
	if agent_n > 100 && value <= 100:
		emit_signal("game_end")
		return
	agent_n = value

func agn_safe_set(value):
	agent_safe_n = value
	if(value > 9999):
		$AgentCounter/SafeCounter.text = "safe zombie number over 10000"
	elif(value < 0):
		$AgentCounter/SafeCounter.text = agentsafelabel %0
	else:
		$AgentCounter/SafeCounter.text = agentsafelabel %agent_safe_n

func loading_set(value):
	if(value == loading_max):
		emit_signal("on_loading_100")
	loading = value
	$LoadingScreen/LoadingBar.value = value
