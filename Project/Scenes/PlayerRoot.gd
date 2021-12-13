extends RigidBody2D

var levelController = null

const BASE_GUN_IMPULSE = Vector2.UP * 20
const BASE_MOMENT_OF_INERTIA = 200

const GUN_DELAY = 0.15
var leftGunTimer = 0
var rightGunTimer = 0

var bulletTemplate = null

const SAFE_COLLISION_LIMIT = 2000
const DEADLY_COLLISION = 15000

var prevVel = Vector2()
var collided = false
var currHull = 1

var disabled = false

var destructOption = null
var destructOptionTimer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	levelController = get_node("/root/LevelRoot/LevelController")
	bulletTemplate = get_node("../PlyrBulletTemplate")
	destructOption = $Control/DestructOption
	inertia = BASE_MOMENT_OF_INERTIA
	prevVel = linear_velocity
	destructOptionTimer = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# would probably be better to make this vector-add movement
	# over the last 60-odd frames?
	if linear_velocity.length() < 50:
		destructOptionTimer += delta
		if destructOptionTimer > 6:
			destructOption.visible = true
	else:
		destructOption.visible = false
		destructOptionTimer = 0
	
	if destructOption.visible and Input.is_key_pressed(KEY_SPACE):
		takeDamage(1)
		destructOption.visible = false
		
	if currHull > 0 and not disabled:
		if leftGunTimer > delta:
			leftGunTimer -= delta
		else:
			leftGunTimer = 0
			
		if rightGunTimer > delta:
			rightGunTimer -= delta
		else:
			rightGunTimer = 0
			
		if(leftGunTimer == 0 and Input.is_action_pressed("left_gun_fire")):
			fire_left_gun()
			leftGunTimer = GUN_DELAY
		if(rightGunTimer == 0 and Input.is_action_pressed("right_gun_fire")):
			fire_right_gun()
			rightGunTimer = GUN_DELAY
		
		if collided == true:
			var change = (linear_velocity - prevVel).length()
			var acceleration = change / 0.04 # delta normalisation doesn't work
			
			if acceleration > SAFE_COLLISION_LIMIT:
				var damageProportion = (acceleration - SAFE_COLLISION_LIMIT) / DEADLY_COLLISION
				takeDamage(damageProportion)
				$CollisionPlayer.play()
			
			collided = false
			
		prevVel = linear_velocity
		
func _physics_process(delta):
	$Control.set_rotation(-transform.get_rotation())

func fire_left_gun():
	var bulletInstance = bulletTemplate.duplicate()
	get_owner().add_child(bulletInstance)
	bulletInstance.transform = Transform2D($GunLeft.global_transform)
	bulletInstance.fire(linear_velocity)
	
	$FirePlayer.play()
	
	apply_impulse(transform.basis_xform($GunLeft.position), transform.basis_xform(BASE_GUN_IMPULSE))

func fire_right_gun():
	var bulletInstance = bulletTemplate.duplicate()
	get_owner().add_child(bulletInstance)
	bulletInstance.transform = Transform2D($GunRight.global_transform)
	bulletInstance.fire(linear_velocity)
	
	$FirePlayer.play()
	
	apply_impulse(transform.basis_xform($GunRight.position), transform.basis_xform(BASE_GUN_IMPULSE))

func is_player():
	return true

func _on_PlayerRoot_body_entered(body):
	collided = true
	
func takeDamage(amount):
	if currHull > 0:
		currHull -= amount
		if currHull < 0:
			currHull = 0
			levelController.spawnBigExplosion(global_position)
			hide()
			
		levelController.setPlayerHull(currHull)

func disable():
	disabled = true
