
extends "res://scripts/classes/prop.gd"

const Hero = preload("res://scripts/classes/hero.gd")

var _open = false

onready var lock = get_node("lock")
onready var anim = get_node("lock/AnimationPlayer")
onready var teleport = get_node("teleport")

export(int) var target_stage = 0
export(String) var target_door = "door"
export(String) var key_required = null
export(bool) var start_opened = true

signal change_stage(which, door)

func _ready():
  if start_opened or _open:
    open()
  elif !_open:
    close()
  printt("mask", _mask)
  printt("open", _open)
  teleport.set_layer_mask(_mask)
  teleport.set_collision_mask(_mask)

func open():
  print("door open")
  anim.play("opening")
  anim.queue("opened")
  deactivate_collision()
  _open = true
  set_fixed_process(true)

func close():
  print("door closed")
  anim.play("closing")
  anim.queue("closed")
  activate_collision()
  _open = false
  set_fixed_process(false)

func is_closed():
  return anim.get_current_animation() != "opened"

func unlock(key):
  if key != null and key.get_name() == key_required:
    open()
    return true
  return false

func on():
  open()

func get_spawn_pos():
  return get_node("spawn").get_global_pos() / 2

func off():
  close()

func _fixed_process(dt):
  var bodies = teleport.get_overlapping_bodies()
  if bodies.size() > 0:
    for body in bodies:
      if body.has_method("get_layer_mask") and body.get_layer_mask() == teleport.get_collision_mask():
        _teleport(body)

func _teleport(body):
  printt(get_path(), "teleport!", body.get_path())
  if is_inside_tree() and body.get_script() == Hero and anim.get_current_animation() == "opened":
    printt(get_path(), "door used!", target_stage, target_door)
    get_node("/root/main/gameplay")._change_stage(target_stage, target_door)

func interact(body):
  #emit_signal("change_stage", target_stage,  target_door)
  if is_closed() and body.get_pocket_item() != null:
    if unlock(body.get_pocket_item()):
      body.drop()
