
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
  if direction == DIR.UP:
    set_rotd(180)
    sprite.set_rotd(-180)
  elif direction == DIR.DOWN:
    set_rotd(0)
    sprite.set_rotd(0)
  elif direction == DIR.LEFT:
    set_rotd(270)
    sprite.set_rotd(-270)
  elif direction == DIR.RIGHT:
    set_rotd(90)
    sprite.set_rotd(-90)

func attach_object(body):
  body.set_pos(Vector2(20,0))
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

func _act(act):
  printt("act=", act)
  if act == 0:
    if grabbing:
      pocket.remove_child(tmp_object)
      call_deferred("detach_object", tmp_object)
    var range_bodies = hitbox.get_overlapping_bodies()
    printt("bodies=", range_bodies)
    for body in range_bodies:
      if body.get_name() == "box":
        if !grabbing:
          grabbing = true
          tmp_object = body
          body.get_parent().remove_child(body)
          call_deferred("attach_object", body)
    emit_signal("interact")
  elif act == 2:
    emit_signal("time_travel")
