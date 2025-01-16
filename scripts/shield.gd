extends Area2D


@onready var collected = $AnimatedSprite2D2
@onready var sfx_shield = $sfx_shield

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		collected.play('collect')
		body.activate_shield()

func _on_animated_sprite_2d_2_animation_finished() -> void:
	if collected.animation == "collect":
			queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
