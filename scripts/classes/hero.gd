
extends "res://scripts/classes/monster.gd"

const DIR = preload("res://scripts/utility/directions.gd")

onready var sprite = get_node("sprite")
onready var hitbox = get_node("hitbox")
onready var pocket = get_node("pocket")

signal time_travel
signal interact
signal grab()
signal drop(item)
signal just_drop

var grabbing = false
var tmp_object
var freeze = false

func _move_to(dir):
  if freeze:
    return
  ._move_to(dir)
  var angle = 0
  if direction == DIR.UP:
    angle = 180
  elif direction == DIR.DOWN:
    angle = 0
  elif direction == DIR.LEFT:
    angle = 270
  elif direction == DIR.RIGHT:
    angle = 90
  hitbox.set_rotd(angle)

func get_front():
  return hitbox.get_relative_transform_to_parent(self).y

func attach_object(body):
  body.set_pos(Vector2(0,-48))
  body.set_collision_mask(0)
  body.set_layer_mask(0)
  pocket.add_child(body)

func detach_object(body):
  body.set_pos(get_pos() + get_front()*32)
  body.set_collision_mask(get_collision_mask())
  body.set_layer_mask(get_layer_mask())
  get_parent().add_child(body)

func get_pocket_item():
  return tmp_object

func grab(body):
  if !grabbing:
    grabbing = true
    tmp_object = body
    if body.get_parent() != null:
      body.get_parent().remove_child(body)
    emit_signal("grab")
    call_deferred("attach_object", body)

func drop():
  if grabbing:
    pocket.remove_child(tmp_object)
    grabbing = false
    emit_signal("just_drop")
    call_deferred("emit_signal", "drop", tmp_object)

func _act(act):
  printt("act=", act)
  if act == 0:
    var acted = false
    var range_bodies = hitbox.get_overlapping_bodies()
    printt("bodies=", range_bodies)
    for body in range_bodies:
      if body.has_method("interact"):
        body.interact(self)
        acted = true
        break
    if !acted and grabbing:
      drop()
      call_deferred("detach_object", tmp_object)
    emit_signal("interact")
  elif act == 2:
    emit_signal("time_travel")

func freeze():
  freeze = true

func unfreeze():
  freeze = false