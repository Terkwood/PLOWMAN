extends Node

const RATE = 0.125

func hack(s: Sprite):
	# You can set the "actual z index", if you want!
	var az = s.get("actual_z_index")
	var actual_z_index = az if az else 0.0

	var g = s.get_global_transform().get_origin().y + s.region_rect.size.y / 2 * s.scale.y
	var h = g * RATE + actual_z_index
	if h < 0 && randi()%10 <3:
		print("hack %f" %  h )
	s.z_index = h
	s.z_as_relative = false
