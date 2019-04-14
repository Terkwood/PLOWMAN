extends Node2D

var young = null
var growing = null
var growing2 = null
var mature = null
var harvested = null

onready var stages = [young, growing, growing2, mature]

func _sprite_size(stage_num):
	return stages[stage_num].instance().get_node("Sprite").get_region_rect().size

const _TILE_BUFFER = Vector2(8,8)
func _tile_size(stage_num):
	var sprite_sz = _sprite_size(stage_num)
	return Vector2(sprite_sz.x + _TILE_BUFFER.x, sprite_sz.y + _TILE_BUFFER.y)

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

onready var _dirt_tile_id = tile_map.tile_set.find_tile_by_name("dirt_center")
onready var _corner_nw_tile_id = tile_map.tile_set.find_tile_by_name("grass_dirt_nw")
onready var _corner_ne_tile_id = tile_map.tile_set.find_tile_by_name("grass_dirt_ne")
onready var _corner_sw_tile_id = tile_map.tile_set.find_tile_by_name("grass_dirt_sw")
onready var _corner_se_tile_id = tile_map.tile_set.find_tile_by_name("grass_dirt_se")
onready var _edge_n_tile_id = tile_map.tile_set.find_tile_by_name("grass_dirt_n")
onready var _edge_e_tile_id = tile_map.tile_set.find_tile_by_name("grass_dirt_e")
onready var _edge_s_tile_id = tile_map.tile_set.find_tile_by_name("grass_dirt_s")
onready var _edge_w_tile_id = tile_map.tile_set.find_tile_by_name("grass_dirt_w")

func _draw_dirt(zone: Rect2):
	tile_map.set_cell_size(Vector2(Chunk.TILE_SIZE, Chunk.TILE_SIZE))
	var size = zone.size
	var offset_x = floor(zone.position.x / Chunk.TILE_SIZE)
	var offset_y = floor(zone.position.y / Chunk.TILE_SIZE)
	var num_tiles_x = floor(size.x / Chunk.TILE_SIZE)
	var num_tiles_y = floor(size.y / Chunk.TILE_SIZE)

	# draw corners
	tile_map.set_cellv(Vector2(offset_x - 1, offset_y - 1), _corner_nw_tile_id)
	tile_map.set_cellv(Vector2(offset_x - 1+ num_tiles_x, offset_y - 1), _corner_ne_tile_id)
	tile_map.set_cellv(Vector2(offset_x - 1, offset_y - 1 + num_tiles_y ), _corner_sw_tile_id)
	tile_map.set_cellv(Vector2(offset_x - 1 + num_tiles_x, offset_y - 1 + num_tiles_y), _corner_se_tile_id)

	# draw edges
	for x in range(num_tiles_x - 1):
		tile_map.set_cellv(Vector2(offset_x + x , offset_y - 1), _edge_n_tile_id)
		tile_map.set_cellv(Vector2(offset_x + x , offset_y + num_tiles_y - 1), _edge_s_tile_id)
	for y in range(num_tiles_y - 1):
		tile_map.set_cellv(Vector2(offset_x - 1 , offset_y + y), _edge_w_tile_id)
		tile_map.set_cellv(Vector2(offset_x - 1 + num_tiles_x , offset_y + y), _edge_e_tile_id)

	# draw middle
	for x in range(num_tiles_x - 1):
		for y in range(num_tiles_y - 1):
			tile_map.set_cellv(Vector2(offset_x + x ,offset_y + y ), _dirt_tile_id)


func place(zone: Rect2, stage_num: int):
	var stage_tile_size = _tile_size(stage_num)
	var num_plants_x = max(0,floor(zone.size.x / stage_tile_size.x) - 1)
	var num_plants_y = max(0,floor(zone.size.y / stage_tile_size.y) - 1)
	
	var stage = stages[stage_num]
	for x in num_plants_x:
		for y in num_plants_y:
			var plant = stage.instance()
			plant.position.x = zone.position.x + x * stage_tile_size.x
			plant.position.y = zone.position.y + y * stage_tile_size.y
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
	_draw_dirt(zone)

