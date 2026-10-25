class_name C3ChapterState
extends Resource
## Stable progress identifiers are content IDs, never scene node paths.
const SAVE_VERSION := 1
const FLAG_CATEGORIES := [&"opened_chests", &"fragments", &"keys", &"switches", &"unlocked_doors", &"solved_puzzles", &"defeated_bosses"]
@export var opened_chests: Dictionary = {}
@export var fragments: Dictionary = {}
@export var keys: Dictionary = {}
@export var switches: Dictionary = {}
@export var unlocked_doors: Dictionary = {}
@export var solved_puzzles: Dictionary = {}
@export var defeated_bosses: Dictionary = {}
@export var water_levels: Dictionary = {}
@export var mirrors: Dictionary = {}
@export var inventory: Dictionary = {}
@export var checkpoint_id := ""
@export var chapter_completed := false
@export var player_health := 5
@export var player_vitality := 100

static func valid_id(value: String) -> bool:
	if value.is_empty() or value.length() > 128: return false
	if not value[0].to_lower() in "abcdefghijklmnopqrstuvwxyz0123456789": return false
	for character in value:
		if not (character.to_lower() in "abcdefghijklmnopqrstuvwxyz0123456789_.:-"): return false
	return true

func set_flag(category: StringName, id: String, value: bool = true) -> bool:
	if not category in FLAG_CATEGORIES or not valid_id(id): return false
	var flags: Dictionary = get(category)
	flags[id] = value
	emit_changed()
	return true

func has_flag(category: StringName, id: String) -> bool:
	if not category in FLAG_CATEGORIES: return false
	return get(category).get(id, false) == true

func to_dictionary() -> Dictionary:
	var data := {"water_levels": water_levels.duplicate(true), "mirrors": mirrors.duplicate(true), "inventory": inventory.duplicate(true), "checkpoint_id": checkpoint_id, "chapter_completed": chapter_completed, "player_health": player_health, "player_vitality": player_vitality}
	for category in FLAG_CATEGORIES: data[String(category)] = get(category).duplicate(true)
	return data

func restore_dictionary(data: Dictionary) -> Error:
	# Validate the entire snapshot before mutating an in-memory run.
	for category in FLAG_CATEGORIES:
		if not data.get(String(category)) is Dictionary: return ERR_INVALID_DATA
		for id in data[String(category)]:
			if not id is String or not valid_id(id) or not data[String(category)][id] is bool: return ERR_INVALID_DATA
	for category in ["water_levels", "mirrors", "inventory"]:
		if not data.get(category) is Dictionary: return ERR_INVALID_DATA
		for id in data[category]:
			if not id is String or not valid_id(id): return ERR_INVALID_DATA
			var value = data[category][id]
			if category == "water_levels":
				if not value is String or not valid_id(value): return ERR_INVALID_DATA
			elif not _whole_nonnegative(value): return ERR_INVALID_DATA
	if not data.get("checkpoint_id") is String: return ERR_INVALID_DATA
	if not data.checkpoint_id.is_empty() and not valid_id(data.checkpoint_id): return ERR_INVALID_DATA
	if not data.get("chapter_completed") is bool: return ERR_INVALID_DATA
	if not _whole_nonnegative(data.get("player_health")) or not _whole_nonnegative(data.get("player_vitality")): return ERR_INVALID_DATA
	# Completed saves require explicit victory evidence, with no invented collection threshold.
	if data.chapter_completed and not data.defeated_bosses.values().has(true): return ERR_INVALID_DATA
	for key in data:
		if key in to_dictionary(): set(key, data[key].duplicate(true) if data[key] is Dictionary else data[key])
	for category in [mirrors, inventory]:
		for id in category: category[id] = int(category[id])
	player_health = int(data.player_health)
	player_vitality = int(data.player_vitality)
	emit_changed()
	return OK

static func _whole_nonnegative(value: Variant) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and float(value) >= 0.0 and float(value) == floorf(float(value)) and float(value) <= 2147483647.0

func save_atomic(path: String) -> Error:
	var snapshot := to_dictionary()
	var check_state := C3ChapterState.new()
	if check_state.restore_dictionary(snapshot) != OK: return ERR_INVALID_DATA
	var payload := JSON.stringify(snapshot)
	var serialized := JSON.stringify({"version": SAVE_VERSION, "payload": payload, "sha256": payload.sha256_text()})
	var temporary := path + ".tmp"
	var file := FileAccess.open(temporary, FileAccess.WRITE)
	if file == null: return FileAccess.get_open_error()
	file.store_string(serialized)
	file.flush()
	var error := file.get_error()
	file.close()
	if error != OK:
		DirAccess.remove_absolute(temporary)
		return error
	# Same-directory rename is atomic: a failed write never destroys the previous save.
	error = DirAccess.rename_absolute(temporary, path)
	if error != OK: DirAccess.remove_absolute(temporary)
	return error

func load_save(path: String) -> Error:
	if not FileAccess.file_exists(path): return ERR_FILE_NOT_FOUND
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null: return FileAccess.get_open_error()
	if file.get_length() > 4 * 1024 * 1024:
		file.close()
		return ERR_INVALID_DATA
	var parser := JSON.new()
	var parse_error := parser.parse(file.get_as_text())
	file.close()
	if parse_error != OK: return ERR_INVALID_DATA
	var decoded = parser.data
	if not decoded is Dictionary or decoded.get("version") != SAVE_VERSION: return ERR_INVALID_DATA
	if not decoded.get("payload") is String or not decoded.get("sha256") is String: return ERR_INVALID_DATA
	if decoded.payload.sha256_text() != decoded.sha256: return ERR_INVALID_DATA
	if parser.parse(decoded.payload) != OK: return ERR_INVALID_DATA
	var snapshot = parser.data
	if not snapshot is Dictionary: return ERR_INVALID_DATA
	return restore_dictionary(snapshot)

func complete_after_victory(boss_id: String, save_path: String) -> Error:
	if not has_flag(&"defeated_bosses", boss_id): return ERR_UNAVAILABLE
	var was_complete := chapter_completed
	chapter_completed = true
	var error := save_atomic(save_path)
	if error != OK: chapter_completed = was_complete
	else: emit_changed()
	return error
