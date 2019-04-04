extends Node2D

# inspired by http://kidscancode.org/blog/2018/08/godot3_procgen1/
var width = Chunk.num_tiles_x   # in tiles
var height = Chunk.num_tiles_y # in tiles

# get a reference to the map for convenience
onready var Map = $TileMap

onready var chunk_id: Vector2 = Chunk.id(self)

onready var offset: Vector2 = chunk_id * Vector2(width, height)

func rand_tile_id():
	# tiles 4-7 are basic grass tiles
	return rand_range(4,7)

func make_field():
	print("field offset %s " % offset)
	print("     eg      %s " % str(Vector2(1,1) + offset))
	for x in range(width):
		for y in range(height):
			var p = Vector2(x,y) + offset
			Map.set_cellv(p, rand_tile_id())

func _ready():
	print("field chunk id %s" % chunk_id)
	make_field()
