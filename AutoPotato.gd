extends Node2D

onready var young = preload("res://PotatoYoung.tscn")
onready var growing = preload("res://PotatoGrowing.tscn")
onready var growing2 = preload("res://PotatoGrowing2.tscn")
onready var mature = preload("res://PotatoMature.tscn")
onready var harvested = preload("res://PotatoHarvested.tscn")
onready var produce = preload("res://PotatoProduce.tscn")

onready var stages = [young, growing, growing2, mature, harvested, produce]
onready var sprite_size = mature.instance().get_node("Sprite").get_region_rect().size
const TILE_BUFFER = Vector2(8,8)
onready var tile_size = Vector2(sprite_size.x + TILE_BUFFER.x, sprite_size.y + TILE_BUFFER.y)

var size = Vector2(128,128)

func _init(s: Vector2):
	size = s

# Called when the node enters the scene tree for the first time.
func _ready():
	print("potatoes with size " + str(size))
	var zone = ProcZoneRepo.assign_zone(size)
	var num_potatoes_x = max(0,floor(zone.size.x / tile_size.x) - 1)
	var num_potatoes_y = max(0,floor(zone.size.y / tile_size.y) - 1)
	
	
	var stage = stages[randi()%stages.size()]
	for x in num_potatoes_x:
		for y in num_potatoes_y:
			var potato = stage.instance()
			potato.position.x = zone.position.x + x * tile_size.x
			potato.position.y = zone.position.y + y * tile_size.y
			get_parent().add_child(potato)
	
