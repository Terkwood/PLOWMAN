extends Node2D

onready var auto_corn = preload("res://AutoCorn.tscn")
onready var auto_corn2 = preload("res://AutoCorn2.tscn")
onready var auto_corn3 = preload("res://AutoCorn3.tscn")
onready var auto_corn4 = preload("res://AutoCorn4.tscn")
onready var auto_corn_young = preload("res://AutoCornYoung.tscn")
	
onready var corns = [auto_corn, auto_corn2, auto_corn3, auto_corn4, auto_corn_young]
onready var corn_tile_size = auto_corn4.instance().get_node("Sprite").get_region_rect().size

const min_width  =   1     # in tiles
var max_width  =  int(min(20,Global.world_width * 0.33))      # in tiles
const min_height =   1     # in tiles
var max_height =  int(min(20, Global.world_height * 0.33))     # in tiles


# in tiles
func max_offset_x(w):
	var rem = Global.TILE_SIZE / corn_tile_size.x  * Global.world_width - w
	return int(rem * corn_tile_size.x)
# in tiles  
func max_offset_y(h):
	var rem = Global.TILE_SIZE / corn_tile_size.y  * Global.world_height - h
	return int(rem * corn_tile_size.y )


func make_corn():
	var width = max(min_width, randi()%max_width)
	var height = max(min_height, randi()%max_height)
	var offset_x = randi()%max_offset_x(width)
	var offset_y = randi()%max_offset_y(height)
	var rand_corn = corns[randi()%corns.size()]
	for x in range(width):
		for y in range(height):
			var corn = rand_corn.instance()
			add_child(corn)
			corn.position = Vector2(
				(x * corn_tile_size.x + offset_x) ,
				(y * corn_tile_size.y + offset_y) )
	return [Vector2(offset_x, offset_y), Vector2(width, height)]
		
func place_area(offset_px, width_height):
	print("hallo offset")
	print(str(offset_px))
	var size_px = width_height * corn_tile_size
	$Area2D.position = offset_px
	var collision_shape: RectangleShape2D = $Area2D/CollisionShape2D.shape
	collision_shape.extents = size_px
	$Area2D/ColorRect.rect_size = size_px

func _ready():
	var corn_placement = make_corn()
	print("HALLO CORN")
	print(str(corn_placement))
	place_area(corn_placement[0], corn_placement[1])

