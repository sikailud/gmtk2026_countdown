class_name HealthComponent extends Node

signal health_depleted
signal health_increased(amount: float)
signal health_decreased(amount: float)

@export var health: float = 1.0
@export var invincibility_time: float = 1.0
var invincible: bool = false

func is_depleted() -> bool:
	return health <= 0

func harm(amount: float) -> void:
	if invincible:
		return

	invincible = true
	get_tree().create_timer(invincibility_time).timeout.connect(
		func() -> void:
			invincible = false
	)

	health -= amount
	if is_depleted():
		health_depleted.emit()
	health_decreased.emit(amount)

func heal(amount: float) -> void:
	if is_depleted():
		health = amount
		return
	health += amount
	health_increased.emit(amount)

func _ready() -> void:
	if is_depleted():
		health_depleted.emit()
