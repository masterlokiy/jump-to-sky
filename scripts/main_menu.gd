extends Control

var game_scene = preload("res://scenes/game.tscn")
@onready var bgMainmenu = $bgMainmenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bgMainmenu.play()

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn") 
