extends Node
class_name HealthComponent

signal on_defeated 
signal on_damaged

@export var max_health :=10.0

var current_health : float

func _ready() -> void:
	current_health = max_health
	
func take_damage(value: float) -> void:
		if current_health <=0:
			return
			
		current_health -= value
		on_damaged.emit()
		
		if current_health<= 0:
			current_health = 0
			on_defeated.emit()
