extends CharacterBody3D

var speed := 6.0
var gravity := 18.0
var jump_speed := 6.5
var yaw := 0.0
var pitch := -12.0
var camera
var touch_ui
var jump_lock := false

func _ready():
    var shape = CollisionShape3D.new()
    var capsule = CapsuleShape3D.new()
    capsule.radius = 0.42
    capsule.height = 1.8
    shape.shape = capsule
    shape.position.y = 0.9
    add_child(shape)
    var mesh = MeshInstance3D.new()
    var capsule_mesh = CapsuleMesh.new()
    capsule_mesh.radius = 0.42
    capsule_mesh.height = 1.8
    mesh.mesh = capsule_mesh
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color(0.08,0.12,0.18)
    mesh.material_override = mat
    mesh.position.y = 0.9
    add_child(mesh)
    camera = Camera3D.new()
    camera.position = Vector3(0,3.1,6.2)
    camera.rotation_degrees = Vector3(pitch,0,0)
    camera.current = true
    add_child(camera)
    touch_ui = get_node("/root/LifeCity/UI/TouchControls")

func _physics_process(delta):
    if not is_on_floor():
        velocity.y -= gravity * delta
    var move = Vector2.ZERO
    if touch_ui:
        move = touch_ui.move_vector
    var keys = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    if keys.length() > 0.05:
        move = keys
    var basis = global_transform.basis
    var forward = -basis.z
    var right = basis.x
    var direction = (right * move.x + forward * -move.y)
    direction.y = 0
    if direction.length() > 0.05:
        direction = direction.normalized()
        velocity.x = direction.x * speed
        velocity.z = direction.z * speed
        yaw = lerp_angle(yaw, atan2(-direction.x, -direction.z), 0.12)
        rotation.y = yaw
    else:
        velocity.x = move_toward(velocity.x, 0, speed * 8 * delta)
        velocity.z = move_toward(velocity.z, 0, speed * 8 * delta)
    var jump = Input.is_key_pressed(KEY_SPACE)
    if touch_ui:
        jump = jump or touch_ui.jump_pressed
    if jump and is_on_floor() and not jump_lock:
        velocity.y = jump_speed
        jump_lock = true
    if not jump:
        jump_lock = false
    if touch_ui:
        var look = touch_ui.look_delta
        yaw -= look.x * 0.006
        pitch = clamp(pitch - look.y * 0.004, -45.0, 20.0)
        rotation.y = yaw
        camera.rotation_degrees.x = pitch
        touch_ui.look_delta = Vector2.ZERO
    move_and_slide()
