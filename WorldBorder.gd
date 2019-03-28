extends Node2D

onready var horizontal_fence = preload("res://HorizontalFence.tscn")
onready var vertical_fence = preload("res://VerticalFence.tscn")
	
onready var horizontal_fence_tile_size = (
horizontal_fence.instance().get_node("Sprite").get_region_rect().size
)

onready var vertical_fence_tile_size = (
vertical_fence.instance().get_node("Sprite").get_region_rect().size
)

onready var num_horizontal_tiles = (
Chunk.width() / horizontal_fence_tile_size.x
) - 1

onready var num_vertical_tiles = (
Chunk.height() / vertical_fence_tile_size.y
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
			Chunk.height())
	for y in range(num_vertical_tiles):
		var fence_left = vertical_fence.instance()
		add_child(fence_left)
		fence_left.position = Vector2(
			0 ,
			y * vertical_fence_tile_size.y + corner_fence_height_px )
		var fence_right = vertical_fence.instance()
		add_child(fence_right)
		fence_right.position = Vector2(
			Chunk.width() ,
			y * vertical_fence_tile_size.y  + corner_fence_height_px )

func place_corners():
	$NWCornerFence.position = Vector2(0,0)
	$NECornerFence.position = Vector2(Chunk.width(),0)
	$SWCornerFence.position = Vector2(0,Chunk.height())
	$SECornerFence.position = Vector2(Chunk.width(),Chunk.height())

# Called when the node enters the scene tree for the first time.
func _ready():
	procgen_fences()
	place_corners()

