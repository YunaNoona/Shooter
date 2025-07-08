extends Area2D
class_name Coin

@export var coin_value: int = 1
@onready var pickup: AudioStreamPlayer = $Pickup


func _on_body_entered(_body: Node2D) -> void:
	GameManager.coins += coin_value
	pickup.play()
	await pickup.finished
	queue_free()
