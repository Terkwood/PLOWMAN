extends Node2D

# in tiles
func max_offset_x(w, corn_size_x):
	return int((Global.world_width - w) * Global.TILE_SIZE / corn_size_x)
# in tiles  
func max_offset_y(h, corn_size_y):
	return int((Global.world_height - h) * Global.TILE_SIZE / corn_size_y)
var min_width  =   1     # in tiles
var max_width  =  20     # in tiles
var min_height =   1     # in tiles
var max_height =  20     # in tiles

onready var auto_corn = preload("res://AutoCorn.tscn")
onready var auto_corn2 = preload("res://AutoCorn2.tscn")
onready var auto_corn3 = preload("res://AutoCorn3.tscn")
onready var auto_corn4 = preload("res://AutoCorn4.tscn")
onready var auto_corn_young = preload("res://AutoCornYoung.tscn")
	
onready var corns = [auto_corn, auto_corn2, auto_corn3, auto_corn4, auto_corn_young]

func make_corn():
	var width = min_width + randi()%max_width
	var height = min_height + randi()%max_height
	
	var tile_size = auto_corn.instance().get_node("Sprite").get_region_rect().size
	var offset_x = randi()%max_offset_x(width, tile_size.x)  / 2
	var offset_y = randi()%max_offset_y(height, tile_size.y) / 2 # TODO hacked

	var rand_corn = corns[randi()%corns.size()]
	for x in range(width):
		for y in range(height):
			var corn = rand_corn.instance()
			add_child(corn)
			corn.position = Vector2((x + offset_x) * tile_size.x, (y + offset_y) * tile_size.y)
			
func _ready():
	make_corn()

