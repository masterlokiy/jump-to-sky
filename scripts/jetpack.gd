extends Area2D

@onready var collected_sprite = $AnimatedSprite2D2
const SPRING_JUMP_VELOCITY = -8000.0 

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.velocity.y = SPRING_JUMP_VELOCITY
		# Mainkan animasi collect (opsional)
		collected_sprite.play("collect")
		body.jetpack()

func _on_animated_sprite_2d_2_animation_finished() -> void:
	if collected_sprite.animation == "collect":
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
