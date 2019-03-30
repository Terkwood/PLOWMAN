extends KinematicBody2D

const FREQ = 0.3
const MIN_SPEED = 150
const MAX_SPEED = 325
const MIN_STEPS = 3
const MAX_STEPS = 11

var dir = Vector2(1,0).normalized()
var steps = 0
var out_of_bounds = false

var timestamp = 0

func opposite(d: Vector2):
	return d * -1

const GO_RATE = 0.33
func random_steps():
	if randf() <= GO_RATE:
		return MIN_STEPS + randi()%(MAX_STEPS - MIN_STEPS)
	else:
		return 0

const POSSIBLE_DIRS = [
	Vector2(1,0),
	Vector2(-1,0),
	Vector2(0,1),
	Vector2(0,-1),
	Vector2(1,1),
	Vector2(-1,-1),
	Vector2(1,-1),
	Vector2(-1,1)
]

func random_dir():
	return POSSIBLE_DIRS[randi()%POSSIBLE_DIRS.size()].normalized()

func plan_next_move():
	steps = random_steps()
	dir = random_dir()

var anim = false
func move():
	if out_of_bounds:
		if !anim:
			$Sprite/AnimationPlayer.play()
			anim = true
		# don't change course until you're in bounds
		move_and_slide(dir * MAX_SPEED, Vector2())
	else:
		if steps > 0:
			if !anim:
					$Sprite/AnimationPlayer.play()
					anim = true
			move_and_slide(dir * rand_range(MIN_SPEED, MAX_SPEED), Vector2())
			steps -= 1
		else:
			$Sprite/AnimationPlayer.stop(false)
			anim = false
			plan_next_move()

func i_am(body: KinematicBody2D):
	return body && body.get_instance_id() == get_instance_id()

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
	
func _ready():
	anim = true
	$Sprite/AnimationPlayer.play("WalkUp")
	ZIndex.hack(self.position.y, $Sprite, $Sprite)
	
func _on_Area2D_body_exited(body: KinematicBody2D):
	if i_am(body):
		dir = opposite(dir)
		steps = MAX_STEPS * 2
		out_of_bounds = true

func _on_Area2D_body_entered(body):
	if i_am(body):
		out_of_bounds = false
		
