class_name Player extends CharacterBody2D

@onready var hurtbox: Area2D = $Hurtbox
@onready var head_cast_left: RayCast2D = $HeadCastLeft
@onready var head_cast_right: RayCast2D = $HeadCastRight
@onready var nudge_cast_left: RayCast2D = $NudgeCastLeft
@onready var nudge_cast_right: RayCast2D = $NudgeCastRight
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var au: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var health_component: HealthComponent = $HealthComponent

@export var max_speed: float = 900.0
@export var acceleration: float = 3.0
@export var friction: float = 11.0
@export var jump_height: float = -1450.0
@export var min_gravity: float = 30.0
@export var max_gravity: float = 60.0

@export var jump_sfx: AudioStream
@export var hurt_sfx: AudioStream
@export var heal_sfx: AudioStream

var gravity: float = min_gravity
var coyote_timer_activated: bool = false
var facing: int = 0

func _ready() -> void:
	Global.player = self

func _exit_tree() -> void:
	Global.player = null

func _physics_process(delta: float) -> void:
	var x_input: float = Input.get_axis("left", "right")
	facing = sign(x_input) if x_input else facing

	velocity.x = lerp(velocity.x, x_input * max_speed, delta * (acceleration if x_input else friction))

	if is_on_floor():
		coyote_timer_activated = false
		gravity = lerp(gravity, min_gravity, min_gravity * delta)
	else:
		if coyote_timer.is_stopped() and !coyote_timer_activated:
			coyote_timer.start()
			coyote_timer_activated = true
		gravity = lerp(gravity, max_gravity, min_gravity * delta)

	if Input.is_action_just_released("jump") and velocity.y < 0 or is_on_ceiling():
		velocity.y *= 0.5

	if Input.is_action_just_pressed("jump"):
		if jump_buffer_timer.is_stopped():
			jump_buffer_timer.start()

	if !jump_buffer_timer.is_stopped() and (!coyote_timer.is_stopped() or is_on_floor()):
		velocity.y = jump_height
		jump_buffer_timer.stop()
		coyote_timer.stop()
		coyote_timer_activated = true
		if jump_sfx:
			au.stream = jump_sfx
			au.play()

	if velocity.y > jump_height * 0.3:
		var collision: Array[bool] = [
			nudge_cast_left.is_colliding(),
			nudge_cast_right.is_colliding(),
			head_cast_left.is_colliding(),
			head_cast_right.is_colliding()
		]
		if collision.count(true) == 1:
			if collision[0]:
				global_position.x += 8.0
			if collision[1]:
				global_position.x -= 8.0

	velocity.y += gravity

	var x_speed: float = abs(velocity.x)
	sprite.flip_h = facing < 0

	animation_tree["parameters/movement/blend_position"] = float(x_speed >= 1 and is_on_floor())

	for bodies: Node2D in hurtbox.get_overlapping_bodies():
		if bodies is TileMapLayer:
			health_component.harm(1)

	move_and_slide()

func _on_health_depleted() -> void:
	get_tree().create_timer(1.0).timeout.connect(get_tree().reload_current_scene)

func _on_health_decreased(_amount: float) -> void:
	if hurt_sfx:
		au.stream = hurt_sfx
		au.play()
	animation_tree["parameters/hurt_oneshot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
