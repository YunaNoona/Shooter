extends Node2D
class_name Game

@onready var player: Player = $Player
@onready var crosshair: Sprite2D = $CrossHair
@onready var camera_2d: Camera2D = $Camera2D
@onready var weapons: Node2D = $Weapons
@onready var enemy_spawner: EnemySpawner = $EnemySpawner
@onready var wave_label: Label = %WaveLabel
@onready var enemy_count_label: Label = %EnemyCountLabel
@onready var coins_label: Label = %CoinsLabel
@onready var wave_timer: Timer = $WaveTimer

# Game Over UI
@onready var game_over_ui: Control = $CanvasLayer/GameOverUI
@onready var gameover_btn_restart: Button = $CanvasLayer/GameOverUI/BTN_Restart
@onready var gameover_btn_quit: Button = $CanvasLayer/GameOverUI/BTN_Quit

# Pause Menu UI
@onready var pause_menu: Control = $CanvasLayer/PauseMenu
@onready var pause_btn_resume: Button = $CanvasLayer/PauseMenu/BTN_Resume
@onready var pause_btn_restart: Button = $CanvasLayer/PauseMenu/BTN_Restart
@onready var pause_btn_main_menu: Button = $CanvasLayer/PauseMenu/BTN_MainMenu

# Preload main menu for faster transition
var main_menu_scene := preload("res://Scenes/MainMenu.tscn")


func _ready() -> void:
	GameManager.reset_game_state()
	wave_timer.start()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	GameManager.player = player
	GameManager.on_game_over.connect(_on_game_over)

	# Game Over UI setup
	game_over_ui.visible = false
	game_over_ui.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	gameover_btn_restart.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	gameover_btn_quit.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	gameover_btn_restart.pressed.connect(_on_restart_pressed)
	gameover_btn_quit.pressed.connect(_on_quit_pressed)

	# Pause Menu UI setup
	pause_menu.visible = false
	pause_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	pause_btn_resume.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	pause_btn_restart.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	pause_btn_main_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	pause_btn_resume.pressed.connect(_on_pause_resume)
	pause_btn_restart.pressed.connect(_on_restart_pressed)
	pause_btn_main_menu.pressed.connect(_on_main_menu)

	print("✅ Game ready, game_over state:", GameManager.is_game_over)


func _process(_delta: float) -> void:
	if not GameManager.is_game_over:
		crosshair.global_position = get_global_mouse_position()
		camera_2d.global_position = player.global_position
		wave_label.text = "NEW WAVE IN\n%s" % int(wave_timer.time_left)
		coins_label.text = str(GameManager.coins)
		enemy_count_label.text = "Enemy: %s" % str(enemy_spawner.enemies_remainig)


func _input(event) -> void:
	if event.is_action_pressed("ui_cancel") and not GameManager.is_game_over:
		_toggle_pause()


func _toggle_pause() -> void:
	if get_tree().paused:
		pause_menu.visible = false
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	else:
		pause_menu.visible = true
		pause_btn_resume.grab_focus()
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_game_over() -> void:
	print("💀 Game Over triggered and UI shown")
	game_over_ui.visible = true
	gameover_btn_restart.disabled = false
	gameover_btn_quit.disabled = false
	gameover_btn_restart.grab_focus()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	print("🛑 Game paused, UI active")


func _on_restart_pressed() -> void:
	print("🔄 Restart triggered")
	GameManager.is_game_over = false
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	print("🚪 Quit triggered")
	get_tree().quit()


func _on_pause_resume() -> void:
	print("⏯️ Resume from pause")
	_toggle_pause()


func _on_main_menu() -> void:
	print("🏠 Main Menu triggered")
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_packed(main_menu_scene)


func _on_wave_timer_timeout() -> void:
	weapons.hide()
	wave_label.hide()
	enemy_count_label.show()
	enemy_spawner.start_enemy_timer()


func _on_enemy_spawner_on_wave_completed() -> void:
	weapons.show()
	wave_label.show()
	enemy_count_label.hide()
	wave_timer.start()
