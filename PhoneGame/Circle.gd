extends Area2D

onready var orbit_position = $Pivot/OrbitPosition
enum MODES {STATIC, LIMITED}

var radius = 100
var rotation_speed = PI
var mode = MODES.STATIC
var num_orbits = 3
var current_orbits = 0
var orbit_start = null #start position. where you start orbiting. THIS IS AN ANGLE
var jumper = null

func init(_position, _radius=radius, _mode=MODES.LIMITED):
	position = _position
	radius = _radius
	set_mode(_mode)
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius = radius
	var img_size = $Sprite.texture.get_size().x / 2
	$Sprite.scale = Vector2(1,1) * radius / img_size
	orbit_position.position.x = radius + 25
	rotation_speed *= pow(-1, randi() % 2)
	
func set_mode(_mode):
	mode = _mode
	match mode:
		MODES.STATIC:
			$Label.hide()
		MODES.LIMITED:
			current_orbits = num_orbits
			$Label.text = str(current_orbits)
			$Label.show()	

func _process(delta):
	$Pivot.rotation += rotation_speed * delta
	
	if mode == MODES.LIMITED and jumper:
		check_orbits()
		
func check_orbits():
	if abs($Pivot.rotation - orbit_start) > 2 * PI:
		current_orbits -= 1
		if settings.enable_sound:
			$Beep.play()
		$Label.text = str(current_orbits)
		if current_orbits <= 0:
			jumper.die()
			jumper = null
			implode()
		orbit_start = $Pivot.rotation

func implode():
	$AnimationPlayer.play("implode")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
	
func capture(target):
	jumper = target
	$AnimationPlayer.play("capture")
	$Pivot.rotation = (jumper.position - position).angle()
	
	# Remember this is in radians
	orbit_start = $Pivot.rotation
