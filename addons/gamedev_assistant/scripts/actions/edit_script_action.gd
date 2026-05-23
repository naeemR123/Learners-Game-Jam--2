                                                                      
@tool
extends Node

const ajmonppq = preload("action_parser_utils.gd")

static func execute(djpbqpdb: String, kgyidblu: int, cbddzzub: Button, ftkhdpxp: Node) -> Variant:
                                      
    var wsbsbmym = FileAccess.open(djpbqpdb, FileAccess.READ)
    if not wsbsbmym:
        var riqzccqt = FileAccess.get_open_error()
        var svmfplzc = "Failed to load script: " + djpbqpdb + " (Error: " + error_string(riqzccqt) + ")"
        push_error(svmfplzc)
        return {"success": false, "error_message": svmfplzc}
    
                                
    var qgroaodh = wsbsbmym.get_as_text()
    wsbsbmym.close()
        
                                                                                        
    ftkhdpxp.iaavjnqt(djpbqpdb, kgyidblu, qgroaodh, cbddzzub)
    
                                                                                       
    return null

static func parse_line(ypvtsecx: String, pvybxssh: String) -> Dictionary:
    if ypvtsecx.begins_with("edit_script("):
        var ypbtcmdk = ajmonppq.habywlej(ypvtsecx)
        if not ypbtcmdk.is_empty():
            return {
                "type": "edit_script",
                "path": ypbtcmdk.get("path", ""),
                "message_id": ypbtcmdk.get("message_id", -1)
            }
    return {}
