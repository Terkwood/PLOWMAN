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
onready var chunk_id = Chunk.id(self)
onready var stage_num = randi()%stages.size()

var tile_map: TileMap = null

# You need to supply the expected array of preloads,
# or we'll fail gloriously at runtime.  See below.
func _init(s: Vector2, preloads, tile_map: TileMap):
	size = s
	young = preloads[0]
	growing = preloads[1]
	growing2 = preloads[2]
	mature = preloads[3]
	harvested = preloads[4]
	self.tile_map = tile_map

var _manifest = {}
func manifest():
	return _manifest

func set_manifest(mfst: Dictionary):
	self._manifest = mfst

func _set_cell_size():
	tile_map.set_cell_size(Vector2(Chunk.TILE_SIZE, Chunk.TILE_SIZE))

onready var _dirt_tile_id = tile_map.tile_set.find_tile_by_name("dirt_varied")

func _draw_dirt(size: Vector2):
	for x in range(size.x / Chunk.TILE_SIZE):
		for y in range(size.y / Chunk.TILE_SIZE):
			tile_map.set_cellv(Vector2(x,y), _dirt_tile_id)


func place(zone: Rect2, stage_num: int):
	var num_plants_x = max(0,floor(zone.size.x / tile_size.x) - 1)
	var num_plants_y = max(0,floor(zone.size.y / tile_size.y) - 1)
	
	var stage = stages[stage_num]
	for x in num_plants_x:
		for y in num_plants_y:
			var plant = stage.instance()
			plant.position.x = zone.position.x + x * tile_size.x
			plant.position.y = zone.position.y + y * tile_size.y
			get_parent().add_child(plant)
	var mf = StorageManifest.size_position_manifest(zone)
	mf["stage_num"] = stage_num
	self.set_manifest(mf)

# Called when the node enters the scene tree for the first time.
func _ready():
	var manifest_exists = _manifest && !_manifest.empty()
	var mf_entry = StorageManifest.find_entry(self, _manifest)
	var zone: Rect2 = Rect2(0,0,0,0)
	if !mf_entry.empty():	
		var size = Vector2(mf_entry["size_x"], mf_entry["size_y"])
		var pos = Vector2(mf_entry["position_x"], mf_entry["position_y"])
		zone = Rect2(pos, size)
		ProcZoneRepo.force_assign_zone(zone, chunk_id)
		self.stage_num = mf_entry["stage_num"]
	else:
		zone = ProcZoneRepo.assign_zone(size, chunk_id)
		_manifest = {}
		_manifest["position_x"] = zone.position.x
		_manifest["position_y"] = zone.position.y
		_manifest["size_x"] = zone.size.x
		_manifest["size_y"] = zone.size.y
		_manifest["stage_num"] = stage_num
	place(zone, stage_num)
	# Draw some dirt
	_set_cell_size()
	_draw_dirt(size)

