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

onready var Map = $TileMap

var corn_types = ["plants_corn_young",
	"plants_corn",
	"plants_corn2",
	"plants_corn3",
	"plants_corn4"]
	
onready var auto_corn = preload("res://AutoCorn.tscn")
	
func make_corn():
	#var corn_type = Map.tile_set.find_tile_by_name(corn_types[randi()%corn_types.size()])
	var width = min_width + randi()%max_width
	var height = min_height + randi()%max_height
	
	#TODO clean
	#var tile_size = Map.tile_set.tile_get_region(corn_type).size
	var tile_size = $AutoCorn.get_node("Sprite").get_region_rect().size
	print("corn size x " + str(tile_size.x))
	print("corn size y " + str(tile_size.y))
	$AutoCorn.position.x = 100
	var offset_x = randi()%max_offset_x(width, tile_size.x) / 8  # TODO hacked
	var offset_y = randi()%max_offset_y(height, tile_size.y) / 8 # TODO hacked
	print("corn offset_x " + str(offset_x) + " offset_y " + str(offset_y))

	for x in range(width):
		for y in range(height):
			#print("corn width height " + str(x) + " " + str(y))
			var corn = auto_corn.instance()
			add_child(corn)
			#corn.position = Vector2((x + offset_x) * tile_size.x, (y + offset_y) * tile_size.y)
			corn.position.x = x * 64
			corn.position.y = y * 64
			print("corn pos x y " + str(corn.position.x) + " " + str(corn.position.y))
			#Map.set_cellv(
			#Vector2(x + offset_x, y + offset_y),
			#corn_type)

# Called when the node enters the scene tree for the first time.
func _ready():
	make_corn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
