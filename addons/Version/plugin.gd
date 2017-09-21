# plugin: Version
# plugin.gd

tool
extends EditorPlugin

const PLUGIN_PATH =                 'addons/Version'
const VERSION_PATH = 				'application/version'
const VERSION_MAJOR_DEFAULT =       1
const VERSION_MINOR_DEFAULT =       0
const VERSION_PATCH_DEFAULT =       0

func _init():
    if !Globals.has(VERSION_PATH):
        Globals.set(VERSION_PATH + '/major', VERSION_MAJOR_DEFAULT)
        Globals.set(VERSION_PATH + '/minor', VERSION_MINOR_DEFAULT)
        Globals.set(VERSION_PATH + '/patch', VERSION_PATCH_DEFAULT)
        Globals.set_persisting(VERSION_PATH + '/major', true)
        Globals.set_persisting(VERSION_PATH + '/minor', true)
        Globals.set_persisting(VERSION_PATH + '/patch', true)
        Globals.save()

func _enter_tree():
    pass

func _exit_tree():
    pass
