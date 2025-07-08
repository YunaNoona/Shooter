extends CharacterBody2D
class_name Player

@export var move_speed := 700.0

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon: Weapon = $Weapon
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: HealthBar = $HealthBar
@onready var collision: CollisionShape2D = $CollisionShape2D

var can_move: bool = true
var mouse_pos: Vector2

func _process(_delta: float) -> void:
	if not can_move or GameManager.is_game_over:
		return
	get_mouse_pos()
	update_animations()
	update_rotation()
	update_weapon_rotation()

func _physics_process(_delta: float) -> void:
	if not can_move or GameManager.is_game_over:
		return
	var input := Input.get_vector("Move_Left", "Move_Right", "Move_Up", "Move_Down")
	velocity = input.normalized() * move_speed
	move_and_slide()

func setup_weapon(weapon_data: WeaponData) -> void:
	weapon.setup(weapon_data)
	weapon.show()

func get_mouse_pos() -> void:
	mouse_pos = get_global_mouse_position()

func update_rotation() -> void:
	anim_sprite.flip_h = mouse_pos.x < global_position.x

func update_weapon_rotation() -> void:
	weapon.rotate_weapon(mouse_pos.x < global_position.x)
	weapon.look_at(mouse_pos)

func update_animations() -> void:
	anim_sprite.play("Move" if velocity.length() > 0 else "Idle")

func _on_health_component_on_damaged() -> void:
	var health_value := health_component.current_health / health_component.max_health
	health_bar.set_value(health_value)
	anim_sprite.material = GameManager.HIT_MATERIAL
	await get_tree().create_timer(0.3).timeout
	anim_sprite.material = null

func _on_health_component_on_defeated() -> void:
	anim_sprite.play("Death")
	can_move = false
	health_bar.hide()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	GameManager.is_game_over = true
	GameManager.call_deferred("emit_signal", "on_game_over")

	weapon.set_process(false)
	weapon.set_physics_process(false)
	if is_instance_valid(weapon):
		weapon.call_deferred("queue_free")

	collision.set_deferred("disabled", true)
