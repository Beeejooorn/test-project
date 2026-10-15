extends Area2D

# Store score count
var score = 0

# get references to the coin and label nodes
@onready var coin = $"../Coin"
@onready var label = $"../Label"
@onready var particles = $"../Coin/CPUParticles2D"
@onready var audio = $"../Coin/AudioStreamPlayer2D"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Get keyboard input
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Flip character and sword collision shape based on movement direction
	if input_dir.x < 0:
		scale.x = -1
	elif input_dir.x > 0:
		scale.x = 1
	
	# Move character
	position += input_dir * 300.0 * delta
	
	# Keep character inside the 1280x720 screen bounds
	position.x = clamp(position.x, 64.0, 1216.0)
	position.y = clamp(position.y, 64.0, 656.0)


func _on_coin_area_entered(area: Area2D) -> void:
	# 1. Trigger Particle Explosion!
	particles.global_position = coin.global_position
	particles.restart()
	
	# 2. Increase score
	score += 1
	label.text = "Score: " + str(score)
	
	# 3. Respawn coin at a random spot inside the screen
	coin.global_position = Vector2(randf_range(100, 1180), randf_range(100, 620))
	
	# 4. coin sound effect
	audio.play()
