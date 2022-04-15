extends Control

export (PackedScene) var Main

onready var MessageLabel = find_node("MessageLabel")
onready var DelayTimer = find_node("DelayTimer")

var isMinerPresent : bool
var currentMinerVersion : String
var latestMinerVersion : String

var _on_miner_get_metadata_callback_ref := JavaScript.create_callback(self, "_on_miner_get_metadata_callback")
var _on_miner_download_callback_ref := JavaScript.create_callback(self, "_on_miner_download_callback")

func _ready() -> void:
	yield(get_tree().create_timer(2), "timeout")
	Global.window.ipcRenderer.on('miner:get-metadata', _on_miner_get_metadata_callback_ref)
	Global.window.ipcRenderer.on('miner:download', _on_miner_download_callback_ref)
	Global.window.miner.getMetadata()

func _on_miner_get_metadata_callback(args) -> void:
	var metadata = args[1]
	isMinerPresent = metadata.isMinerPresent
	if isMinerPresent:
		currentMinerVersion = metadata.currentMinerVersion
		latestMinerVersion = metadata.latestMinerVersion
	_update_miner_start()

func _update_miner_start() -> void:
	if isMinerPresent:
		if currentMinerVersion and latestMinerVersion:
			if currentMinerVersion < latestMinerVersion:
				_show_message("Updating...")
				Global.window.miner.download()
			else:
				_update_miner_finish()
		else:
			pass
	else:
		_show_message("Updating...")
		Global.window.miner.download()

func _on_miner_download_callback(args) -> void:
	var success = args[1]
	if success:
		_update_miner_finish()
	else:
		pass

func _show_message(message: String) -> void:
	MessageLabel.text = message
	MessageLabel.show()

func _update_miner_finish() -> void:
	yield(get_tree().create_timer(2), "timeout")
	get_tree().change_scene_to(Main)
