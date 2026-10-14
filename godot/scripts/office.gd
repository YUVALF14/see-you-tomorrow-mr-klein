extends Control

const INK := Color("26322d")
const MUTED_INK := Color("647066")
const PAPER := Color("e9e1cf")
const PAPER_LIGHT := Color("f1eadb")
const PAPER_EDGE := Color("c9beaa")
const ROOM := Color("303a34")
const ROOM_LIGHT := Color("49544b")
const OXIDE := Color("89584e")
const GOLD := Color("b49a6b")

const FILES := [
	{
		"ref": "18/4 · HOUSEHOLD REGISTER",
		"address": "Dlouhá 18, Praha I",
		"subject": "Emil Voss — deceased. Entry accepted fourteen years ago. The field for household members is blank.",
		"evidence": "Rent receipt: paid by M. Voss and E. Voss.\nNeighbour's statement: no Emil has lived at number 18.",
		"applicant": "“He is still at the table when the rain starts.” — Marta Voss"
	},
	{
		"ref": "19/4 · ROUTING SLIP",
		"address": "Vodičkova 681/18, Praha II",
		"subject": "A forwarding address has been entered in the space reserved for the receiving office.",
		"evidence": "The receiving office has returned the slip unsigned. The return envelope bears its own return address.",
		"applicant": "“I was told to leave this here until someone asks for it.” — J. Havel"
	},
	{
		"ref": "20/4 · DUPLICATE ORIGINAL",
		"address": "Mariánské náměstí 190/5, Praha I",
		"subject": "Two originals are attached. Each bears the stamp ORIGINAL. Neither copy number is legible.",
		"evidence": "Both papers are dated today. One was received yesterday.",
		"applicant": "“I brought the one you asked for. They said the other one was also the one.”"
	}
]

var index := 0
var chosen_route := ""
var marked := false
var written := false
var signed := false
var sent := false
var signature_points: PackedVector2Array = []
var stamp_count := 0
var task_label: Label
var file_label: Label
var form_text: Label
var feedback: Label
var stamp: Button
var sign_pad: Control
var paper: PanelContainer
var outgoing_slot: PanelContainer
var audio_players: Dictionary = {}
var audio_paths := {
	"rain": "res://audio/room/rain_window.ogg",
	"clock": "res://audio/room/clock_tick_tock.ogg",
	"drip": "res://audio/room/ceiling_drip.ogg",
	"footsteps": "res://audio/room/hallway_steps.ogg",
	"paper": "res://audio/foley/paper_slide.ogg",
	"pen": "res://audio/foley/pen_on_paper.ogg",
	"stamp": "res://audio/foley/rubber_stamp.ogg",
	"score": "res://audio/music/recorded_piano.ogg"
}
var clock_timer: Timer
var drip_timer: Timer
var room_layer: ColorRect

func _ready() -> void:
	_build_audio()
	_build_office()
	_show_file()
	_start_room_sound()

func _build_office() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var bg := ColorRect.new()
	bg.color = ROOM
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var outer := MarginContainer.new()
	outer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	outer.add_theme_constant_override("margin_left", 34)
	outer.add_theme_constant_override("margin_right", 34)
	outer.add_theme_constant_override("margin_top", 22)
	outer.add_theme_constant_override("margin_bottom", 24)
	add_child(outer)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 15)
	outer.add_child(root)
	root.add_child(_topbar())

	var columns := HBoxContainer.new()
	columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	columns.add_theme_constant_override("separation", 18)
	root.add_child(columns)
	columns.add_child(_room_panel())
	columns.add_child(_desk_panel())

	var footer := Label.new()
	footer.text = "PRAHA · 1931                                         DEPARTMENT OF HOUSEHOLD RECORDS · ROOM 4"
	footer.add_theme_color_override("font_color", Color("aab2a5"))
	footer.add_theme_font_size_override("font_size", 12)
	footer.add_theme_constant_override("outline_size", 0)
	root.add_child(footer)

func _topbar() -> Control:
	var row := HBoxContainer.new()
	row.custom_minimum_size.y = 46
	var title := Label.new()
	title.text = "SEE YOU TOMORROW, MR. KLEIN"
	title.add_theme_color_override("font_color", Color("e6e0d0"))
	title.add_theme_font_size_override("font_size", 18)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(title)
	var date := Label.new()
	date.text = "PRAHA  ·  1931"
	date.add_theme_color_override("font_color", Color("c6cabb"))
	date.add_theme_font_size_override("font_size", 13)
	row.add_child(date)
	return row

func _room_panel() -> Control:
	var panel := PanelContainer.new()
	panel.custom_minimum_size.x = 370
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _style(ROOM_LIGHT, Color("667167"), 2, 10))
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 13)
	panel.add_child(col)
	var heading := Label.new()
	heading.text = "ROOM 4 · DESK 14"
	heading.add_theme_color_override("font_color", Color("d1d4c4"))
	heading.add_theme_font_size_override("font_size", 13)
	col.add_child(heading)

	var window_frame := PanelContainer.new()
	window_frame.size_flags_vertical = Control.SIZE_EXPAND_FILL
	window_frame.custom_minimum_size.y = 245
	window_frame.add_theme_stylebox_override("panel", _style(Color("273a36"), Color("859085"), 7, 1))
	var window := Control.new()
	window.custom_minimum_size.y = 225
	window.draw.connect(_draw_window.bind(window))
	window_frame.add_child(window)
	col.add_child(window_frame)

	var clock := Label.new()
	clock.text = "             ◷     The clock loses one minute each hour."
	clock.add_theme_color_override("font_color", Color("c3c5b8"))
	clock.add_theme_font_size_override("font_size", 13)
	col.add_child(clock)
	var tray_head := Label.new()
	tray_head.text = "INCOMING TRAY"
	tray_head.add_theme_color_override("font_color", Color("d1d4c4"))
	tray_head.add_theme_font_size_override("font_size", 12)
	col.add_child(tray_head)
	var tray := PanelContainer.new()
	tray.custom_minimum_size.y = 72
	tray.add_theme_stylebox_override("panel", _style(Color("3a413a"), Color("879082"), 1, 4))
	var tray_text := Label.new()
	tray_text.text = "3 files await review\nOne has already been reviewed."
	tray_text.add_theme_color_override("font_color", Color("c8c8bb"))
	tray_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tray_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	tray.add_child(tray_text)
	col.add_child(tray)
	return panel

func _draw_window(control: Control) -> void:
	var size := control.size
	control.draw_rect(Rect2(Vector2.ZERO, size), Color("536259"))
	control.draw_rect(Rect2(Vector2(size.x * 0.49, 0), Vector2(7, size.y)), Color("303c36"))
	control.draw_rect(Rect2(Vector2(0, size.y * 0.53), Vector2(size.x, 7)), Color("303c36"))
	control.draw_rect(Rect2(Vector2(0, size.y * 0.75), size * Vector2(1, .25)), Color("465149"))
	var t := Time.get_ticks_msec() * .001
	for i in range(22):
		var x := fposmod(float(i * 43) + t * (12.0 + float(i % 4) * 3.0), size.x)
		var y := fposmod(float(i * 31) + t * (28.0 + float(i % 3) * 6.0), size.y)
		control.draw_line(Vector2(x, y), Vector2(x - 3, y + 17), Color(0.82, 0.85, 0.81, .23), 1.0)

func _desk_panel() -> Control:
	var outer := PanelContainer.new()
	outer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	outer.add_theme_stylebox_override("panel", _style(Color("b6aa93"), Color("758073"), 2, 5))
	var inset := MarginContainer.new()
	inset.add_theme_constant_override("margin_left", 26)
	inset.add_theme_constant_override("margin_right", 26)
	inset.add_theme_constant_override("margin_top", 21)
	inset.add_theme_constant_override("margin_bottom", 20)
	outer.add_child(inset)
	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 10)
	inset.add_child(stack)

	var docket := HBoxContainer.new()
	docket.custom_minimum_size.y = 27
	file_label = Label.new()
	file_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	file_label.add_theme_color_override("font_color", MUTED_INK)
	file_label.add_theme_font_size_override("font_size", 12)
	docket.add_child(file_label)
	var day := Label.new()
	day.text = "MONDAY · 20 APRIL 1931"
	day.add_theme_color_override("font_color", MUTED_INK)
	day.add_theme_font_size_override("font_size", 12)
	docket.add_child(day)
	stack.add_child(docket)

	paper = PanelContainer.new()
	paper.size_flags_vertical = Control.SIZE_EXPAND_FILL
	paper.add_theme_stylebox_override("panel", _style(PAPER_LIGHT, PAPER_EDGE, 1, 2))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 28)
	margin.add_theme_constant_override("margin_right", 28)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 19)
	paper.add_child(margin)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	margin.add_child(content)
	var dept := Label.new()
	dept.text = "DEPARTMENT OF HOUSEHOLD RECORDS   /   PRAHA"
	dept.add_theme_color_override("font_color", MUTED_INK)
	dept.add_theme_font_size_override("font_size", 12)
	content.add_child(dept)
	var rule := HSeparator.new()
	content.add_child(rule)
	var address := Label.new()
	address.name = "Address"
	address.add_theme_color_override("font_color", INK)
	address.add_theme_font_size_override("font_size", 23)
	content.add_child(address)
	var subject := Label.new()
	subject.name = "Subject"
	subject.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subject.custom_minimum_size.y = 55
	subject.add_theme_color_override("font_color", INK)
	subject.add_theme_font_size_override("font_size", 16)
	content.add_child(subject)
	var evidence := Label.new()
	evidence.name = "Evidence"
	evidence.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	evidence.size_flags_vertical = Control.SIZE_EXPAND_FILL
	evidence.add_theme_color_override("font_color", MUTED_INK)
	evidence.add_theme_font_size_override("font_size", 14)
	content.add_child(evidence)
	var applicant := Label.new()
	applicant.name = "Applicant"
	applicant.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	applicant.add_theme_color_override("font_color", Color("55594e"))
	applicant.add_theme_font_size_override("font_size", 15)
	content.add_child(applicant)
	stack.add_child(paper)

	task_label = Label.new()
	task_label.text = "TODAY'S ROUTINE · 1 OF 4"
	task_label.add_theme_color_override("font_color", OXIDE)
	task_label.add_theme_font_size_override("font_size", 12)
	stack.add_child(task_label)

	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 8)
	for data in [["Mark", "mark"], ["Write", "write"], ["Attach", "attach"], ["Set aside", "aside"]]:
		var button := _button(data[0])
		button.pressed.connect(_perform.bind(data[1]))
		actions.add_child(button)
	stack.add_child(actions)

	var form_row := HBoxContainer.new()
	form_row.add_theme_constant_override("separation", 9)
	var write_line := LineEdit.new()
	write_line.name = "Entry"
	write_line.placeholder_text = "Enter the register exactly as received"
	write_line.add_theme_color_override("font_color", INK)
	write_line.add_theme_color_override("font_placeholder_color", MUTED_INK)
	write_line.add_theme_stylebox_override("normal", _style(Color("e5ddca"), Color("9d947f"), 1, 1))
	write_line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	write_line.text_submitted.connect(_on_written)
	form_row.add_child(write_line)
	var write_button := _button("Enter")
	write_button.pressed.connect(_on_written.bind(""))
	form_row.add_child(write_button)
	stack.add_child(form_row)

	var signing := HBoxContainer.new()
	signing.add_theme_constant_override("separation", 12)
	sign_pad = Control.new()
	sign_pad.custom_minimum_size = Vector2(200, 65)
	sign_pad.mouse_filter = Control.MOUSE_FILTER_STOP
	sign_pad.draw.connect(_draw_signature)
	sign_pad.gui_input.connect(_signature_input)
	var pad_frame := PanelContainer.new()
	pad_frame.add_theme_stylebox_override("panel", _style(PAPER, Color("a89d87"), 1, 1))
	pad_frame.add_child(sign_pad)
	signing.add_child(pad_frame)
	var sign_col := VBoxContainer.new()
	var hint := Label.new()
	hint.text = "SIGN HERE\nUse the mouse or touch."
	hint.add_theme_color_override("font_color", MUTED_INK)
	hint.add_theme_font_size_override("font_size", 12)
	sign_col.add_child(hint)
	var sign_button := _button("Sign form")
	sign_button.pressed.connect(_sign)
	sign_col.add_child(sign_button)
	signing.add_child(sign_col)
	stack.add_child(signing)

	var bottom := HBoxContainer.new()
	feedback = Label.new()
	feedback.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	feedback.add_theme_color_override("font_color", MUTED_INK)
	feedback.add_theme_font_size_override("font_size", 12)
	bottom.add_child(feedback)
	stamp = _button("STAMP & SEND")
	stamp.pressed.connect(_send)
	bottom.add_child(stamp)
	stack.add_child(bottom)

	outgoing_slot = PanelContainer.new()
	outgoing_slot.custom_minimum_size.y = 42
	outgoing_slot.add_theme_stylebox_override("panel", _style(Color("a69a81"), Color("8f846e"), 1, 3))
	var outgoing_label := Label.new()
	outgoing_label.text = "OUTGOING TRAY  ·  RECEIPT REQUIRED"
	outgoing_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	outgoing_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	outgoing_label.add_theme_color_override("font_color", Color("e1d8c4"))
	outgoing_slot.add_child(outgoing_label)
	stack.add_child(outgoing_slot)
	return outer

func _show_file() -> void:
	var file: Dictionary = FILES[index]
	file_label.text = file.ref
	paper.get_node("MarginContainer/VBoxContainer/Address").text = file.address
	paper.get_node("MarginContainer/VBoxContainer/Subject").text = file.subject
	paper.get_node("MarginContainer/VBoxContainer/Evidence").text = file.evidence
	paper.get_node("MarginContainer/VBoxContainer/Applicant").text = file.applicant
	form_text = paper.get_node("MarginContainer/VBoxContainer/Subject")
	task_label.text = "TODAY'S ROUTINE · %d OF 4" % [index + 1]
	feedback.text = "A form may be set aside. It will remain on the desk."

func _perform(action: String) -> void:
	if sent: return
	match action:
		"mark":
			marked = true
			feedback.text = "A pencil mark is entered beside the unresolved field."
			_play("pen")
			_paper_nudge(-3.0)
		"write":
			var field := find_child("Entry", true, false) as LineEdit
			if field == null or field.text.strip_edges().is_empty():
				feedback.text = "Write a line in the register first. The original stays visible."
				if field: field.grab_focus()
				return
			_on_written(field.text)
			_paper_nudge(2.0)
		"attach":
			chosen_route = "ATTACHMENT FILED"
			feedback.text = "The receipt is fastened. Its corner covers the case number."
			var evidence: Label = paper.get_node("MarginContainer/VBoxContainer/Evidence")
			evidence.text += "\n\nANNEX B · ORIGINAL attached over the case number."
			_play("paper")
			_paper_nudge(4.0)
			if stamp_count == 0: stamp_count = 1
		"aside":
			feedback.text = "Set aside. The paper stays under the brass weight."
			_play("paper")
			_tween_paper(0.97, 0.9)
			return
	_update_task()

func _on_written(_value: String) -> void:
	var field := find_child("Entry", true, false) as LineEdit
	if field == null or field.text.strip_edges().is_empty():
		feedback.text = "The line cannot be entered without an entry."
		return
	written = true
	chosen_route = "ENTERED: " + field.text.strip_edges()
	feedback.text = "Written in the register. The first wording is not erased."
	_play("pen")
	_update_task()

func _signature_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			signature_points.clear()
			signature_points.append(sign_pad.get_local_mouse_position())
			sign_pad.queue_redraw()
		else:
			_play("pen")
	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		signature_points.append(sign_pad.get_local_mouse_position())
		sign_pad.queue_redraw()
	elif event is InputEventScreenTouch:
		if event.pressed:
			signature_points.clear()
			signature_points.append(sign_pad.get_local_mouse_position())
			sign_pad.queue_redraw()
		else:
			_play("pen")
	elif event is InputEventScreenDrag:
		signature_points.append(sign_pad.get_local_mouse_position())
		sign_pad.queue_redraw()

func _draw_signature() -> void:
	if signature_points.size() > 1:
		for i in range(1, signature_points.size()):
			sign_pad.draw_line(signature_points[i - 1], signature_points[i], Color("43564a"), 2.1, true)
	elif signature_points.size() == 1:
		sign_pad.draw_circle(signature_points[0], 1.5, Color("43564a"))

func _sign() -> void:
	if not marked and not written and chosen_route.is_empty():
		feedback.text = "The signature line is still blank. Mark, write, or attach first."
		return
	if signature_points.size() < 2:
		feedback.text = "The clerk's signature is required. Draw it in the box."
		return
	signed = true
	stamp_count += 1
	feedback.text = "Signed. The paper is ready for its outgoing tray."
	_play("stamp")
	stamp.text = "READY TO SEND"
	_paper_nudge(2.0)

func _send() -> void:
	if not signed:
		feedback.text = "The outgoing tray requires a signature. The file can wait."
		return
	if sent: return
	sent = true
	feedback.text = "The form leaves the room. No receipt is returned today."
	_play("paper")
	var tween := create_tween()
	tween.tween_property(paper, "position:y", paper.position.y + 90, .48).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(paper, "modulate:a", 0.25, .48)
	tween.tween_callback(_next_file)

func _next_file() -> void:
	index = (index + 1) % FILES.size()
	chosen_route = ""
	marked = false
	written = false
	signed = false
	sent = false
	signature_points.clear()
	stamp.text = "STAMP & SEND"
	paper.position.y = 0
	paper.modulate.a = 1.0
	_show_file()
	_update_task()
	var tween := create_tween()
	tween.tween_property(paper, "position:y", -16, 0.01)
	tween.tween_property(paper, "position:y", 0, .4).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_play("paper")

func _update_task() -> void:
	var count := int(marked) + int(written) + int(not chosen_route.is_empty()) + int(signed)
	task_label.text = "TODAY'S ROUTINE · %d OF 4" % [mini(4, count + 1)]

func _paper_nudge(degrees: float) -> void:
	var tween := create_tween()
	tween.tween_property(paper, "rotation_degrees", degrees, .07)
	tween.tween_property(paper, "rotation_degrees", 0.0, .18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_tween_paper(1.0, 1.02)

func _tween_paper(alpha: float, scale: float) -> void:
	var tween := create_tween()
	tween.tween_property(paper, "modulate:a", alpha, .18)
	tween.parallel().tween_property(paper, "scale", Vector2(scale, scale), .18)
	tween.tween_property(paper, "modulate:a", 1.0, .22)
	tween.parallel().tween_property(paper, "scale", Vector2.ONE, .22)

func _button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(108, 39)
	button.add_theme_color_override("font_color", INK)
	button.add_theme_color_override("font_hover_color", Color("f4eddd"))
	button.add_theme_color_override("font_pressed_color", Color("fff7e3"))
	button.add_theme_font_size_override("font_size", 13)
	button.add_theme_stylebox_override("normal", _style(Color("d9d0bd"), Color("978c77"), 1, 2))
	button.add_theme_stylebox_override("hover", _style(Color("6c776c"), GOLD, 1, 2))
	button.add_theme_stylebox_override("pressed", _style(Color("4a594e"), Color("b7aa8b"), 1, 2))
	button.mouse_entered.connect(_button_hover.bind(button))
	return button

func _button_hover(button: Button) -> void:
	var tween := create_tween()
	tween.tween_property(button, "position:y", button.position.y - 1.5, .07)
	tween.tween_property(button, "position:y", button.position.y, .11)

func _style(fill: Color, border: Color, width: int, radius: int) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = border
	box.set_border_width_all(width)
	box.set_corner_radius_all(radius)
	box.content_margin_left = 10
	box.content_margin_right = 10
	box.content_margin_top = 7
	box.content_margin_bottom = 7
	return box

func _build_audio() -> void:
	for key in audio_paths:
		var player := AudioStreamPlayer.new()
		player.name = key.capitalize() + "Player"
		player.bus = "Score" if key == "score" else ("Room" if ["rain", "clock", "drip", "footsteps"].has(key) else "Foley")
		var path: String = audio_paths[key]
		if ResourceLoader.exists(path):
			player.stream = load(path)
		add_child(player)
		audio_players[key] = player
	clock_timer = Timer.new()
	clock_timer.wait_time = 1.0
	clock_timer.timeout.connect(_tick)
	clock_timer.autostart = true
	add_child(clock_timer)
	drip_timer = Timer.new()
	drip_timer.timeout.connect(_drip)
	drip_timer.autostart = true
	add_child(drip_timer)

func _start_room_sound() -> void:
	var rain: AudioStreamPlayer = audio_players.rain
	var score: AudioStreamPlayer = audio_players.score
	if rain.stream:
		rain.volume_db = -19.0
		rain.play()
	if score.stream:
		score.volume_db = -26.0
		score.play()
	_schedule_drip()

func _tick() -> void:
	_play("clock", randf_range(-18.0, -12.0))

func _schedule_drip() -> void:
	if drip_timer: drip_timer.start(randf_range(7.0, 19.0))

func _drip() -> void:
	_play("drip", randf_range(-17.0, -10.0))
	_schedule_drip()

func _play(key: String, gain_db: float = -6.0) -> void:
	var player: AudioStreamPlayer = audio_players.get(key)
	if player and player.stream:
		player.volume_db = gain_db
		player.pitch_scale = randf_range(.96, 1.04)
		player.play()

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		for key in audio_players:
			(audio_players[key] as AudioStreamPlayer).volume_db = -80.0
	elif what == NOTIFICATION_APPLICATION_FOCUS_IN:
		_start_room_sound()
