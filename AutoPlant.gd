extends Node2D

var young = null
var growing = null
var growing2 = null
var mature = null
var harvested = null

onready var stages = [young, growing, growing2, mature, harvested]

onready var sprite_size = mature.instance().get_node("Sprite").get_region_rect().size
const TILE_BUFFER = Vector2(8,8)
onready var tile_size = Vector2(sprite_size.x + TILE_BUFFER.x, sprite_size.y + TILE_BUFFER.y)

var size = Vector2(128,128)

# You need to supply the expected array of preloads,
# or we'll fail gloriously at runtime.  See below.
func _init(s: Vector2, preloads):
	size = s
	young = preloads[0]
	growing = preloads[1]
	growing2 = preloads[2]
	mature = preloads[3]
	harvested = preloads[4]

# Called when the node enters the scene tree for the first time.
func _ready():
	var zone = ProcZoneRepo.assign_zone(size)
	var num_plants_x = max(0,floor(zone.size.x / tile_size.x) - 1)
	var num_plants_y = max(0,floor(zone.size.y / tile_size.y) - 1)
	
	var stage = stages[randi()%stages.size()]
	for x in num_plants_x:
		for y in num_plants_y:
			var plant = stage.instance()
			plant.position.x = zone.position.x + x * tile_size.x
			plant.position.y = zone.position.y + y * tile_size.y
			get_parent().add_child(plant)
	
