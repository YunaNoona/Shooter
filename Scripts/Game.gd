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

@onready var game_over_ui: Control = $GameOverUI
@onready var btn_restart: Button = $GameOverUI/BTN_Restart
@onready var btn_quit: Button = $GameOverUI/BTN_Quit

func _ready() -> void:
	# 🔁 Reset global game state
	GameManager.reset_game_state()
	wave_timer.start()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	GameManager.player = player
	GameManager.on_game_over.connect(_on_game_over)

	# 🎮 Setup UI for paused state
	game_over_ui.visible = false
	game_over_ui.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	game_over_ui.mouse_filter = Control.MOUSE_FILTER_PASS

	btn_restart.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	btn_restart.mouse_filter = Control.MOUSE_FILTER_STOP
	btn_restart.disabled = false
	btn_restart.pressed.connect(_on_restart_pressed)
	btn_restart.mouse_entered.connect(func(): btn_restart.modulate = Color(1, 1, 0.8))
	btn_restart.mouse_exited.connect(func(): btn_restart.modulate = Color(1, 1, 1))

	btn_quit.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	btn_quit.mouse_filter = Control.MOUSE_FILTER_STOP
	btn_quit.disabled = false
	btn_quit.pressed.connect(_on_quit_pressed)
	btn_quit.mouse_entered.connect(func(): btn_quit.modulate = Color(1, 0.8, 0.8))
	btn_quit.mouse_exited.connect(func(): btn_quit.modulate = Color(1, 1, 1))

	print("✅ Game ready, game_over state:", GameManager.is_game_over)

func _process(delta: float) -> void:
	if not GameManager.is_game_over:
		crosshair.global_position = get_global_mouse_position()
		camera_2d.global_position = player.global_position
		wave_label.text = "NEW WAVE IN\n%s" % int(wave_timer.time_left)
		coins_label.text = str(GameManager.coins)
		enemy_count_label.text = "Enemy: %s" % str(enemy_spawner.enemies_remainig)

func _on_enemy_spawner_on_wave_completed() -> void:
	weapons.show()
	wave_label.show()
	enemy_count_label.hide()
	wave_timer.start()

func _on_wave_timer_timeout() -> void:
	weapons.hide()
	wave_label.hide()
	enemy_count_label.show()
	enemy_spawner.start_enemy_timer()

func _on_game_over() -> void:
	print("💀 Game Over triggered and UI shown")

	# Enable buttons & show UI
	game_over_ui.visible = true
	btn_restart.disabled = false
	btn_quit.disabled = false
	btn_restart.grab_focus()

	# Show cursor
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	# Pause game last
	get_tree().paused = true
	print("🛑 Game paused, UI active")

func _on_restart_pressed() -> void:
	print("🔄 Restart button pressed")
	GameManager.is_game_over = false
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	print("🚪 Quit button pressed")
	get_tree().quit()
