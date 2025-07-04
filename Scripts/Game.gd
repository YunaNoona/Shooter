extends Node2D
class_name Game

@onready var player: Player = $Player
@onready var crosshair: Sprite2D = $CrossHair
@onready var camera_2d: Camera2D = $Camera2D

#Setting Function So When We Start The Game Mouse Is Hidden

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	#Add Game Player Global Ref 
	
	GameManager.player = player
	
	
#Update CrossHair And Camera Position  

func _process(delta: float) -> void:
	crosshair.global_position = get_global_mouse_position()
	camera_2d.global_position = player.global_position
