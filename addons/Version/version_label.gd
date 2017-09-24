# Copyright © 2017 Ryan Mastrolia
# MIT License
#
# plugin: Version
# version_label.gd

tool
extends Label

onready var version = get_tree().get_root().get_node('version')
onready var text = '' setget _set_text

export var short = false setget _set_short
export var update_low_color = Color(1, 0.7, 0) setget _set_update_low_color
export var update_high_color = Color(1, 0, 0) setget _set_update_high_color

var version_update = false

func _set_text(text):
	pass

func set_text(text=null):
    if !is_inside_tree() || !version: return
    var ver = version.get_version()
    text = ver.short if short else ver.string
    .set_text(text)

func _set_short(is_short):
    short = is_short
    set_text()

func _set_update_low_color(color):
    update_low_color = color
    if version && version_update == version.UPDATE_SEVERITY_PATCH:
        add_color_override('font_color', update_low_color)

func _set_update_high_color(color):
    update_high_color = color
    if version && version_update > version.UPDATE_SEVERITY_PATCH:
        add_color_override('font_color', update_high_color)

func _ready():
    set_text()
    if version:
        if version.update_severity: _on_version_update('', '', version.update_severity)
        else: version.connect('version_update', self, '_on_version_update', [], CONNECT_ONESHOT)

func _on_version_update(latest, current, severity):
    version_update = severity
    var color = update_high_color if version_update > version.UPDATE_SEVERITY_PATCH else update_low_color
    add_color_override('font_color', color)
