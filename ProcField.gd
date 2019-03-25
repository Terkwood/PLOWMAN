extends Node2D

# from http://kidscancode.org/blog/2018/08/godot3_procgen1/
var width = Global.world_width   # in tiles
var height = Global.world_height # in tiles

# get a reference to the map for convenience
onready var Map = $TileMap

func rand_tile_id():
	return rand_range(4,7)

func make_field():
	print("field size x " + str(Map.tile_set.tile_get_region(4).size.x))
	print("field size y " + str(Map.tile_set.tile_get_region(4).size.y))
	for x in range(width):
		for y in range(height):
			Map.set_cellv(Vector2(x,y), rand_tile_id())

# Called when the node enters the scene tree for the first time.
func _ready():
	make_field()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
