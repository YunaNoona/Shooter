extends Control
class_name DamageText

@onready var damage_label: Label = $DamageLabel

func setup(value: int) -> void:
	damage_label.text = str(value)
