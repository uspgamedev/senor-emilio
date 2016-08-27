extends StaticBody2D

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
    anim.play("opened")
  else:
    anim.play("closed")
  if key_required != null:
    locked = true
  else:
    locked = false

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
  print("door open")
  anim.play("opening")
  anim.queue("opened")

func get_spawn_pos():
  return get_node("spawn").get_global_pos()

func off():
  print("door closed")
  anim.play("closing")
  anim.queue("closed")

func interact(body):
  #emit_signal("change_stage", target_stage,  target_door)
  if locked:
    if body.get_pocket_item() != null:
      if unlock(body.get_pocket_item()):
        body.drop()
    return
  if anim.get_current_animation() == "opened":
    get_node("/root/main/gameplay")._change_stage(target_stage, target_door)
    printt(get_name(), "door used!", body.get_name())
