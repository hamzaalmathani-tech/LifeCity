extends Node3D

var player
var city_root

func _ready():
    _make_environment()
    _make_city()
    _make_player()
    _make_ui()

func _mat(color: Color):
    var m = StandardMaterial3D.new()
    m.albedo_color = color
    m.roughness = 0.8
    return m

func _box(parent: Node3D, pos: Vector3, size: Vector3, color: Color, collision := true):
    var mesh = MeshInstance3D.new()
    var b = BoxMesh.new()
    b.size = size
    mesh.mesh = b
    mesh.material_override = _mat(color)
    mesh.position = pos
    parent.add_child(mesh)
    if collision:
        var body = StaticBody3D.new()
        body.position = pos
        var shape = CollisionShape3D.new()
        var box_shape = BoxShape3D.new()
        box_shape.size = size
        shape.shape = box_shape
        body.add_child(shape)
        parent.add_child(body)
    return mesh

func _make_environment():
    var env_node = WorldEnvironment.new()
    var env = Environment.new()
    env.background_mode = Environment.BG_COLOR
    env.background_color = Color(0.45, 0.68, 0.9)
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color(0.65, 0.75, 0.9)
    env.ambient_light_energy = 0.8
    env_node.environment = env
    add_child(env_node)
    var sun = DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-52, -28, 0)
    sun.light_energy = 1.2
    sun.shadow_enabled = true
    add_child(sun)

func _make_city():
    city_root = Node3D.new()
    city_root.name = "City"
    add_child(city_root)
    _box(city_root, Vector3(0,-0.25,0), Vector3(180,0.5,180), Color(0.16,0.42,0.18))
    # Main roads
    _box(city_root, Vector3(0,0,0), Vector3(180,0.08,10), Color(0.06,0.06,0.07), false)
    _box(city_root, Vector3(0,0,0), Vector3(10,0.09,180), Color(0.06,0.06,0.07), false)
    # Side streets and blocks
    for x in [-55,-25,25,55]:
        _box(city_root, Vector3(x,0,0), Vector3(5,0.06,180), Color(0.08,0.08,0.09), false)
    for z in [-55,-25,25,55]:
        _box(city_root, Vector3(0,0,z), Vector3(180,0.06,5), Color(0.08,0.08,0.09), false)
    # Buildings
    var heights = [8.0, 12.0, 18.0, 25.0, 32.0]
    var colors = [Color(0.28,0.34,0.4), Color(0.42,0.45,0.48), Color(0.3,0.38,0.5), Color(0.5,0.4,0.3)]
    for x in [-70,-42,-14,14,42,70]:
        for z in [-70,-42,-14,14,42,70]:
            if abs(x) < 20 and abs(z) < 20:
                continue
            var h = heights[(abs(int(x+z)) / 2) % heights.size()]
            _box(city_root, Vector3(x,h/2,z), Vector3(16,h,16), colors[(abs(int(x-z)) / 7) % colors.size()])
    # Park
    _box(city_root, Vector3(42,0.15,-42), Vector3(24,0.3,24), Color(0.08,0.48,0.16), false)
    # Mountain and cave entrance landmark
    for i in range(9):
        var r = 28.0 - i * 2.2
        _box(city_root, Vector3(65 - i*2.0, r*0.35, -62), Vector3(r, r*0.7, r), Color(0.22,0.23,0.25), false)
    _box(city_root, Vector3(60,3,-66), Vector3(8,6,2), Color(0.02,0.02,0.025), false)
    # Simple airport landmark
    _box(city_root, Vector3(-62,0.08,62), Vector3(40,0.12,16), Color(0.15,0.15,0.16), false)
    _box(city_root, Vector3(-62,2,72), Vector3(22,4,10), Color(0.75,0.75,0.78))

func _make_player():
    var scene = load("res://player.gd")
    player = CharacterBody3D.new()
    player.name = "Player"
    player.position = Vector3(0,1.2,18)
    player.set_script(scene)
    add_child(player)

func _make_ui():
    var ui = CanvasLayer.new()
    ui.name = "UI"
    add_child(ui)
    var script = load("res://touch_ui.gd")
    var controls = Control.new()
    controls.name = "TouchControls"
    controls.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    controls.mouse_filter = Control.MOUSE_FILTER_PASS
    controls.set_script(script)
    ui.add_child(controls)
