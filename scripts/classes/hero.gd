
extends "res://scripts/classes/monster.gd"

const DIR = preload("res://scripts/utility/directions.gd")

onready var sprite = get_node("sprite")
onready var hitbox = get_node("hitbox")
onready var pocket = get_node("pocket")

signal time_travel
signal interact

var grabbing = false
var tmp_object

func _move_to(dir):
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
  set_rotd(angle)
  sprite.set_rotd(-angle)
  pocket.set_rotd(-angle)

func attach_object(body):
  body.set_pos(Vector2(0,-80))
  body.set_collision_mask(0)
  body.set_layer_mask(0)
  pocket.add_child(body)

func detach_object(body):
  grabbing = false
  body.set_pos(get_pos())
  body.set_collision_mask(15)
  body.set_layer_mask(3)
  get_parent().add_child(body)

func get_pocket_item():
  return tmp_object

func grab(body):
  if !grabbing:
    grabbing = true
    tmp_object = body
    body.get_parent().remove_child(body)
    call_deferred("attach_object", body)

func _act(act):
  printt("act=", act)
  if act == 0:
    if grabbing:
      pocket.remove_child(tmp_object)
      call_deferred("detach_object", tmp_object)
    else:
      var range_bodies = hitbox.get_overlapping_bodies()
      printt("bodies=", range_bodies)
      for body in range_bodies:
        if body.has_method("interact"):
          body.interact(self)
          break
    emit_signal("interact")
  elif act == 2:
    emit_signal("time_travel")
