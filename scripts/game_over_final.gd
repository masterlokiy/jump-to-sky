extends Control

@onready var highscore_label = $Highscore
@onready var start_button = $start
@onready var bgGameOver = $bgGameOver

func _ready() -> void:
	bgGameOver.play()
	start_button.grab_focus()

func _on_start_pressed() -> void:
	Global.collect_stars = 0
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
