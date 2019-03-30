extends KinematicBody2D

enum Movement { STOP, GO }

const FREQ = 0.5
const MIN_SPEED = 50
const MAX_SPEED = 250

var dir = Vector2(1,0).normalized()
var mv = Movement.STOP
var out_of_bounds = false

var timestamp = 0

func opposite(d: Vector2):
	return d * -1

func _ready():
	ZIndex.hack(self.position.y, $Sprite, $Sprite)
	move_and_slide(Vector2(300,0), Vector2())

func move():
	print("chicken move, oob = " + str(out_of_bounds))
	print("curr dir " + str(dir))
	print("dv  " + str(dir))
	if out_of_bounds:
		# don't change course until you're in bounds
		move_and_slide(dir * MAX_SPEED, Vector2())
	else:
		move_and_slide(dir * rand_range(MIN_SPEED, MAX_SPEED), Vector2())
	
func _physics_process(delta):
	timestamp = timestamp + delta
	if timestamp > FREQ:
		move()
		timestamp = 0

var last_position_y = self.position.y
func _process(_delta):
	if self.position.y != last_position_y:
		last_position_y = self.position.y
		ZIndex.hack(self.position.y, $Sprite, $Sprite)

func i_am(body: KinematicBody2D):
	return body && body.get_instance_id() == get_instance_id()
	
func _on_Area2D_body_exited(body: KinematicBody2D):
	if i_am(body):
		print("now " + str(dir))
		dir = opposite(dir)
		print("then " + str(dir))
		mv = Movement.GO
		out_of_bounds = true
		print("new dir " + str(dir))

func _on_Area2D_body_entered(body):
	if i_am(body):
		out_of_bounds = false
		
