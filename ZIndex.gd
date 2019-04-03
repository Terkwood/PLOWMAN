extends Node

func hack(s: Sprite):
	var g = s.get_global_transform().get_origin().y + s.region_rect.size.y / 2 * s.scale.y
	s.z_index=g
