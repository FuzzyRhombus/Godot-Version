# plugin: Version
# version.gd

extends Node

const VERSION_PATH = 				'application/version/'
const VERSION_MAJOR =				1
const VERSION_MINOR =				0
const VERSION_PATCH =				0

onready var major = Globals.get(VERSION_PATH + 'major') setget _set_major
onready var minor = Globals.get(VERSION_PATH + 'minor') setget _set_minor
onready var patch = Globals.get(VERSION_PATH + 'patch') setget _set_patch

onready var engine = OS.get_engine_version()
onready var os = OS.get_name().to_lower().substr(0, 3)
onready var debug = OS.is_debug_build()

var version = null setget , get_version

func get_version():
	if version != null: return version
	var e_string = '%s.%s.%s%s' % [engine.major, engine.minor, engine.patch, engine.status.to_lower().substr(0, 3)]
	var v_string = 'v%d.%d.%d.%s/%s' % [major, minor, patch, os, e_string]
	if debug: v_string += '~dbg'
	version = {
		major = major,
		minor = minor,
		patch = patch,
		os = os,
		debug = debug,
		engine = engine,
		string = v_string,
		short = '%d.%d.%d' % [major, minor, patch]
	}
	return version

func _set_major(n):
	pass

func _set_minor(n):
	pass

func _set_patch(n):
	pass

func _ready():
	print(get_version().string)
