
extends Node2D

const FUTURE = 0
const PAST = 1

export(int, "FUTURE","PAST") var current = FUTURE

onready var _maps = [
  get_node("future"),
  get_node("past")
]
onready var _chars = [
  _maps[FUTURE].get_node("bodies/human"),
  _maps[PAST].get_node("bodies/cat")
]
onready var _cam = Camera2D.new()

func _ready():
    var input = get_node("/root/input")
    _start_camera()
    _connect_state()
    input.connect("press_quit", self, "_quit")
    set_process(true)

func _connect_state():
  input.connect("hold_direction", get_current_char(), "_move_to")
  input.connect("press_action", get_current_char(), "_act")
  get_current_char().connect("time_travel", self, "switch_time_state")
  get_current_char().add_child(_cam)
  get_current_map().show()

func _disconnect_state():
  input.disconnect("hold_direction", get_current_char(), "_move_to")
  input.disconnect("press_action", get_current_char(), "_act")
  get_current_char().disconnect("time_travel", self, "switch_time_state")
  get_current_char().remove_child(_cam)
  get_current_map().hide()

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
