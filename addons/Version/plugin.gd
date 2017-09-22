# plugin: Version
# plugin.gd

tool
extends EditorPlugin

const PLUGIN_PATH =                 'addons/Version'
const VERSION_PATH = 				'application/version'
const VERSION_MAJOR_DEFAULT =       1
const VERSION_MINOR_DEFAULT =       0
const VERSION_PATCH_DEFAULT =       0
const AUTOLOAD_NAME =               'autoload/version'
const AUTOLOAD_PATH =               '*res://' + PLUGIN_PATH + '/version.gd'

const Version = preload('version.gd')

var version

func _init():
    if !Globals.has(VERSION_PATH + '/major'):
        Globals.set(VERSION_PATH + '/major', VERSION_MAJOR_DEFAULT)
        Globals.set(VERSION_PATH + '/minor', VERSION_MINOR_DEFAULT)
        Globals.set(VERSION_PATH + '/patch', VERSION_PATCH_DEFAULT)
        Globals.set_persisting(VERSION_PATH + '/major', true)
        Globals.set_persisting(VERSION_PATH + '/minor', true)
        Globals.set_persisting(VERSION_PATH + '/patch', true)
        Globals.save()

func _enter_tree():
    if !Globals.has(AUTOLOAD_NAME):
        Globals.set(AUTOLOAD_NAME, AUTOLOAD_PATH)
        Globals.set_persisting(AUTOLOAD_NAME, true)
        Globals.save()
    add_custom_type('VersionLabel', 'Label', preload('version_label.gd'), preload('versionlabel-icon.png'))
    version = Version.new()
    version.set_name('version')
    get_tree().get_root().add_child(version)

func _exit_tree():
    Globals.set(AUTOLOAD_NAME, null)
    remove_custom_type('VersionLabel')
    if version: get_tree().get_root().remove_child(version)
    version = null
