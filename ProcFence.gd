extends Node2D

# adapted with inspiration from http://kidscancode.org/blog/2018/08/godot3_procgen1/

const min_width  =  5   # in tiles
const max_width  = 12   # in tiles
const min_height =  5   # in tiles
const max_height = 12   # in tiles
const max_offset_x = Chunk.num_tiles_x - min_width  # in tiles
const max_offset_y = Chunk.num_tiles_y - min_height # in tiles

const NW = 6
const NE = 8
const SW = 12
const SE = 14
const HORIZONTAL = 1
const VERTICAL = 4

# get a reference to the map for convenience
onready var Map = $TileMap
onready var Set = Map.tile_set
onready var Cow = $Animals/Cow

func tile(c):
	return Set.find_tile_by_name("fence_alt_"+str(c))

func make_fence():
	var offset_x = int(max(0, randi()%max_offset_x - min_width))
	var offset_y = int(max(0, randi()%max_offset_y - min_width))
	
	var width = int(min(Chunk.num_tiles_x - offset_x, min_width + randi()%max_width))
	var height = int(min(Chunk.num_tiles_y - offset_y, min_height + randi()%max_height))
	
	Map.set_cellv(
		Vector2(offset_x, offset_y),
		tile(NW)
	)
	Map.set_cellv(
		Vector2(offset_x + width - 1, offset_y),
		tile(NE))
	Map.set_cellv(
		Vector2(offset_x + width - 1, offset_y + height - 1),
		tile(SE)
	)
	Map.set_cellv(
		Vector2(offset_x, offset_y + height - 1),
		tile(SW)
	)
	for x in range(width-2):
		Map.set_cellv(
			Vector2(x + offset_x + 1, offset_y),
			tile(HORIZONTAL))
		Map.set_cellv(
			Vector2(x + offset_x + 1, offset_y + height - 1),
			tile(HORIZONTAL))
	for y in range(height-2):
		Map.set_cellv(
			Vector2(
				offset_x + width - 1,
				y + offset_y + 1),
			tile(VERTICAL))
		Map.set_cellv(
			Vector2(
				offset_x ,
				y + offset_y + 1),
			tile(VERTICAL))
	return [offset_x, offset_y, width, height]
	
const TILE_SIZE = 32
func place_cow(tile_offset_x, tile_offset_y, width, height):
	Cow.position.x = (tile_offset_x + 2 + randi()%(int(max(1,width-3)))) * TILE_SIZE
	Cow.position.y = (tile_offset_y + 1 + randi()%(height-2)) * TILE_SIZE
	
func animate_cow():
	var available_anims = $Animals/Cow/Sprite/AnimationPlayer.get_animation_list()
	$Animals/Cow/Sprite/AnimationPlayer.play(available_anims[randi()%available_anims.size()])

func _ready():
	randomize()
	var fc = make_fence()
	var tile_offset_x = fc[0]
	var tile_offset_y = fc[1]
	var num_tiles_x = fc[2]
	var num_tiles_y = fc[3]
	place_cow(tile_offset_x, tile_offset_y, num_tiles_x, num_tiles_y)
	animate_cow()
	ProcZoneRepo.try_add_proc_zone(Rect2(
		Vector2(tile_offset_x * TILE_SIZE, tile_offset_y * TILE_SIZE),
		Vector2(num_tiles_x * TILE_SIZE, num_tiles_y * TILE_SIZE)))
