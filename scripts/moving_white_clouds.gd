extends AnimatableBody2D

var direction = 1  # Arah gerakan (1 untuk kanan, -1 untuk kiri)
var speed = 500  # Kecepatan gerakan (piksel per detik)
var screen_width = 0  # Lebar layar

@onready var animated_sprite = $Sprite2D

func _ready() -> void:
	# Dapatkan lebar layar
	screen_width = get_viewport_rect().size.x

	# Periksa apakah posisi awal berada di luar batas
	if position.x > screen_width:
		position.x = screen_width  # Pastikan di dalam batas
		direction = -1  # Ubah arah ke kiri
		animated_sprite.flip_h = true  # Membalikkan sprite untuk arah kiri
	elif position.x < 0:
		position.x = 0  # Pastikan di dalam batas
		direction = 1  # Ubah arah ke kanan
		animated_sprite.flip_h = false  # Tidak membalikkan sprite untuk arah kanan
	else:
		# Tentukan arah berdasarkan posisi awal
		direction = 1 if position.x < screen_width / 2 else -1
		animated_sprite.flip_h = direction == -1  # Sesuaikan flip berdasarkan posisi awal

func _physics_process(delta: float) -> void:
	# Tambahkan gerakan berdasarkan kecepatan dan arah
	position.x += direction * speed * delta

	# Periksa jika objek melewati batas
	if position.x > screen_width:
		position.x = screen_width  # Kembalikan ke batas
		direction = -1  # Ubah arah ke kiri
		animated_sprite.flip_h = true  # Flip untuk arah kiri
	elif position.x < 0:
		position.x = 0  # Kembalikan ke batas
		direction = 1  # Ubah arah ke kanan
		animated_sprite.flip_h = false  # Tidak flip untuk arah kanan
