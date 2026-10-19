extends CharacterBody2D

const SPEED := 300.0

var score := 0
var facing := 1.0
var sword_dist := 0.0

@onready var label: Label = $"../Label"
@onready var coin = $"../Coin"
@onready var coin_shape: CollisionShape2D = $"../Coin/CollisionShape2D"
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $Sword_HitBox
@onready var hitbox_shape: CollisionShape2D = $Sword_HitBox.get_child(0)

func _ready() -> void:
	# Distance of the sword box from the sprite's flip point, as placed on the RIGHT side
	var box_x := hitbox.position.x + hitbox_shape.position.x
	sword_dist = box_x - sprite.position.x
	hitbox.position.x = 0
	hitbox_shape.disabled = false

func _physics_process(_delta: float) -> void:
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if input_dir.x < 0:
		sprite.scale.x = -abs(sprite.scale.x)
		facing = -1.0
	elif input_dir.x > 0:
		sprite.scale.x = abs(sprite.scale.x)
		facing = 1.0

	# Mirror the sword box around the sprite's flip point, same distance on each side
	hitbox_shape.position.x = sprite.position.x + sword_dist * facing

	velocity = input_dir * SPEED
	move_and_slide()

	position.x = clamp(position.x, 64.0, 1216.0)
	position.y = clamp(position.y, 64.0, 656.0)

	_check_coin_hit()

func _check_coin_hit() -> void:
	var size: Vector2 = hitbox_shape.shape.size
	var center: Vector2 = hitbox_shape.global_position
	var rect := Rect2(center - size / 2.0, size)
	var coin_pos: Vector2 = coin_shape.global_position
	var radius: float = coin_shape.shape.radius * coin_shape.global_scale.x
	var closest := Vector2(
		clamp(coin_pos.x, rect.position.x, rect.end.x),
		clamp(coin_pos.y, rect.position.y, rect.end.y))
	if closest.distance_to(coin_pos) <= radius:
		add_score()
		coin.collect(global_position)

func add_score() -> void:
	score += 1
	label.text = "Score: " + str(score)
