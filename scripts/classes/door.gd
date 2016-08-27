
extends "res://scripts/classes/prop.gd"

const Hero = preload("res://scripts/classes/hero.gd")

onready var lock = get_node("lock")
onready var anim = get_node("lock/AnimationPlayer")

export(int) var target_stage = 0
export(String) var target_door = "door"
export(String) var key_required = null
export(bool) var start_opened = true

signal change_stage(which, door)

var locked = false

func _ready():
  if start_opened:
    open()
  else:
    close()
  if key_required != null:
    locked = true
  else:
    locked = false

func open():
  if anim.get_current_animation() != "opened":
    print("door open")
    anim.play("opening")
    anim.queue("opened")
    deactivate_collision()

func close():
  if anim.get_current_animation() != "closed":
    print("door closed")
    anim.play("closing")
    anim.queue("closed")
    activate_collision()

func is_closed():
  return anim.get_current_animation() != "opened"

func unlock(key):
  if key != null and key.get_name() == key_required:
    locked = false
    return true
  return false

func on():
  if key_required != null and locked:
    return
  open()

func get_spawn_pos():
  return get_node("spawn").get_global_pos()

func off():
  close()

func _teleport(body):
  if body.get_script() == Hero and anim.get_current_animation() == "opened":
    get_node("/root/main/gameplay")._change_stage(target_stage, target_door)
    printt(get_name(), "door used!", body.get_name())

func interact(body):
  #emit_signal("change_stage", target_stage,  target_door)
  if locked:
    if body.get_pocket_item() != null:
      if unlock(body.get_pocket_item()):
        body.drop()
