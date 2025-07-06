extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var mouse_motion := Vector2.ZERO
@onready var pivot: Node3D = $Pivot

var mouse_sens = 0.02

# runs at start of the scene
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
# calls physics in every frame rate i.e delta (sec)
func _physics_process(delta: float) -> void:
	handle_camera_rotation()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	# move player and collison apply
	move_and_slide()
# captures mouse input and runs only when its provided
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			mouse_motion = -event.relative * mouse_sens
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		#mouse_motion = Vector2.ZERO
# handle player rotation in Y-axis based on cursor X-axis
func handle_camera_rotation() -> void:
	rotate_y(mouse_motion.x)
	pivot.rotate_x(mouse_motion.y)
	pivot.rotation_degrees.x = clampf(pivot.rotation_degrees.x,-89.0,89.0)
	mouse_motion = Vector2.ZERO
