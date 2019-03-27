extends Node2D

# adapted with inspiration from http://kidscancode.org/blog/2018/08/godot3_procgen1/
var max_offset_x = Global.world_width - 3  # in tiles
var max_offset_y = Global.world_height - 3 # in tiles
var min_width  =  3     # in tiles
var max_width  = 10     # in tiles
var min_height =  3     # in tiles
var max_height =  8     # in tiles


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
	var width = min_width + randi()%max_width
	var height = min_height + randi()%max_height
	var offset_x = randi()%max_offset_x
	var offset_y = randi()%max_offset_y	
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
	Cow.position.x = (tile_offset_x + 2 + randi()%(int(min(1,width-3)))) * TILE_SIZE
	Cow.position.y = (tile_offset_y + 1 + randi()%(height-2)) * TILE_SIZE
	
func animate_cow():
	var available_anims = $Animals/Cow/Sprite/AnimationPlayer.get_animation_list()
	$Animals/Cow/Sprite/AnimationPlayer.play(available_anims[randi()%available_anims.size()])


func place_area(tile_offset_x, tile_offset_y, num_tiles_x, num_tiles_y):
	var xy = Vector2(tile_offset_x * TILE_SIZE, tile_offset_y * TILE_SIZE)
	$Area2D.position = xy
	var shape: RectangleShape2D = $Area2D/CollisionShape2D.shape
	var sz = Vector2(TILE_SIZE * num_tiles_x, TILE_SIZE * num_tiles_y)
	shape.extents = sz
	var color_rect = $Area2D/ColorRect
	color_rect.rect_size = sz
	
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var fc = make_fence()
	var tile_offset_x = fc[0]
	var tile_offset_y = fc[1]
	var num_tiles_x = fc[2]
	var num_tiles_y = fc[3]
	place_cow(tile_offset_x, tile_offset_y, num_tiles_x, num_tiles_y)
	animate_cow()
	place_area(tile_offset_x, tile_offset_y, num_tiles_x, num_tiles_y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
