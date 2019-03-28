extends Node2D

onready var auto_corn = preload("res://AutoCorn.tscn")
onready var auto_corn2 = preload("res://AutoCorn2.tscn")
onready var auto_corn3 = preload("res://AutoCorn3.tscn")
onready var auto_corn4 = preload("res://AutoCorn4.tscn")
onready var auto_corn_young = preload("res://AutoCornYoung.tscn")

onready var corns = [auto_corn, auto_corn2, auto_corn3, auto_corn4, auto_corn_young]
onready var corn_tile_size = auto_corn4.instance().get_node("Sprite").get_region_rect().size

const min_width  =   1     # in tiles
var max_width  =  int(min(20,Chunk.world_width * 0.33))      # in tiles
const min_height =   1     # in tiles
var max_height =  int(min(20, Chunk.world_height * 0.33))     # in tiles

export var proc_zone = Rect2(0,0,0,0)

# returns px
func max_offset_x(w):
	var rem = Chunk.TILE_SIZE / corn_tile_size.x  * Chunk.world_width - w
	return int(rem * corn_tile_size.x)
# returns px
func max_offset_y(h):
	var rem = Chunk.TILE_SIZE / corn_tile_size.y  * Chunk.world_height - h
	return int(rem * corn_tile_size.y )

func gen_candidate_zone():
	var width = max(min_width, randi()%max_width)
	var height = max(min_height, randi()%max_height)
	var offset_x = randi()%max_offset_x(width)
	var offset_y = randi()%max_offset_y(height)
	return {
		"rect": Rect2(
				Vector2(offset_x, offset_y),
				Vector2(width * corn_tile_size.x,
						height * corn_tile_size.y)),
	 	"width_in_tiles": width,
		"height_in_tiles":height
	}

func gen_zone():
	var c = gen_candidate_zone()
	while !ProcZoneRepo.try_add_proc_zone(c["rect"]):
		print ("corn gen")
		c = gen_candidate_zone()
	print("corn added " + str(c))
	return c

func make_corn():
	var zone = gen_zone()
	var rand_corn = corns[randi()%corns.size()]
	for x in range(zone["width_in_tiles"]):
		for y in range(zone["height_in_tiles"]):
			var corn = rand_corn.instance()
			add_child(corn)
			add_to_group("proc_corn")
			corn.position = Vector2(
				(x * corn_tile_size.x + zone["rect"].position.x) ,
				(y * corn_tile_size.y + zone["rect"].position.y) )
	return zone["rect"]

func _ready():
	proc_zone = make_corn()
