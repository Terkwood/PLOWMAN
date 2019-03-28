extends Node2D

const WORLD_WIDTH_PX = Chunk.TILE_SIZE * Chunk.world_width
const WORLD_HEIGHT_PX = Chunk.TILE_SIZE * Chunk.world_height

#onready var ne_corner_fence = preload("res://NECornerFence.tscn")
#onready var nw_corner_fence = preload("res://NWCornerFence.tscn")
#onready var se_corner_fence = preload("res://SECornerFence.tscn")
#onready var sw_corner_fence = preload("res://SWCornerFence.tscn")
onready var horizontal_fence = preload("res://HorizontalFence.tscn")
onready var vertical_fence = preload("res://VerticalFence.tscn")
	
onready var horizontal_fence_tile_size = (
horizontal_fence.instance().get_node("Sprite").get_region_rect().size
)

onready var vertical_fence_tile_size = (
vertical_fence.instance().get_node("Sprite").get_region_rect().size
)

onready var num_horizontal_tiles = (
WORLD_WIDTH_PX / horizontal_fence_tile_size.x
) - 1

onready var num_vertical_tiles = (
WORLD_HEIGHT_PX / vertical_fence_tile_size.y
) - 1

onready var nes = $NECornerFence.get_node("Sprite").get_region_rect().size
onready var corner_fence_width_px = (
nes.x / 2
)
onready var corner_fence_height_px = (
nes.y
)

func procgen_fences():
	for x in range(num_horizontal_tiles):
		var fence_top = horizontal_fence.instance()
		add_child(fence_top)
		fence_top.position = Vector2(
			x * horizontal_fence_tile_size.x  + corner_fence_width_px,
			0)
		var fence_bottom = horizontal_fence.instance()
		add_child(fence_bottom)
		fence_bottom.position = Vector2(
		x * horizontal_fence_tile_size.x + corner_fence_width_px,
			WORLD_HEIGHT_PX)
	for y in range(num_vertical_tiles):
		var fence_left = vertical_fence.instance()
		add_child(fence_left)
		fence_left.position = Vector2(
			0 ,
			y * vertical_fence_tile_size.y + corner_fence_height_px )
		var fence_right = vertical_fence.instance()
		add_child(fence_right)
		fence_right.position = Vector2(
			WORLD_WIDTH_PX ,
			y * vertical_fence_tile_size.y  + corner_fence_height_px )

func place_corners():
	$NWCornerFence.position = Vector2(0,0)
	$NECornerFence.position = Vector2(WORLD_WIDTH_PX,0)
	$SWCornerFence.position = Vector2(0,WORLD_HEIGHT_PX)
	$SECornerFence.position = Vector2(WORLD_WIDTH_PX,WORLD_HEIGHT_PX)

# Called when the node enters the scene tree for the first time.
func _ready():
	procgen_fences()
	place_corners()

