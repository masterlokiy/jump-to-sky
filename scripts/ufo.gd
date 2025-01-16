extends Node2D

signal healthChanged

@export var BULLET: PackedScene = null
@export var MOVE_SPEED: float = 100.0 # Kecepatan bergerak
@export var MOVE_AREA: Rect2 = Rect2(Vector2(-500, 200), Vector2(1000, 1000)) # Area gerak
@export var DIRECTION_CHANGE_TIME: float = 2.0 # Waktu sebelum arah berubah (dalam detik)

var target: Node2D = null
var move_direction: Vector2 = Vector2.ZERO
var direction_timer: float = DIRECTION_CHANGE_TIME

@onready var rayCast = $RayCast2D
@onready var reloadTimer = $RayCast2D/ReloadTimer
@onready var sfx_shoot = $sfx_shoot

@export var maxHealth = Global.ufo_maxHealth
@onready var currentHealth: int = maxHealth


func _ready():
	await get_tree().process_frame
	target = find_target()
	pick_random_direction()

func _physics_process(delta):
	# Update timer untuk mengubah arah
	direction_timer -= delta
	if direction_timer <= 0:
		pick_random_direction()

	# Pergerakan acak
	position += move_direction * MOVE_SPEED * delta

	# Jika keluar dari MOVE_AREA, pilih arah baru
	if not MOVE_AREA.has_point(position):
		pick_random_direction()

	# Arahkan ke target jika ada
	if target != null:
		var angle_to_target: float = global_position.direction_to(target.global_position).angle()
		rayCast.global_rotation = angle_to_target
		
		if rayCast.is_colliding() and rayCast.get_collider().is_in_group("player"):
			if reloadTimer.is_stopped():
				shoot()
				sfx_shoot.play()

func shoot():
	print("PEW")
	rayCast.enabled = false
	
	if BULLET:
		var bullet: Node2D = BULLET.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		bullet.global_rotation = rayCast.global_rotation
	
	reloadTimer.start()

func find_target():
	var new_target: Node2D = null
	
	if get_tree().has_group("player"):
		new_target = get_tree().get_nodes_in_group("player")[0]
	
	return new_target

func _on_ReloadTimer_timeout():
	rayCast.enabled = true

func pick_random_direction():
	# Pilih arah acak untuk bergerak
	move_direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()
	# Reset timer agar arah baru tetap aktif untuk beberapa waktu
	direction_timer = DIRECTION_CHANGE_TIME


func _on_ufo_hitbox_area_entered(area: Area2D) -> void:
	if area.name == 'rocket_hitbox': # Only reduce health if the player is not immortal
		currentHealth -= 1
		print("Health ufo saat ini: ", currentHealth)
		healthChanged.emit(currentHealth)
