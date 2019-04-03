extends Node

const RATE = 0.25

func hack(s: Sprite):
	# You can set the "actual z index", if you want!
	var az = s.get("actual_z_index")
	var actual_z_index = az if az else 0.0

	var g = s.get_global_transform().get_origin().y + s.region_rect.size.y / 2 * s.scale.y
	s.z_index=g * RATE + actual_z_index
