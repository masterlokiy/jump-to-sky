extends Panel

@onready var sprite = $Sprite2D  # 
func update(health: int) -> void:
	# Update sprite berdasarkan nilai health
	if health == Global.maxHealth:
		sprite.frame = 0  # Frame 0 untuk nyawa penuh
	elif health > 0:
		sprite.frame = 1  # Frame 2 untuk nyawa
