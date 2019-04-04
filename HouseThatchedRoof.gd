extends Node2D

var size = Vector2(196,196)

func _ready():
	var zone = ProcZoneRepo.assign_zone(size)
	self.position = zone.position