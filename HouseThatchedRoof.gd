extends Node2D

var size = Vector2(196,196)

func _ready():
	var zone = ProcZoneRepo.assign_zone(size)
	self.position = zone.position
	print("house parent is    %s" % get_parent())
	print("house  chunk id is %d" % Chunk.id(self))
