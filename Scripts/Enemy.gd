extends CharacterBody2D
class_name Enemy

@export var move_speed := 400.0

#Health And Collision Ref 

@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: HealthBar = $HealthBar
@onready var anim_sprite: AnimatedSprite2D = $AnimSprite

var can_move := true

func _physics_process(_delta: float) -> void:
	var player_direction = GameManager.player.global_position - global_position
	var direction = player_direction.normalized()
	var movement = direction * move_speed
	velocity = movement
	
	#We Dont Directly Want To Enemy To Close Toward Player But Come Nearby
	
	if player_direction.length() <= 120:
		return
	
	if not can_move:
		return
	
	move_and_slide()
	anim_sprite.flip_h = true if velocity.x < 0 else false

func _on_health_component_on_damaged() -> void:
	#Health Bar Function
	var health_value := health_component.current_health / health_component.max_health
	health_bar.set_value(health_value)
	
	#Hit Material Func
	anim_sprite.material = GameManager.HIT_MATERIAL
	await get_tree().create_timer(0.3).timeout
	anim_sprite.material = null

func _on_health_component_on_defeated() -> void:
	can_move = false
	anim_sprite.play("Death")
	collision_shape_2d.set_deferred("disabled", true)
	GameManager.create_coin(global_position)
	health_bar.hide()
	
	await anim_sprite.animation_finished
	GameManager.on_enemy_died.emit()
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	var player = body as Player
	player.health_component.take_damage(2)
	GameManager.play_damage_text(player.global_position, 2)
