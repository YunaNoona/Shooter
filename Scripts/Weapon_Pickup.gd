extends Area2D
class_name WeaponPickup

@export var weapon_data : WeaponData

@onready var weapon_sprite: Sprite2D = $WeaponSprite
@onready var price_label: Label = %PriceLabel
@onready var buy_label: Label = $BuyLabel

var can_interact: bool

func _ready() -> void:
	set_weapon()

func set_weapon() -> void:
	weapon_sprite.texture = weapon_data.gun_sprite
	weapon_sprite.modulate = weapon_data.gun_colour
	price_label.text = str(weapon_data.buy_price)
	
	
func _input(event: InputEvent) -> void:	
	if can_interact and event.is_action_pressed("Interact") :
		GameManager.player.setup_weapon(weapon_data)

func _on_body_entered(body: Node2D) -> void:
	buy_label.show()
	can_interact = true


func _on_body_exited(body: Node2D) -> void:
	buy_label.hide()
	can_interact = false
