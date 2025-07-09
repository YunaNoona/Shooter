extends Node

@warning_ignore("unused_signal")

signal on_enemy_died

@warning_ignore("unused_signal")

signal on_shake_request

@warning_ignore("unused_signal")

signal on_game_over

const EXLPOSION_ANIM = preload("res://Scenes/Exlposion_Anim.tscn")
const COIN = preload("res://Scenes/Coin.tscn")
const HIT_MATERIAL = preload("res://Material/HitMaterial.tres")
const DAMAGE_TEXT = preload("res://Scenes/DamageText.tscn")

var player: Player
var coins: int = 500
var is_game_over: bool = false

func reset_game_state():
	is_game_over = false
	coins = 500
	print("Game state reset")

func play_explosion_anim(pos: Vector2) -> void:
	var anim: AnimatedSprite2D = EXLPOSION_ANIM.instantiate()
	anim.global_position = pos
	anim.z_index = 99
	get_parent().add_child(anim)
	await anim.animation_finished
	anim.queue_free()

func play_damage_text(pos: Vector2, value: int) -> void:
	var damage = DAMAGE_TEXT.instantiate() as DamageText
	get_parent().add_child(damage)
	damage.global_position = pos
	damage.setup(value)

func create_coin(pos: Vector2) -> void:
	if randf_range(0, 100) <= 70:
		var coin := COIN.instantiate() as Coin
		coin.global_position = pos
		get_parent().call_deferred("add_child", coin)

func remove_coin(amount: int) -> void:
	coins -= amount
	if coins <= 0:
		coins = 0
