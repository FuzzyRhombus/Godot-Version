# Copyright © 2017 Ryan Mastrolia
# MIT License
#
# plugin: Version
# version_checker.gd

extends HTTPRequest

const ITUNES_URL = 				'https://itunes.apple.com/lookup/?id='
const PLAY_STORE_URL = 			'https://play.google.com/store/apps/details?id='
const IOS_DOWNLOAD_URL =		'itms-apps://itunes.apple.com/app/%s/id%s'
const ANDROID_DOWNLOAD_URL =	'market://details?id='

onready var timer = Timer.new()
onready var is_ios = Version.version.os == 'ios'
onready var is_android = Version.version.os == 'and'

export var auto_check = true
export var free_on_success = true
export var retry_time = 500	setget _set_retry_time
export var max_retry = 10 setget _set_max_retry
export(String) var ios_app_id = null
export(String) var android_bundle_id = null

var regex = RegEx.new()
var retry_count = 0
var app_store_data

signal update_found(latest_version, current_version, severity, update_url)
signal error(error, http_code, parse_error)

func parse_app_store_version(data):
	var dict = {}
	var res = dict.parse_json(data)
	if res || !dict.has('results') || !dict.results.size(): return 0
	app_store_data = dict.results[0]
	return app_store_data.version

func parse_play_store_version(data):
	var markup = 'itemprop="softwareVersion"'
	var index = data.find(markup, 50000)
	if index < 0: return 0
	regex.find(data, index, 64)
	var captures = regex.get_captures()
	return captures[0] if captures.size() && captures[0] else 0

func check_update(force=true):
	if force:
		retry_count = 0
		timer.stop()
	if retry_count >= max_retry: return
	retry_count += 1
	if is_ios && ios_app_id: request(ITUNES_URL + ios_app_id)
	elif is_android && android_bundle_id: request(PLAY_STORE_URL + android_bundle_id)

func fail(error, code, parse_error):
	emit_signal('error', error, code, parse_error)
	timer.start()

func _set_retry_time(time):
	retry_time = time
	if timer: timer.set_wait_time(retry_time/1000.0)

func _set_max_retry(retry):
	max_retry = max(0, floor(retry))

func _ready():
	regex.compile('[\\d|\\.]+')
	timer.set_wait_time(retry_time/1000.0)
	timer.set_one_shot(true)
	add_child(timer)
	connect('request_completed', self, '_on_request_completed')
	timer.connect('timeout', self, '_on_timer_timeout')
	Version.connect('version_update', self, '_on_version_update', [], CONNECT_ONESHOT)
	if auto_check: check_update()

func _on_request_completed( result, response_code, headers, body ):
	if result != HTTPRequest.RESULT_SUCCESS || response_code != 200 || body == null: return fail(result, response_code, false)
	var data = body.get_string_from_utf8()
	var latest = parse_app_store_version(data) if is_ios else parse_play_store_version(data)
	if !latest: return fail(result, response_code, true)
	Version.compare_latest(latest)
	if free_on_success: queue_free()

func _on_timer_timeout():
	check_update(false)

func _on_version_update(latest, current, severity):
	var url = ''
	if is_ios && ios_app_id && app_store_data != null: url = IOS_DOWNLOAD_URL % [app_store_data.trackName, ios_app_id]
	elif is_android && android_bundle_id: url = ANDROID_DOWNLOAD_URL + android_bundle_id
	emit_signal('update_found', latest, current, severity, url)
