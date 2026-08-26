extends CanvasLayer

var player: CharacterBody3D
var look_touch := -1
var last_look := Vector2.ZERO
var move_buttons := []

func _ready():
    var root := Control.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    root.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(root)

    _button(root, "▲", Vector2(115, 600), "move_forward")
    _button(root, "▼", Vector2(115, 700), "move_back")
    _button(root, "◀", Vector2(35, 650), "move_left")
    _button(root, "▶", Vector2(195, 650), "move_right")
    _button(root, "قفز", Vector2(1080, 610), "jump")

    var hint := Label.new()
    hint.text = "LifeCity • حرّك الشخصية واستكشف المدينة"
    hint.position = Vector2(30, 25)
    hint.add_theme_font_size_override("font_size", 24)
    root.add_child(hint)

func _button(root: Control, text: String, pos: Vector2, action: String):
    var b := Button.new()
    b.text = text
    b.position = pos
    b.size = Vector2(70, 70)
    b.modulate.a = 0.78
    b.button_down.connect(func(): Input.action_press(action))
    b.button_up.connect(func(): Input.action_release(action))
    root.add_child(b)
    move_buttons.append(b)

func _unhandled_input(event):
    if event is InputEventScreenTouch:
        if event.pressed and event.position.x > get_viewport().get_visible_rect().size.x * 0.45:
            look_touch = event.index
            last_look = event.position
        elif not event.pressed and event.index == look_touch:
            look_touch = -1
    elif event is InputEventScreenDrag and event.index == look_touch and player:
        var delta := event.position - last_look
        last_look = event.position
        player.rotate_y(-delta.x * 0.006)
