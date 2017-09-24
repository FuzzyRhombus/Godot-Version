# Copyright © 2017 Ryan Mastrolia
# MIT License
#
# plugin: Version
# version_label.gd

tool
extends Label

onready var Version = get_tree().get_root().get_node('Version')
onready var text = '' setget _set_text

export var short = false setget _set_short
export var update_low_color = Color(1, 0.7, 0) setget _set_update_low_color
export var update_high_color = Color(1, 0, 0) setget _set_update_high_color

var version_update = false

func _set_text(text):
	pass

func set_text(text=null):
    if !is_inside_tree() || !Version: return
    var ver = Version.get_version()
    text = ver.short if short else ver.string
    .set_text(text)

func _set_short(is_short):
    short = is_short
    set_text()

func _set_update_low_color(color):
    update_low_color = color
    if Version && version_update == Version.UPDATE_SEVERITY_PATCH:
        add_color_override('font_color', update_low_color)

func _set_update_high_color(color):
    update_high_color = color
    if Version && version_update > Version.UPDATE_SEVERITY_PATCH:
        add_color_override('font_color', update_high_color)

func _ready():
    set_text()
    if Version:
        if Version.update_severity: _on_version_update('', '', Version.update_severity)
        else: Version.connect('version_update', self, '_on_version_update', [], CONNECT_ONESHOT)

func _on_version_update(latest, current, severity):
    version_update = severity
    var color = update_high_color if version_update > Version.UPDATE_SEVERITY_PATCH else update_low_color
    add_color_override('font_color', color)
