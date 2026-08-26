extends Control

var move_vector := Vector2.ZERO
var look_delta := Vector2.ZERO
var jump_pressed := false
var joystick_id := -1
var look_id := -1
var joystick_center := Vector2.ZERO
var joystick_pos := Vector2.ZERO
var jump_button := Rect2()

func _ready():
    set_process_input(true)
    queue_redraw()

func _notification(what):
    if what == NOTIFICATION_RESIZED:
        queue_redraw()

func _draw():
    var size = get_viewport_rect().size
    joystick_center = Vector2(120, size.y - 120)
    draw_circle(joystick_center, 70, Color(0.05,0.05,0.08,0.42))
    draw_circle(joystick_pos if joystick_id != -1 else joystick_center, 30, Color(0.8,0.85,0.9,0.65))
    jump_button = Rect2(size.x - 150, size.y - 180, 105, 70)
    draw_style_box(_panel(Color(0.12,0.16,0.22,0.65)), jump_button)
    draw_string(ThemeDB.fallback_font, jump_button.position + Vector2(30,45), "JUMP", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color.WHITE)
    draw_string(ThemeDB.fallback_font, Vector2(25,40), "LIFECITY 3D", HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color(1,0.75,0.15))

func _panel(color: Color):
    var box = StyleBoxFlat.new()
    box.bg_color = color
    box.corner_radius_top_left = 18
    box.corner_radius_top_right = 18
    box.corner_radius_bottom_left = 18
    box.corner_radius_bottom_right = 18
    return box

func _input(event):
    if event is InputEventScreenTouch:
        if event.pressed:
            if event.position.distance_to(joystick_center) < 95 and joystick_id == -1:
                joystick_id = event.index
                joystick_pos = event.position
                _update_move(event.position)
            elif jump_button.has_point(event.position):
                jump_pressed = true
            elif event.position.x > get_viewport_rect().size.x * 0.45 and look_id == -1:
                look_id = event.index
        else:
            if event.index == joystick_id:
                joystick_id = -1
                joystick_pos = joystick_center
                move_vector = Vector2.ZERO
            if event.index == look_id:
                look_id = -1
            if jump_button.has_point(event.position):
                jump_pressed = false
            queue_redraw()
    elif event is InputEventScreenDrag:
        if event.index == joystick_id:
            joystick_pos = event.position
            _update_move(event.position)
        elif event.index == look_id:
            look_delta += event.relative
        queue_redraw()

func _update_move(pos: Vector2):
    var offset = pos - joystick_center
    if offset.length() > 70:
        offset = offset.normalized() * 70
    joystick_pos = joystick_center + offset
    move_vector = Vector2(offset.x / 70.0, offset.y / 70.0)
