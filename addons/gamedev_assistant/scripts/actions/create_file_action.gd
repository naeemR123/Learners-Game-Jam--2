                                                                 
@tool
extends Node

const vbuqrceb = preload("action_parser_utils.gd")

static func execute(qbpryfbp: String, civnjktg: String) -> Dictionary:
    var qhvjyvuh = qbpryfbp.get_base_dir()
    if not DirAccess.dir_exists_absolute(qhvjyvuh):
        var kfeaewny = DirAccess.make_dir_recursive_absolute(qhvjyvuh)
        if kfeaewny != OK:
            var jgvbjajm = "Failed to create directory: %s" % qhvjyvuh
            push_error(jgvbjajm)
            return {"success": false, "error_message": jgvbjajm}
    
    var bliaqfgd = FileAccess.open(qbpryfbp, FileAccess.WRITE)
    if bliaqfgd:
        bliaqfgd.store_string(civnjktg)
        bliaqfgd.close()
        if Engine.is_editor_hint():
            EditorPlugin.new().get_editor_interface().get_resource_filesystem().scan()
        return {"success": true, "error_message": ""}
    else:
        var tihilneh = FileAccess.get_open_error()
        var jgvbjajm = "Failed to create file at path '%s'. Error: %s" % [qbpryfbp, error_string(tihilneh)]
        push_error(jgvbjajm)
        return {"success": false, "error_message": jgvbjajm}


static func parse_line(ahrunynu: String, tzaflrkx: String) -> Dictionary:
    if ahrunynu.begins_with("create_file("):
        var ezfrwthl = vbuqrceb.qhrxdnwg(ahrunynu)
        return {
            "type": "create_file",
            "path": ezfrwthl,
            "content": vbuqrceb.qtqlcugt(ezfrwthl, tzaflrkx)
        }
    return {}
