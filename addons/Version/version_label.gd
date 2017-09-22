# plugin: Version
# version_label.gd

tool
extends Label

onready var version = get_tree().get_root().get_node('version')
onready var text = '' setget _set_text

export var short = false setget _set_short

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

func _ready():
    set_text()
