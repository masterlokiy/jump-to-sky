extends Area2D

@onready var collected = $AnimatedSprite2D2
const RIGHT = Vector2.RIGHT
@export var SPEED: int = 500
@onready var sfx_explosion = $sfx_explosion
@onready var sfx_missile= $sfx_missile

func _ready() -> void:
	sfx_missile.play()
	

func _physics_process(delta: float) -> void:
	# Ambil posisi UFO dari global variabel
	var ufo_position = Global.ufo_position  # Mengambil posisi UFO dari variabel global
	# Hitung arah dari posisi roket ke posisi UFO
	var direction = (global_position - ufo_position).normalized()
	# Perbarui posisi roket untuk bergerak ke arah UFO
	global_position -= direction * SPEED * delta

func _on_rocket_hitbox_area_entered(area: Area2D) -> void:
	if area.name == 'ufo_hitbox':
		collected.play('collect')
		sfx_explosion.play()


func _on_animated_sprite_2d_2_animation_finished() -> void:
	if collected.animation == "collect":
		queue_free()
