extends Node2D

@export var items_scene: Array[PackedScene]  # Array untuk menyimpan scene item yang akan di-spawn
@onready var ufo = $StaticBody2D/ufo# Referensi ke node UFO
@onready var spawn_timer = $SpawnTimer  # Pastikan ada Timer node bernama "SpawnTimer" di scene
@onready var heartContainer = $CanvasLayer/healthContainer
@onready var heartContainer2 = $CanvasLayer/healthContainer2
@onready var player = $StaticBody2D/Player
@onready var stars = Global.collect_stars
@onready var bgBoss = $bgBoss


func _physics_process(delta: float) -> void:
	Global.ufo_position = ufo.global_position
	if ufo.currentHealth <= 0:
		if stars < 10:    
			get_tree().change_scene_to_file("res://scenes/menang_bronze.tscn")
		elif stars >= 10 and stars <= 15:   
			get_tree().change_scene_to_file("res://scenes/menang_silver.tscn")
		elif stars > 15:
			get_tree().change_scene_to_file("res://scenes/menang_gold.tscn")
		
func _ready() -> void:
	bgBoss.play()
	print(ufo.currentHealth)
	heartContainer.setMaxHearts(player.maxHealth)
	heartContainer.updateHearts(player.currentHealth)
	player.healthChanged.connect(heartContainer.updateHearts)
	
	heartContainer2.setMaxHearts(ufo.maxHealth)
	heartContainer2.updateHearts(ufo.currentHealth)
	ufo.healthChanged.connect(heartContainer2.updateHearts)
	print(ufo.currentHealth)
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	if items_scene.size() == 0:
		return  # Pastikan ada item yang bisa di-spawn
	
	# Instance item secara acak dari array
	var random_item_scene = items_scene[randi() % items_scene.size()]
	var item = random_item_scene.instantiate()
	add_child(item)
	
	# Cari node spawn secara acak dari grup "spawn"
	var spawn_nodes = get_tree().get_nodes_in_group("spawn")
	if spawn_nodes.size() == 0:
		return  # Pastikan ada node spawn
	var spawn_node = spawn_nodes[randi() % spawn_nodes.size()]
	
	# Set posisi item di posisi spawn
	item.position = spawn_node.position
