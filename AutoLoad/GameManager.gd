extends Node

const EXLPOSION_ANIM = preload("res://Scenes/Exlposion_Anim.tscn")

var player: Player

func play_explosion_anim(pos: Vector2) -> void:
	var anim : AnimatedSprite2D = EXLPOSION_ANIM.instantiate() 
	anim.global_position = pos
	anim.z_index = 99
	get_parent().add_child(anim)
	await anim.animation_finished
	anim.queue_free()
