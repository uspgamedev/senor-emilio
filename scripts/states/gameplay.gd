
extends Node2D

const Door = preload("res://scripts/classes/door.gd")

onready var STAGES = [
  preload("res://resources/maps/stage1.tscn").instance(),
]

onready var sfx = get_node("sfx")
onready var _bgms = [
  get_node("bgm-future"),
  get_node("bgm-past")
]
onready var fadein = get_node("fadein")
onready var fadeout = get_node("fadeout")
onready var hud = get_node("/root/main/HUD")

const FUTURE = 0
const PAST = 1

export(int, "FUTURE","PAST") var current = FUTURE

var _maps
var _chars

onready var _cam = Camera2D.new()

func _ready():
    var input = get_node("/root/input")
    _setup()
    _start_camera()
    _connect_state()
    input.connect("press_quit", self, "_quit")

func _hello():
  hud.init_dialog(get_node("hello"))

func _setup():
  _maps = [
    get_node("stage/future"),
    get_node("stage/past")
  ]
  _chars = [
    _maps[FUTURE].get_node("bodies/human"),
    _maps[PAST].get_node("bodies/cat")
  ]

func _change_stage(which,door_name):
  printt(get_name(), "received request to change stage", which, door_name)
  _disconnect_state()
  remove_child(get_node("stage"))
  yield(get_tree(), "fixed_frame")
  add_child(STAGES[which])
  _setup()
  _connect_state()
  var door = get_current_map().get_node(door_name)
  get_current_char().set_pos(door.get_spawn_pos())

func _connect_state():
  input.connect("hold_direction", get_current_char(), "_move_to")
  input.connect("press_action", get_current_char(), "_act")
  get_current_char().connect("time_travel", self, "switch_time_state")
  get_current_char().connect("grab", sfx, "play", ["grab"])
  get_current_char().connect("just_drop", sfx, "play", ["drop"])
  get_current_char().add_child(_cam)
  get_current_map().show()
  fadein.interpolate_method(_bgms[current], "set_volume", 0, 1, 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
  fadein.start()
  #get_current_map().set_collision_layer(1)

func _disconnect_state():
  input.disconnect("hold_direction", get_current_char(), "_move_to")
  input.disconnect("press_action", get_current_char(), "_act")
  get_current_char().disconnect("time_travel", self, "switch_time_state")
  get_current_char().disconnect("grab", sfx, "play")
  get_current_char().disconnect("just_drop", sfx, "play")
  get_current_char().remove_child(_cam)
  get_current_map().hide()
  fadeout.interpolate_method(_bgms[current], "set_volume", 1, 0, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
  fadeout.start()
  #get_current_map().set_collision_layer(0)

func _start_camera():
  _cam.make_current()

func _quit():
    get_tree().quit()

func get_current_map():
  return _maps[current]

func get_current_char():
  return _chars[current]

func get_other_map():
  return _maps[1 - current]

func get_other_char():
  return _chars[1 - current]

func switch_time_state():
  _disconnect_state()
  current = 1 - current
  _connect_state()
