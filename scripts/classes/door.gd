
extends "res://scripts/classes/prop.gd"

const Hero = preload("res://scripts/classes/hero.gd")

var _open = false

onready var lock = get_node("lock")
onready var anim = get_node("lock/AnimationPlayer")
onready var teleport = get_node("teleport")

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

func close():
  print("door closed")
  anim.play("closing")
  anim.queue("closed")
  activate_collision()
  _open = false

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

func interact(body):
  if is_closed() and body.get_pocket_item() != null:
    if unlock(body.get_pocket_item()):
      body.drop()
