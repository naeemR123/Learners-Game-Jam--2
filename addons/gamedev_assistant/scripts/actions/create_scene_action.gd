                                                                  
@tool
extends Node

const waldtknq = preload("action_parser_utils.gd")

static func execute(pmskhkpq: String, pjlkjxlv: String, wiskjgny: String) -> Dictionary:
    var bctckpaz = pmskhkpq.get_base_dir()
    if not DirAccess.dir_exists_absolute(bctckpaz):
        var lntwtecs = DirAccess.make_dir_recursive_absolute(bctckpaz)
        if lntwtecs != OK:
            var lwqrlito = "Failed to create directory: %s" % bctckpaz
            push_error(lwqrlito)
            return {"success": false, "error_message": lwqrlito}
    
    if !ClassDB.class_exists(wiskjgny):
        var lwqrlito = "Root node type '%s' does not exist." % wiskjgny
        push_error(lwqrlito)
        return {"success": false, "error_message": lwqrlito}
    
    var ujajeeio = PackedScene.new()
    var fcpuqymw = ClassDB.instantiate(wiskjgny)
    fcpuqymw.name = pjlkjxlv
    ujajeeio.pack(fcpuqymw)
    
    var ddbqskaz = ResourceSaver.save(ujajeeio, pmskhkpq)
    if ddbqskaz == OK:
        if Engine.is_editor_hint():
            EditorPlugin.new().get_editor_interface().get_resource_filesystem().scan()
        return {"success": true, "error_message": ""}
    else:
        var lwqrlito = "Failed to save scene to path: %s" % pmskhkpq
        push_error(lwqrlito)
        return {"success": false, "error_message": lwqrlito}

static func parse_line(leyrckxv: String, nkaioniz: String) -> Dictionary:
    if leyrckxv.begins_with("create_scene("):
        var ozetikzo = waldtknq.qbzxismr(leyrckxv)
        if ozetikzo.size() >= 3:
            return {
                "type": "create_scene",
                "path": ozetikzo[0],
                "root_name": ozetikzo[1],
                "root_type": ozetikzo[2]
            }
    return {}
