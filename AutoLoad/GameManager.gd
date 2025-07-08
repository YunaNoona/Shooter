extends Node

signal on_enemy_died
signal on_shake_request

const EXLPOSION_ANIM = preload("res://Scenes/Exlposion_Anim.tscn")
const COIN = preload("res://Scenes/Coin.tscn")

const HIT_MATERIAL = preload("res://Material/HitMaterial.tres")
const DAMAGE_TEXT = preload("res://Scenes/DamageText.tscn")


var player: Player
var coins: int = 500 			#Default Coins Added on Game Start


func play_explosion_anim(pos: Vector2) -> void:
	var anim : AnimatedSprite2D = EXLPOSION_ANIM.instantiate() 
	anim.global_position = pos
	anim.z_index = 99
	get_parent().add_child(anim)
	await anim.animation_finished
	anim.queue_free()


#Damage Text Function

func play_damage_text(pos: Vector2, value: int) -> void:
	var damage = DAMAGE_TEXT.instantiate() as DamageText
	get_parent().add_child(damage)
	damage.global_position = pos
	damage.setup(value)


#Coin Function Spawn Coin After Defeating Enemy

func create_coin(pos: Vector2) -> void:
	var random_value =randf_range(0,100)
	if random_value <= 70:
		var coin := COIN.instantiate() as Coin
		coin.global_position = pos
		get_parent().call_deferred("add_child", coin)


#Remove No. Coin After Purchase

func remove_coin(amount: int) -> void:
	coins -= amount
	if coins <= 0:
		coins = 0
