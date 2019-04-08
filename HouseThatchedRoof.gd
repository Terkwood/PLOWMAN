extends Node2D

var size = Vector2(196,196)

onready var chunk_id = Chunk.id(self)

var _incoming_manifest = {}
func set_manifest(mf: Dictionary):
	_incoming_manifest = mf

func manifest():
	return StorageManifest.position_manifest(self)

func _ready():
	var zone = StorageManifest.find_zone(self, _incoming_manifest)
	if zone == StorageManifest.NO_ZONE:
		zone = ProcZoneRepo.assign_zone(size, chunk_id)
	else:
		ProcZoneRepo.force_assign_zone(zone, chunk_id)
	self.position = zone.position
