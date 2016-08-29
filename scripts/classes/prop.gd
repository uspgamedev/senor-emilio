
extends StaticBody2D

var _mask


func _stage():
  var parent = get_parent()
  while parent.get_name() != "past" and parent.get_name() != "future":
    parent = parent.get_parent()
  return parent

func _ready():
  var parent = _stage()
  var timezone = parent.get_name()
  if timezone == "future":
    _mask = 1
  elif timezone == "past":
    _mask = 2
  activate_collision()

func activate_collision():
  set_layer_mask(_mask)
  set_collision_mask(_mask)

func deactivate_collision():
  set_layer_mask(0)
  set_collision_mask(0)
