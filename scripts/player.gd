extends CharacterBody2D

# Constants for movement and physics

signal healthChanged

const SPEED = 750.0
const JUMP_VELOCITY = -2000.0
const GRAVITY = 3900
const SPRING_JUMP_VELOCITY = -3000.0
const ENEMY_JUMP_VELOCITY = -2000.0
var score = Global.highscore

var immortality_timer = null
var immortalityTime = 8.24  # Durasi imortal dalam detik
var isImmortal = false  # Menandakan apakah pemain imortal atau tidak


# Reference to the AnimatedSprite2D node
@onready var animated_sprite = $AnimatedSprite2D
@export var maxHealth = Global.maxHealth
@onready var currentHealth: int = maxHealth
@onready var sfx_jump = $sfx_jump
@onready var sfx_hurt = $sfx_hurt
@onready var sfx_shield = $sfx_shield

func _physics_process(delta: float) -> void:
	# Apply gravity if the character is not on the floor
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		
	# Handle jumping input
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sfx_jump.play()

	# Get the input direction for horizontal movement
	var direction := Input.get_axis("move_left", "move_right")

	# Flip the sprite based on movement direction
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Update horizontal velocity based on input
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.1)  # Smooth deceleration when no input

	# Handle screen wrapping
	var viewport_width = get_viewport_rect().size.x
	if position.x < -200:
		position.x = viewport_width
	elif position.x > viewport_width:
		position.x = -200
		
		# Move the character
	# Move the character
	
	move_and_slide()

	# Check if the character is on the floor and landed on a SpringPlatform
	if is_on_floor():
		var collision = get_last_slide_collision()
		if collision != null:
			var collider = collision.get_collider()
			if collider != null and collider.is_in_group("SpringPlatform"):
				velocity.y = SPRING_JUMP_VELOCITY
				
	if is_on_floor():
		var collision = get_last_slide_collision()
		if collision != null:
			var collider = collision.get_collider()
			if collider != null and collider.is_in_group("enemy"):
				velocity.y = ENEMY_JUMP_VELOCITY
				
# When the player enters the hurtbox (taking damage)
func _on_hurtbox_area_entered(area: Area2D) -> void:
	
	if currentHealth <= 0:
		return  # Tidak lanjut jika kesehatan sudah 0 atau kurang
	if area.name == 'hitbox':
		if not isImmortal:
			sfx_hurt.play()
			currentHealth -= 1
			print("Health saat ini: ", currentHealth)
			healthChanged.emit(currentHealth)
	
	elif area.name == 'black_clouds':
		if not isImmortal:
			sfx_hurt.play()
			currentHealth -= 1
			print("Health saat ini: ", currentHealth)
			healthChanged.emit(currentHealth)
	
	elif area.name == 'bullet_hitbox':
		if not isImmortal:
			sfx_hurt.play()
			currentHealth -= 1
			print("Health saat ini: ", currentHealth)
			healthChanged.emit(currentHealth)

	# Pengecekan setelah health berubah
	if currentHealth <= 0:
		print("Game Over!")
		if score > Global.highscore:
			Global.highscore = score
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		
var shield_timer: Timer = null  # Variabel untuk menyimpan timer
const IMMORTALITY_TIME = 8.24
func activate_shield():
	
	if isImmortal:
		
		print("Shield sudah aktif, memperbarui durasi...")
		sfx_shield.play()
	
	else:
		
		print("Mengaktifkan shield!")
		
		isImmortal = true
		
		sfx_shield.play()
		
		animated_sprite.play("idle_3")
	
	print("Shield aktif! Pemain imortal selama %.1f detik." % IMMORTALITY_TIME)
	
	print("Health saat ini: ", currentHealth)

	# Hentikan timer sebelumnya jika ada
	
	if shield_timer:
		
		shield_timer.queue_free()

	# Buat timer baru
	
	shield_timer = Timer.new()
	
	shield_timer.one_shot = true
	
	shield_timer.wait_time = IMMORTALITY_TIME
	
	shield_timer.timeout.connect(_on_shield_timeout)
	
	add_child(shield_timer)
	
	shield_timer.start()


func _on_shield_timeout():
	
	isImmortal = false
	
	print("Shield habis! Pemain tidak imortal lagi.")
	
	print("Health saat ini: ", currentHealth)
	
	animated_sprite.play("Idle")
	
	shield_timer.queue_free()  # Hapus timer setelah selesai
	
	shield_timer = null
	
	
var jetpack_timer: Timer = null  # Variabel untuk menyimpan timer
const JETPACK_TIME = 2.0

func jetpack():
	
	if not animated_sprite.is_playing() or animated_sprite.animation != "jetpack":
		
		animated_sprite.play("jetpack")
		
		print("Jetpack animation activated! Pemain menggunakan jetpack selama %.1f detik." % JETPACK_TIME)

		# Hentikan timer sebelumnya jika ada
		
		if jetpack_timer:
			
			jetpack_timer.queue_free()

		# Buat timer baru
		
		jetpack_timer = Timer.new()
		
		jetpack_timer.one_shot = true
		
		jetpack_timer.wait_time = JETPACK_TIME
		
		jetpack_timer.timeout.connect(_on_jetpack_timeout)
		
		add_child(jetpack_timer)
		
		jetpack_timer.start()

func _on_jetpack_timeout():
	
	print("Jetpack habis! Pemain kembali ke kondisi normal.")
	
	animated_sprite.play("Idle")
	jetpack_timer.queue_free()  # Hapus timer setelah selesai
	
	jetpack_timer = null
