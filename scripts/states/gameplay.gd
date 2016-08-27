
extends Node2D

const Door = preload("res://scripts/classes/door.gd")

onready var STAGES = [
  preload("res://resources/maps/stage1.tscn").instance(),
  preload("res://resources/maps/stage2.tscn").instance(),
]

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
    for stage in STAGES:
      for body in stage.get_node("future/bodies").get_children():
        if body.get_script() == Door:
          printt(body.get_name(), "door detected!")
          body.connect("change_stage", self, "_change_stage")
      for body in stage.get_node("past/bodies").get_children():
        if body.get_script() == Door:
          body.connect("change_stage", self, "_change_stage")
    _change_stage(0,"door_1")

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
  var door = get_current_map().get_node("bodies").get_node(door_name)
  if door.is_closed():
    return
  
  printt(get_name(), "received request to change stage", which, door_name)
  _disconnect_state()
  remove_child(get_node("stage"))
  yield(get_tree(), "fixed_frame")
  add_child(STAGES[which])
  _setup()
  _connect_state()
  
  get_current_char().set_pos(door.get_spawn_pos())

func _connect_state():
  input.connect("hold_direction", get_current_char(), "_move_to")
  input.connect("press_action", get_current_char(), "_act")
  get_current_char().connect("time_travel", self, "switch_time_state")
  get_current_char().add_child(_cam)
  get_current_map().show()
  get_current_map().set_collision_layer(1)

func _disconnect_state():
  input.disconnect("hold_direction", get_current_char(), "_move_to")
  input.disconnect("press_action", get_current_char(), "_act")
  get_current_char().disconnect("time_travel", self, "switch_time_state")
  get_current_char().remove_child(_cam)
  get_current_map().hide()
  get_current_map().set_collision_layer(0)

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
