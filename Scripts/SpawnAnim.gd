extends Sprite2D
class_name SpawnAnim

signal on_spawn_enemy

func spawn_enemy() -> void:
	on_spawn_enemy.emit()
