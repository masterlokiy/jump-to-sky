extends StaticBody2D

# Dipanggil saat node masuk ke scene tree untuk pertama kali.
func _ready() -> void:
	pass  # Ganti jika ada logika inisialisasi.

# Dipanggil setiap frame. 'delta' adalah waktu yang berlalu sejak frame sebelumnya.
func _process(delta: float) -> void:
	pass  # Ganti jika ada logika pemrosesan setiap frame.

# Fungsi yang dipanggil saat Area2D mendeteksi pemain masuk.
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://scenes/final.tscn")
