extends CanvasModulate

const day_duration_minutes = 10
const day_duration_real_seconds = 60 * 60 * day_duration_minutes

enum { NIGHT, DAWN, DAY, DUSK }

const PERIOD_START = {
	NIGHT: 22,
	DAWN: 5,
	DAY: 8,
	DUSK: 19,
}

const game_start_hour = 5 # 24 hours time (0-23)
var day_start_number = 1

var color_dawn = Color(0.86, 0.70, 0.70, 1.0)
var color_day = Color(1.0, 1.0, 1.0, 1.0)
var color_dusk = Color(0.59, 0.66, 0.78, 1.0)
var color_night = Color(0.07, 0.09, 0.38, 1.0)


var current_time
var current_day_hour
var current_day_number

var transition_duration
var transition_duration_time = 1 # In hours

var period

func is_night():
	return current_day_hour >= PERIOD_START[NIGHT] or current_day_hour <= PERIOD_START[DAWN]
func is_dawn():
	return current_day_hour >= PERIOD_START[DAWN] and current_day_hour <= PERIOD_START[DAY]
func is_day():
	return current_day_hour >= PERIOD_START[DAY] and current_day_hour <= PERIOD_START[DUSK]
func is_dusk():
	return current_day_hour >= PERIOD_START[DUSK] and current_day_hour <= PERIOD_START[NIGHT]

func _ready():
	current_day_number = day_start_number
	current_time = (day_duration_real_seconds / 24) * game_start_hour
	current_day_hour = current_time / (day_duration_real_seconds / 24)
	
	transition_duration = (((day_duration_real_seconds / 24) * transition_duration_time) / 60)
	
	if is_night():
		period = NIGHT
		color = color_night
	elif is_dawn():
		period = DAWN
		color = color_dawn
	elif is_day():
		period = DAY
		color = color_day
	elif is_dusk():
		period = DUSK
		color = color_dusk


func _physics_process(delta):
	current_day_hour = current_time / (day_duration_real_seconds / 24)
	
	if current_time >= day_duration_real_seconds:
		current_time = 0
		current_day_hour = 0
		current_day_number += 1
		
	if is_night():
		update_period(NIGHT)
	elif is_dawn():
		update_period(DAWN)
	elif is_day():
		update_period(DAY)
	elif is_dusk():
		update_period(DUSK)

	current_time += 1

func update_period(new_period):
	if period != new_period:
		period = new_period

		if period == NIGHT:
			$Tween.interpolate_property(self, "color", color_dusk, color_night, transition_duration, Tween.TRANS_SINE, Tween.EASE_OUT)
			$Tween.start()
			
		if period == DAWN:
			$Tween.interpolate_property(self, "color", color_night, color_dawn, transition_duration, Tween.TRANS_SINE, Tween.EASE_OUT)
			$Tween.start()
	
		if period == DAY:
			$Tween.interpolate_property(self, "color", color_dawn, color_day, transition_duration, Tween.TRANS_SINE, Tween.EASE_OUT)
			$Tween.start()
	
		if period == DUSK:
			$Tween.interpolate_property(self, "color", color_day, color_dusk, transition_duration, Tween.TRANS_SINE, Tween.EASE_OUT)
			$Tween.start()
