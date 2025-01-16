extends Node2D

@onready var player = $Player
@onready var camera = $Camera2D
@onready var score_label = $Camera2D/Label
@onready var nunmStar = $Camera2D/numStar
@onready var camera_initial_position = $Camera2D.position.y
@onready var platform_container = $platform_container
@onready var item = $item
@onready var initial_platform_y_position1 = $platform_container/Clouds.position.y
@onready var initial_platform_y_position2 = $platform_container/Clouds2.position.y
@onready var initial_platform_y_position3 = $item/stars.position.y
@onready var color_rect = $ColorRect
@onready var heartContainer = $CanvasLayer/healthContainer
@onready var bgMusic = $Camera2D/bgMusic

@export var scene_platform : Array[PackedScene]

var initial_spawn_position = Vector2()

var score = 0
var current_level = 1
var level_thresholds = [0, 2000, 10000, 20000, 30000, 40000, 50000, 80000]  # Batas skor untuk setiap level
var max_platforms = 50 # Maksimal platform yang ada di layar 

var currentHealth: int = 5

# Fungsi untuk mendapatkan bobot platform berdasarkan level
func get_weight_for_level1(level: int) -> Dictionary:
	match level:
		1:
			return {0: 1.0, 1: 0.0, 2: 0.0, 3: 0.1, 4: 0.0, 5: 0.1}
		2:
			change_color(Color(0.53, 0.81, 0.98))
			return {0: 0.5, 1: 0.0, 2: 0.5, 3: 0.2, 4: 0.0, 5: 0.2}
		3:
			change_color(Color(0.6, 0.6, 0.6))
			return {0: 0.5, 1: 0.0, 2: 0.5, 3: 0.2, 4: 0.1, 5: 0.1}
		4:
			change_color(Color(0.4, 0.4, 0.6))
			return {0: 1.5, 1: 0.1, 2: 1.0, 3: 0.2, 4: 0.2, 5: 1.3}
		5:
			change_color(Color(0.5, 0.7, 0.8))
			return {0: 1.5, 1: 0.1, 2: 1.0, 3: 0.7, 4: 0.2, 5: 1.2}
		6:
			change_color(Color(0.1, 0.1, 0.2))
			return {0: 1.5, 1: 0.1, 2: 1.5, 3: 0.7, 4: 0.3, 5: 2.5}
		7:
			change_color(Color(0.0, 0.0, 0.2))
			return {0: 2.0, 1: 0.1, 2: 1.5, 3: 0.7, 4: 0.3, 5: 2.0}
		_:
			# Default bobot jika level tidak ditemukan
			return {0: 2.0, 1: 0.1, 2: 1.5, 3: 0.7, 4: 0.3, 5: 2.0}
			
func get_weight_for_level2(level: int) -> Dictionary:
	match level:
		1:
			return {0: 2.0, 1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 0.0, 6: 1.0, 7: 0.0, 8: 0.0}
		2:
			return {0: 2.0, 1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 0.0, 6: 1.0, 7: 0.0, 8: 0.0}
		3:
			return {0: 2.0, 1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 1.0, 6: 1.0, 7: 0.0, 8: 0.0}
		4:
			return {0: 2.0, 1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 0.7, 6: 1.0, 7: 0.0, 8: 0.0}
		5:
			return {0: 2.0, 1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 0.8, 6:  1.0, 7: 0.0, 8: 0.0}
		6:
			return {0: 2.0, 1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 1.9, 6: 1.0, 7: 0.0, 8: 0.0}
		7:
			return {0: 2.0, 1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 1.0, 6: 1.0, 7: 0.0, 8: 0.0}
		_:
			# Default bobot jika level tidak ditemukan
			return {0: 0.0, 1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 0.0, 6: 1.0, 7: 0.0, 8: 0.0}
			
func get_weight_for_level3(level: int) -> Dictionary:
	match level:
		1:
			return {0: 1.0, 1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 0.0, 6: 1.0, 7: 0.5, 8: 0.2}
		2:
			return {0: 1.0, 1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 0.0, 6: 1.0, 7: 0.5, 8: 0.2}
		3:
			return {0: 1.0, 1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 0.0, 6: 1.0, 7: 1.5, 8: 0.2}
		4:
			return {0: 1.0, 1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 0.0, 6: 1.0, 7: 2.5, 8: 0.5}
		5:
			return {0: 1.0, 1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 0.0, 6: 1.0, 7: 1.5, 8: 0.5}
		6:
			return {0: 1.0, 1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 0.0, 6: 1.0, 7: 1.5, 8: 0.5}
		7:
			return {0: 1.0, 1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 0.0, 6: 1.0, 7: 1.5, 8: 0.5}
		8:
			return {0: 1.0}
		_:
			# Default bobot jika level tidak ditemukan
			return {0: 0.0, 1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 0.0, 6: 1.0, 7: 0.0, 8: 0.0}
			
			
func change_color(new_color: Color):
	color_rect.color = new_color

# Fungsi untuk membuat platform dengan bobot
func level_generator1(platform_gap, amount):
	var current_platforms = platform_container.get_children().size()

	if current_platforms >= max_platforms:
		return  # Jangan buat platform baru jika sudah terlalu banyak

	var weight = get_weight_for_level1(current_level)  # Ambil bobot berdasarkan level saat ini

	for i in range(amount):
		var new_type = weighted_random_choice(weight)
		initial_platform_y_position1 = initial_platform_y_position1 - platform_gap
		var new_platform

		if new_type == 0:
			new_platform = scene_platform[0].instantiate() as StaticBody2D
		elif new_type == 1:
			new_platform = scene_platform[1].instantiate() as StaticBody2D
		elif new_type == 2:
			new_platform = scene_platform[2].instantiate() as StaticBody2D
		elif new_type == 3:
			new_platform = scene_platform[3].instantiate() as StaticBody2D
		elif new_type == 4:
			new_platform = scene_platform[4].instantiate() as StaticBody2D
		elif new_type == 5:
			new_platform = scene_platform[5].instantiate() as StaticBody2D
		elif new_type == 6:
			new_platform = scene_platform[6].instantiate() as Area2D
		elif new_type == 7:
			new_platform = scene_platform[7].instantiate() as Area2D
		elif new_type == 8:
			new_platform = scene_platform[8].instantiate() as Area2D
		new_platform.position = Vector2(randf_range(200, 840), initial_platform_y_position1)
		platform_container.add_child(new_platform)
		

func level_generator2(platform_gap, amount):
	var current_platforms = platform_container.get_children().size()

	if current_platforms >= max_platforms:
		return  # Jangan buat platform baru jika sudah terlalu banyak

	var weight = get_weight_for_level2(current_level)  # Ambil bobot berdasarkan level saat ini

	for i in range(amount):
		var new_type = weighted_random_choice(weight)
		initial_platform_y_position2 = initial_platform_y_position2 - platform_gap
		var new_platform

		if new_type == 0:
			new_platform = scene_platform[0].instantiate() as StaticBody2D
		elif new_type == 1:
			new_platform = scene_platform[1].instantiate() as StaticBody2D
		elif new_type == 2:
			new_platform = scene_platform[2].instantiate() as StaticBody2D
		elif new_type == 3:
			new_platform = scene_platform[3].instantiate() as StaticBody2D
		elif new_type == 4:
			new_platform = scene_platform[4].instantiate() as StaticBody2D
		elif new_type == 5:
			new_platform = scene_platform[5].instantiate() as StaticBody2D
		elif new_type == 6:
			new_platform = scene_platform[6].instantiate() as Area2D
		elif new_type == 7:
			new_platform = scene_platform[7].instantiate() as Area2D
		elif new_type == 8:
			new_platform = scene_platform[8].instantiate() as Area2D
		new_platform.position = Vector2(randf_range(200, 840), initial_platform_y_position2)
		platform_container.add_child(new_platform)
		
func level_generator3(platform_gap, amount):
	var current_platforms = item.get_children().size()

	if current_platforms >= max_platforms:
		return  # Jangan buat platform baru jika sudah terlalu banyak
	var weight = get_weight_for_level3(current_level)  # Ambil bobot berdasarkan level saat ini

	for i in range(amount):
		var new_type = weighted_random_choice(weight)
		initial_platform_y_position3 = initial_platform_y_position3 - platform_gap
		var new_platform

		if new_type == 0:
			new_platform = scene_platform[0].instantiate() as StaticBody2D
		elif new_type == 1:
			new_platform = scene_platform[1].instantiate() as StaticBody2D
		elif new_type == 2:
			new_platform = scene_platform[2].instantiate() as StaticBody2D
		elif new_type == 3:
			new_platform = scene_platform[3].instantiate() as StaticBody2D
		elif new_type == 4:
			new_platform = scene_platform[4].instantiate() as StaticBody2D
		elif new_type == 5:
			new_platform = scene_platform[5].instantiate() as StaticBody2D
		elif new_type == 6:
			new_platform = scene_platform[6].instantiate() as Area2D
		elif new_type == 7:
			new_platform = scene_platform[7].instantiate() as Area2D
		elif new_type == 8:
			new_platform = scene_platform[8].instantiate() as Area2D
		new_platform.position = Vector2(randf_range(-480, 488), initial_platform_y_position3)
		item.add_child(new_platform)

# Fungsi untuk memilih platform secara acak berdasarkan bobot
func weighted_random_choice(weights: Dictionary) -> int:
	var total_weight = 0.0
	for key in weights.keys():
		total_weight += weights[key]

	var random_weight = randf_range(0, total_weight)
	var cumulative_weight = 0.0
	for idx in range(weights.size()):
		cumulative_weight += weights[idx]
		if random_weight < cumulative_weight:
			return idx
	return 0
	


func _ready():
	if bgMusic.stream:
		print("Audio stream is valid:", bgMusic.stream)
		bgMusic.play()
	else:
		print("No audio stream assigned to bgMusic!")
	heartContainer.setMaxHearts(player.maxHealth)
	heartContainer.updateHearts(player.currentHealth)
	player.healthChanged.connect(heartContainer.updateHearts)
	randomize()
	level_generator1(500, 10)
	level_generator2(500, 20)
	level_generator3(500, 20)
	Global.checkpoint_position = Vector2()
	respawn_count = 0
	last_respawn_position = Vector2()
	Global.collect_stars
var score_updated_flag : bool = false

func _physics_process(delta):
	if player.position.y < camera.position.y:
		camera.position.y = player.position.y
	score_update() 
	star_update()
	check_level()
	
	if score >= 81000:
		spawn_boss_platform()
		score = 79999  # Batasi agar tidak terus memunculkan platform bos

func clear_all_platforms():   
	
	for platform in platform_container.get_children():     
		platform.queue_free()
	for items in item.get_children():
		items.queue_free()

func spawn_boss_platform():  
	clear_all_platforms()  # Hapus semua platform yang ada  
   # Spawn platform bos
	var boss_platform = scene_platform[9].instantiate()  # Ganti dengan PackedScene untuk platform bos   
	boss_platform.position = Vector2(get_viewport().get_visible_rect().size.x / 2, -100)  # Tengah atas layar  
	platform_container.add_child(boss_platform)
	# Update posisi kamera ke platform bos
	focus_camera_on(boss_platform)
	# Pindahkan player ke atas platform bos
# Spawn player di atas platform bos
	var player = get_node("Player")  # Pastikan path ke node pemain sesuai
	if player:
		# Dapatkan tinggi dari collider atau sprite pemain
		var player_height = 0
		if player.get_node_or_null("CollisionShape2D"):  # Jika menggunakan CollisionShape2D
			player_height = player.get_node("CollisionShape2D").shape.extents.y * 2
		elif player.get_node_or_null("Sprite2D"):  # Jika menggunakan Sprite2D
			player_height = player.get_node("Sprite2D").texture.get_size().y
		
		# Set posisi pemain tepat di atas platform bos
		player.position = boss_platform.position - Vector2(0, player_height + 10)  # Offset kecil untuk mencegah tabrakan
	
func focus_camera_on(target: Node2D):
	var camera = get_node("Camera2D")  # Pastikan path ke Camera2D benar
	if camera and camera is Camera2D:
		camera.position = target.position
		camera.offset = Vector2.ZERO  # Pastikan offset kamera diatur ke nol agar fokus langsung
		camera.make_current()  # Jadikan kamera ini aktif


# Fungsi untuk mengupdate skor berdasarkan posisi kamera (jika signal belum diterima)

func score_update():
	score = int(camera_initial_position - camera.position.y)
	score_label.text = str(score)
	
func star_update():
	var star_num = Global.collect_stars
	nunmStar.text = str(star_num)


func check_level():
	# Cek apakah Tree tersedia
	if get_tree() == null:
		print("SceneTree belum tersedia.")
		return
	for i in range(level_thresholds.size()):
		
		if score >= level_thresholds[i] and current_level == i + 1:
			
			current_level += 1
			
			_on_level_up(current_level)
	
	# Pindah ke final scene jika score > 55,000
func _on_level_up(new_level: int):
	# Perubahan untuk level baru
	match new_level:
		1:
			level_generator1(400, 2)
			level_generator2(400, 2)
			level_generator3(500, 2)
		2:
			level_generator1(400, 2)
			level_generator2(400, 2)
			level_generator3(500, 2)
		3:
			level_generator1(400, 2)
			level_generator2(400, 2)
			level_generator3(500, 2)
		4:
			level_generator1(400, 2)
			level_generator2(400, 2)
			level_generator3(500, 2)
		5:
			level_generator1(400, 2)
			level_generator2(400, 2)
			level_generator3(500, 2)
		6:
			level_generator1(400, 2)
			level_generator2(400, 2)
			level_generator3(500, 2)
		7:
			level_generator1(400, 2)
			level_generator2(400, 2)
			level_generator3(500, 2)
			
func respawn_player():
	if Global.checkpoint_position != null:  # Jika ada checkpoint
		player.position = Vector2(Global.checkpoint_position.x, Global.checkpoint_position.y)
		camera.position.y = player.position.y
		print("Respawning at checkpoint: ", Global.checkpoint_position)
	else:  # Jika tidak ada checkpoint
		print("No checkpoint found, respawning at start")
		player.position = initial_spawn_position  # Pastikan initial_spawn_position adalah Vector2

func _on_platform_eraser_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		if Global.checkpoint_position == null:  # Tidak ada checkpoint
			if score > Global.highscore:
				Global.highscore = score
			get_tree().change_scene_to_file("res://scenes/game_over.tscn")  # Mengubah scene ke game over
		else:  # Ada checkpoint, respawn player
			respawn_player()
			regenerate_at_checkpoint(400, 100)  # Mengenerate ulang level setelah respawn
	elif body.is_in_group('platform'):
		body.call_deferred("queue_free")
		print("Platform berhasil dihapus: ", body.name)
		level_generator1(400, 3)
		level_generator2(400, 3)
		level_generator3(500, 3) 
		
var respawn_count = 0
var last_respawn_position = Vector2()

func regenerate_at_checkpoint(platform_gap: float, amount: int) -> void:
	# Ambil posisi checkpoint sebagai acuan untuk memulai regenerasi platform
	var checkpoint_position = Global.checkpoint_position
	if checkpoint_position == Vector2():  # Periksa apakah posisi checkpoint adalah (0, 0)
		print("Tidak ada checkpoint yang ditemukan!") 
		if score > Global.highscore:
			Global.highscore = score
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		return

	var player_y_position = checkpoint_position.y  # Gunakan posisi y dari checkpoint untuk posisi awal platform
	
	# Cek apakah posisi respawn terlalu dekat dengan posisi sebelumnya
	if last_respawn_position.distance_to(checkpoint_position) < 50:  # 50 adalah jarak toleransi, sesuaikan sesuai kebutuhan
		respawn_count += 1
		print("Respawn count: ", respawn_count)
		if respawn_count >= 2:
			print("Terjadi terlalu banyak respawn di posisi yang sama!")
			if score > Global.highscore:
				Global.highscore = score
			get_tree().change_scene_to_file("res://scenes/game_over.tscn")
			return
	else:
		# Reset counter jika posisi berbeda jauh
		respawn_count = 0

	# Update posisi terakhir
	last_respawn_position = checkpoint_position

	# Ambil bobot berdasarkan level saat ini
	var weight = get_weight_for_level3(8)  # Ambil bobot berdasarkan level saat ini
	for i in range(amount):      
		var new_type = weighted_random_choice(weight)  # Pilih tipe platform berdasarkan bobot
		var new_platform    
		if new_type == 0:          
			new_platform = scene_platform[0].instantiate() as StaticBody2D
		elif new_type == 1: 
			new_platform = scene_platform[1].instantiate() as StaticBody2D 
		elif new_type == 2:
			new_platform = scene_platform[2].instantiate() as StaticBody2D
		elif new_type == 3:
			new_platform = scene_platform[3].instantiate() as StaticBody2D
		elif new_type == 4:   
			new_platform = scene_platform[4].instantiate() as StaticBody2D
		elif new_type == 5:
			new_platform = scene_platform[5].instantiate() as StaticBody2D
		elif new_type == 6:      
			new_platform = scene_platform[6].instantiate() as Area2D
		elif new_type == 7:   
			new_platform = scene_platform[7].instantiate() as Area2D
		elif new_type == 8:
			new_platform = scene_platform[8].instantiate() as Area2D
		var new_platform_y_position = player_y_position - (platform_gap * (i + 1))
		new_platform.position = Vector2(randf_range(200, 840), new_platform_y_position) 
		platform_container.add_child(new_platform)   
		print("Platform diregenerasi: ", new_platform.position)
