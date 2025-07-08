extends Node
class_name EnemySpawner

signal on_wave_completed

const SPAWN_ANIM = preload("res://Scenes/SpawnAnim.tscn")

enum SpawnType {
	RandomTimer,
	FixedTimer
}

@export var spawn_type: SpawnType
@export var min_random: float
@export var max_random: float
@export var fixed_time: float
@export var enemies_per_wave: int = 5

@export var enemy_list: Array[PackedScene] = []
@onready var spawn_timer: Timer = $SpawnTimer

var enemies_remainig: int
var spawned_enemies: int

func _ready() -> void:
	GameManager.on_enemy_died.connect(_on_enemy_died)
	enemies_remainig = enemies_per_wave

#Spawn Enemy Fuction

func spawn_enemy() -> void:
	var spawn_anim: SpawnAnim = SPAWN_ANIM.instantiate()
	var pos_x = randf_range(-500,500)
	var pos_y = randf_range(-500,500)
	var spawn_pos := Vector2(pos_x, pos_y)
	spawn_anim.global_position = spawn_pos
	add_child(spawn_anim)
	
	
	await spawn_anim.on_spawn_enemy
	spawn_anim.queue_free()
	
	var random_enemy = enemy_list.pick_random() as PackedScene
	var enemy = random_enemy.instantiate() as Enemy
	enemy.global_position = spawn_pos
	get_parent().add_child(enemy)
	
	spawned_enemies +=1
	start_enemy_timer()
	
func start_enemy_timer() -> void:
	spawn_timer.wait_time = get_new_time()
	spawn_timer.start()
	
	
func get_new_time() -> float:
	var time: float
	if spawn_type == SpawnType.RandomTimer:
		time = randf_range(min_random, max_random)
	else:
		time = fixed_time
		
	return time


func _on_spawn_timer_timeout() -> void:
	if spawned_enemies >= enemies_per_wave:
		return
		
	spawn_enemy()

func _on_enemy_died() -> void:
	enemies_remainig -= 1
	if enemies_remainig <= 0:
		spawn_timer.stop()
		await get_tree().create_timer(1.0).timeout  # ✅ wait 1 second before next wave
		on_wave_completed.emit()
		enemies_remainig = enemies_per_wave
		spawned_enemies = 0
