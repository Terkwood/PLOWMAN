extends Node2D

onready var horizontal_fence = preload("res://HorizontalFence.tscn")
onready var vertical_fence = preload("res://VerticalFence.tscn")
onready var ne_corner_fence = preload("res://NECornerFence.tscn")
onready var nw_corner_fence = preload("res://NWCornerFence.tscn")
onready var se_corner_fence = preload("res://SECornerFence.tscn")
onready var sw_corner_fence = preload("res://SWCornerFence.tscn")

	
onready var horizontal_fence_tile_size = (
horizontal_fence.instance().get_node("Sprite").get_region_rect().size
)

onready var vertical_fence_tile_size = (
vertical_fence.instance().get_node("Sprite").get_region_rect().size
)

func num_horizontal_tiles(size_x):
	return (
		size_x / horizontal_fence_tile_size.x
	) - 1

func num_vertical_tiles(size_y):
	return (
		size_y / vertical_fence_tile_size.y
	) - 1

onready var nes = ne_corner_fence.instance().get_node("Sprite").get_region_rect().size
onready var corner_fence_width_px = (
nes.x / 2
)
onready var corner_fence_height_px = (
nes.y
)

func procgen_fences(size):
	for x in range(num_horizontal_tiles(size.x)):
		var fence_top = horizontal_fence.instance()
		add_child(fence_top)
		fence_top.position = Vector2(
			x * horizontal_fence_tile_size.x  + corner_fence_width_px,
			0)
		var fence_bottom = horizontal_fence.instance()
		add_child(fence_bottom)
		fence_bottom.position = Vector2(
		x * horizontal_fence_tile_size.x + corner_fence_width_px,
			size.y)
	for y in range(num_vertical_tiles(size.y)):
		var fence_left = vertical_fence.instance()
		add_child(fence_left)
		fence_left.position = Vector2(
			0 ,
			y * vertical_fence_tile_size.y + corner_fence_height_px )
		var fence_right = vertical_fence.instance()
		add_child(fence_right)
		fence_right.position = Vector2(
			size.x,
			y * vertical_fence_tile_size.y  + corner_fence_height_px )

func place_corners(size):
	nw_corner_fence.instance().position = Vector2(0,0)
	ne_corner_fence.instance().position = Vector2(size.x,0)
	sw_corner_fence.instance().position = Vector2(0,size.y)
	se_corner_fence.instance().position = Vector2(size.x,size.y)

export var size = Vector2(128,128)

func _init(s):
	size = s
	
# Called when the node enters the scene tree for the first time.
func _ready():
	procgen_fences(size)
	place_corners(size)

