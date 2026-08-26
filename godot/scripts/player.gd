extends CharacterBody3D

@export var speed := 6.0
@export var jump_velocity := 5.0
@export var gravity := 14.0
var move_input := Vector2.ZERO
var camera: Camera3D

func _ready():
    var shape := CollisionShape3D.new()
    var capsule := CapsuleShape3D.new()
    capsule.radius = 0.38
    capsule.height = 1.8
    shape.shape = capsule
    shape.position.y = 0.9
    add_child(shape)

    var body := MeshInstance3D.new()
    var mesh := CapsuleMesh.new()
    mesh.radius = 0.38
    mesh.height = 1.8
    body.mesh = mesh
    body.position.y = 0.9
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color(0.08, 0.12, 0.18)
    body.material_override = mat
    add_child(body)

    camera = Camera3D.new()
    camera.position = Vector3(0, 3.0, 6.5)
    camera.rotation_degrees = Vector3(-14, 0, 0)
    camera.current = true
    add_child(camera)

func set_move_input(value: Vector2):
    move_input = value

func _physics_process(delta):
    if not is_on_floor():
        velocity.y -= gravity * delta
    var input_vec := move_input
    if input_vec.length() < 0.01:
        input_vec = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_velocity
    var direction := Vector3(input_vec.x, 0.0, input_vec.y)
    if direction.length() > 0.0:
        direction = direction.normalized()
        velocity.x = direction.x * speed
        velocity.z = direction.z * speed
        rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), 0.15)
    else:
        velocity.x = move_toward(velocity.x, 0.0, speed * 8.0 * delta)
        velocity.z = move_toward(velocity.z, 0.0, speed * 8.0 * delta)
    move_and_slide()
