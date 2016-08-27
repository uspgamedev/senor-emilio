
extends "res://scripts/classes/prop.gd"

export(NodePath) var device = null

onready var on = get_node("On")
onready var off = get_node("Off")

func on():
  if on.is_hidden():
    return false
  return true

func _get_device():
  return get_node(device)

func turn_on_off():
  printt("turn")
  if on():
    off.show()
    on.hide()
    _get_device().off()
  else:
    off.hide()
    on.show()
    _get_device().on()

func interact(body):
  turn_on_off()
