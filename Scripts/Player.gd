extends CharacterBody2D
class_name Player

#Default Player Speed

@export var move_speed : = 700.0

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon: Weapon = $Weapon
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: HealthBar = $HealthBar


#If Player Can Move Then Goes To #1
#If player Can't Move This Function Returns

var can_move: bool = true

#Setting Mouse Position Detection

var mouse_pos: Vector2 


func _process(_delta: float) -> void:
	if not can_move: return
	get_mouse_pos()
	update_animations()
	update_rotation() 
	update_weapon_rotation()
	
	
func _physics_process(_delta: float) -> void:
	if  not can_move: return
	var input := Input.get_vector("Move_Left", "Move_Right", "Move_Up", "Move_Down") #1
	var direction := input.normalized()
	var movement := direction * move_speed
	velocity = movement
	move_and_slide()
	
	
func setup_weapon(weapon_data: WeaponData) -> void:
		weapon.setup(weapon_data)
		weapon.show()
	
#Mouse Position	
	
func get_mouse_pos() -> void:
	mouse_pos = get_global_mouse_position()	
	
func update_rotation() -> void:
	if mouse_pos.x > global_position.x:
		anim_sprite.flip_h = false
	else:
		anim_sprite.flip_h = true


#Rotate Weapon With Mouse

func update_weapon_rotation() -> void:
	if mouse_pos.x > global_position.x:
		weapon.rotate_weapon(false)
	else:
		weapon.rotate_weapon(true)
	
	weapon.look_at(mouse_pos)

	
#If Player is Moving Chnage the Animation To Move Else Idle
	
func update_animations() -> void:
		if velocity.length() > 0:
			anim_sprite.play("Move")
		else:
			anim_sprite.play("Idle")


func _on_health_component_on_damaged() -> void:
	#Health Bar Function
	var health_value := health_component.current_health / health_component.max_health
	health_bar.set_value(health_value)
	
	#Hit Material Function
	anim_sprite.material = GameManager.HIT_MATERIAL
	await get_tree().create_timer(0.3).timeout
	anim_sprite.material = null


func _on_health_component_on_defeated() -> void:
	anim_sprite.play("Death")
	can_move = false
	health_bar.hide()
