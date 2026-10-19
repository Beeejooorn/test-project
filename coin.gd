extends Area2D

const SPAWN_MIN := Vector2(170, 270)
const SPAWN_MAX := Vector2(1110, 630)
const MIN_DISTANCE_FROM_PLAYER := 200.0

@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	particles.top_level = true
	z_index = 5

func collect(player_pos: Vector2) -> void:
	particles.global_position = global_position
	particles.restart()
	audio.play()

	var new_pos := global_position
	for i in 20:
		new_pos = Vector2(
			randf_range(SPAWN_MIN.x, SPAWN_MAX.x),
			randf_range(SPAWN_MIN.y, SPAWN_MAX.y))
		if new_pos.distance_to(player_pos) >= MIN_DISTANCE_FROM_PLAYER:
			break
	global_position = new_pos
