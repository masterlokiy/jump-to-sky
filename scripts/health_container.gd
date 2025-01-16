extends HBoxContainer

@onready var HearthGUIClass = preload("res://scenes/health_gui.tscn")

func setMaxHearts(max: int) :
	for i in range (max):
		var heart = HearthGUIClass.instantiate()
		add_child(heart)
		
func updateHearts(currentHealth: int):
	var hearts = get_children()
	
	for i in range (currentHealth):
		hearts[i].update(false)
		
	for i in range (currentHealth, hearts.size()):
		hearts[i].update(true)
