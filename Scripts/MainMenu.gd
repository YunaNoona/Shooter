extends Control

@onready var btn_start: Button = $BTN_Start
@onready var btn_quit: Button = $BTN_Quit

func _ready() -> void:
	# Connect signals
	btn_start.pressed.connect(_on_start_pressed)
	btn_quit.pressed.connect(_on_quit_pressed)

	# Hover effects
	btn_start.mouse_entered.connect(func(): btn_start.modulate = Color(0.8, 1, 0.8))
	btn_start.mouse_exited.connect(func(): btn_start.modulate = Color(1, 1, 1))

	btn_quit.mouse_entered.connect(func(): btn_quit.modulate = Color(1, 0.8, 0.8))
	btn_quit.mouse_exited.connect(func(): btn_quit.modulate = Color(1, 1, 1))

	print("🎮 Main menu loaded")

func _on_start_pressed() -> void:
	print("▶️ Start button pressed")
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")

func _on_quit_pressed() -> void:
	print("❌ Quit button pressed")
	get_tree().quit()
