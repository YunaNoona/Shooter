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



#Setting Function So When We Start The Game Mouse Is Hidden

func _ready() -> void:
	wave_timer.start()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	#Add Game Player Global Ref 
	
	GameManager.player = player
	
	
#Update CrossHair And Camera Position  

func _process(_delta: float) -> void:
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
