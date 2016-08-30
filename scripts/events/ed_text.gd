
extends Node

const DIR = preload("res://scripts/utility/directions.gd")

signal dialogue_end

var granny
var kitty
var camera
var timer
var tween
var blackscreen
var reader

var progress = 0

func _ready():
    # setup event vars
    self.granny = get_node("hall/bodies/granny")
    self.kitty = get_node("hall/bodies/kitty")
    self.camera = get_node("hall/bodies/camera")
    self.timer = get_node("timer")
    self.tween = get_node("tween")
    self.blackscreen = get_node("blackscreen")
    self.reader = get_node("/root/main/HUD")
    timer.set_wait_time(1.5)
    timer.start()

func call_dialogue(number):
    reader.connect("dialogue_end", self, "_on_dialog_end")
    reader.init_dialog(get_node("dialogue/" + number))

func fade_to_black():
    tween.interpolate_method( blackscreen, "set_color", blackscreen.get_color(), Color(0, 0, 0, 0), 3.0, tween.TRANSLINEAR, tween.EASE_OUT, 0)
    tween.start()
    yield(tween, "tween_complete")


func _on_timer_timeout():
    if progress == 0:
        call_dialogue("one")
    elif progress == 1:
        call_dialogue("two")

func _on_dialog_end():
    reader.disconnect("dialogue_end", self, "_on_dialog_end")
    if progress == 0:
        # move granny down, face her left
        tween.interpolate_method( granny, "move_to", granny.get_pos(), granny.get_pos() + Vector2(0,8*16), 1.5, tween.TRANSLINEAR, tween.EASE_OUT, 0)
        tween.start()
        yield(tween, "tween_complete")
        granny.face(DIR.LEFT)

        # continue scene
        progress += 1
        timer.set_wait_time(0.5)
        timer.start()
    elif progress == 1:
        fade_to_black()
