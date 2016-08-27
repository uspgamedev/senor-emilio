extends StaticBody2D

onready var closed = get_node("closed")
onready var opened = get_node("opened")

export(int) var target_stage = 0
export(String) var target_door = "door"
export(String) var key_required = null
export(bool) var start_opened = true

signal change_stage(which, door)

var locked = false

func _ready():
  if start_opened:
    opened.show()
    closed.hide()
  else:
    opened.hide()
    closed.show()
  if key_required != null:
    locked = true
  else:
    locked = false

func is_closed():
  return opened.is_hidden()

func unlock(key):
  if key != null and key.get_name() == key_required:
    locked = false
    return true
  return false

func on():
  if key_required != null and locked:
    return
  print("door open")
  opened.show()
  closed.hide()

func get_spawn_pos():
  return get_node("spawn").get_global_pos()

func off():
  print("door closed")
  opened.hide()
  closed.show()

func interact(body):
  #emit_signal("change_stage", target_stage,  target_door)
  if locked:
    if body.get_pocket_item() != null:
      if unlock(body.get_pocket_item()):
        body.drop()
    return
  get_node("/root/main/gameplay")._change_stage(target_stage, target_door)
  printt(get_name(), "door used!", body.get_name())
