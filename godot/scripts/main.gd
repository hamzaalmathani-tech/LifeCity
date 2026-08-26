extends Node3D

var player: CharacterBody3D

func _ready():
    _setup_environment()
    _build_city()
    _spawn_player()
    _add_touch_controls()

func _setup_environment():
    var env_node := WorldEnvironment.new()
    var env := Environment.new()
    env.background_mode = Environment.BG_COLOR
    env.background_color = Color(0.45, 0.68, 0.92)
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color(0.55, 0.65, 0.8)
    env.ambient_light_energy = 0.8
    env_node.environment = env
    add_child(env_node)

    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-52, -30, 0)
    sun.light_energy = 1.15
    sun.shadow_enabled = true
    add_child(sun)

func _box(parent: Node3D, pos: Vector3, size: Vector3, color: Color, solid := true):
    var body: Node3D
    if solid:
        body = StaticBody3D.new()
    else:
        body = Node3D.new()
    body.position = pos
    parent.add_child(body)
    var mesh_node := MeshInstance3D.new()
    var mesh := BoxMesh.new()
    mesh.size = size
    mesh_node.mesh = mesh
    var mat := StandardMaterial3D.new()
    mat.albedo_color = color
    mesh_node.material_override = mat
    body.add_child(mesh_node)
    if solid:
        var collision := CollisionShape3D.new()
        var shape := BoxShape3D.new()
        shape.size = size
        collision.shape = shape
        body.add_child(collision)
    return body

func _build_city():
    _box(self, Vector3(0, -0.5, 0), Vector3(120, 1, 120), Color(0.18, 0.42, 0.2))
    # Main roads
    _box(self, Vector3(0, 0.02, 0), Vector3(120, 0.12, 9), Color(0.07, 0.07, 0.08), false)
    _box(self, Vector3(0, 0.03, -28), Vector3(120, 0.12, 7), Color(0.08, 0.08, 0.09), false)
    _box(self, Vector3(0, 0.04, 28), Vector3(120, 0.12, 7), Color(0.08, 0.08, 0.09), false)
    _box(self, Vector3(0, 0.03, 0), Vector3(9, 0.12, 120), Color(0.07, 0.07, 0.08), false)
    _box(self, Vector3(-30, 0.04, 0), Vector3(7, 0.12, 120), Color(0.08, 0.08, 0.09), false)
    _box(self, Vector3(30, 0.04, 0), Vector3(7, 0.12, 120), Color(0.08, 0.08, 0.09), false)

    # Downtown towers
    for i in range(10):
        var x := -18.0 + float(i % 5) * 9.0
        var z := -18.0 + float(i / 5) * 9.0
        var h := 8.0 + float((i * 3) % 7)
        _box(self, Vector3(x, h / 2.0, z), Vector3(5, h, 5), Color(0.22, 0.30, 0.38))

    # Residential blocks
    for x in [-45.0, -37.0, 37.0, 45.0]:
        for z in [-20.0, 0.0, 20.0]:
            _box(self, Vector3(x, 2.0, z), Vector3(6, 4, 8), Color(0.72, 0.58, 0.42))

    # Airport terminal and runway
    _box(self, Vector3(55, 2, -38), Vector3(18, 4, 10), Color(0.65, 0.68, 0.72))
    _box(self, Vector3(55, 0.1, -55), Vector3(70, 0.2, 8), Color(0.12, 0.12, 0.14), false)

    # Mountain and secret cave entrance
    _box(self, Vector3(-48, 8, 45), Vector3(28, 16, 24), Color(0.24, 0.27, 0.25))
    _box(self, Vector3(-48, 2, 32), Vector3(7, 4, 2), Color(0.03, 0.03, 0.035), false)

func _spawn_player():
    player = preload("res://scripts/player.gd").new()
    player.position = Vector3(6, 0.1, 14)
    add_child(player)

func _add_touch_controls():
    var controls := preload("res://scripts/touch_controls.gd").new()
    controls.player = player
    add_child(controls)
