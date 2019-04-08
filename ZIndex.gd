extends Node

const _RATE = 0.25
const _GR = 2000
const _M = _GR * _GR

func hack(s: Sprite):
	# You can set the "actual z index", if you want!
	var az = s.get("actual_z_index")
	var actual_z_index = az if az else 0.0

	var g = s.get_global_transform().get_origin().y + s.region_rect.size.y / 2 * s.scale.y
	var h = g * _RATE + actual_z_index
	var i = int(h * _GR) if h >= 0 else int((_GR - abs(h)) * _GR)
	var j: float = (i % _M) / _GR
	s.z_index = j
	s.z_as_relative = false
