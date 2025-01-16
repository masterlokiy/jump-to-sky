extends Control

@onready var highscore_label = $Highscore
@onready var bgGameOver = $bgGameOver

func _ready() -> void:
	bgGameOver.play()

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_play_pressed() -> void:
	Global.collect_stars = 0
	get_tree().change_scene_to_file("res://scenes/game.tscn")
