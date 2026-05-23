                                                                      
@tool
extends Node

const ebmsdhxr = preload("action_parser_utils.gd")
                                                                            
                                                   
const rvzeaoum = preload("add_subresource_action.gd")

static func execute(egccjgls: String, qggquvix: String, wlbkvmwi: String, szfigcqp: Dictionary) -> Dictionary:
    var sulmeokt = EditorPlugin.new().get_editor_interface()
    var ldfmfouh = sulmeokt.get_open_scenes()

                                   
    for scene in ldfmfouh:
        if scene == qggquvix:
                                                                    
            sulmeokt.reload_scene_from_path(qggquvix)
            return _edit_in_open_scene(egccjgls, sulmeokt.get_edited_scene_root(), wlbkvmwi, szfigcqp)

                                           
                                                              
    return _edit_in_closed_scene(egccjgls, qggquvix, wlbkvmwi, szfigcqp)


static func _edit_in_open_scene(jxruvtjb: String, njhyjmba: Node, lhkudfcz: String, wkxujvfd: Dictionary) -> Dictionary:
    var emzkbydj = rvzeaoum.ftcztpyy(jxruvtjb, njhyjmba)               
    if not emzkbydj:
                                              
        return {"success": false, "error_message": "Node '%s' not found." % jxruvtjb, "node_type": "", "subresource_type": ""}

    var yficqiop = emzkbydj.get(lhkudfcz)
    if not (yficqiop is Resource):
        var qjbxranj = "Property '%s' on node '%s' is not a Resource or doesn't exist." % [lhkudfcz, jxruvtjb]
        push_error(qjbxranj)
        return {"success": false, "error_message": qjbxranj, "node_type": emzkbydj.get_class(), "subresource_type": ""}

    var fmywtuyw = blaezikp(yficqiop, wkxujvfd)
    if not fmywtuyw.success:
        return {"success": false, "error_message": fmywtuyw.error_message, "node_type": emzkbydj.get_class(), "subresource_type": yficqiop.get_class()}

                         
    EditorInterface.edit_resource(yficqiop)                                 
    if EditorInterface.save_scene() == OK:
        return {"success": true, "error_message": "", "node_type": emzkbydj.get_class(), "subresource_type": yficqiop.get_class()}
    else:
        var qjbxranj = "Failed to save the scene."
        push_error(qjbxranj)
        return {"success": false, "error_message": qjbxranj, "node_type": emzkbydj.get_class(), "subresource_type": yficqiop.get_class()}

static func _edit_in_closed_scene(hszirfkf: String, oobpfjnc: String, bmlpplqh: String, jcclmhpa: Dictionary) -> Dictionary:
    var siprrlzf = load(oobpfjnc)
    if !(siprrlzf is PackedScene):
        var rmjnzgpc = "Failed to load scene '%s' as PackedScene." % oobpfjnc
        push_error(rmjnzgpc)
        return {"success": false, "error_message": rmjnzgpc, "node_type": "", "subresource_type": ""}

    var tqtpmuva = siprrlzf.instantiate()
    if not tqtpmuva:
        var rmjnzgpc = "Could not instantiate scene '%s'." % oobpfjnc
        push_error(rmjnzgpc)
        return {"success": false, "error_message": rmjnzgpc, "node_type": "", "subresource_type": ""}

    var znuvcuge = rvzeaoum.ftcztpyy(hszirfkf, tqtpmuva)               
    if not znuvcuge:
        tqtpmuva.free()
        return {"success": false, "error_message": "Node '%s' not found." % hszirfkf, "node_type": "", "subresource_type": ""}

    var oevmoife = znuvcuge.get(bmlpplqh)
    if not (oevmoife is Resource):
        var rmjnzgpc = "Property '%s' on node '%s' is not a Resource or doesn't exist." % [bmlpplqh, hszirfkf]
        push_error(rmjnzgpc)
        tqtpmuva.free()
        return {"success": false, "error_message": rmjnzgpc, "node_type": znuvcuge.get_class(), "subresource_type": ""}

    var drfopyxw = blaezikp(oevmoife, jcclmhpa)
    if not drfopyxw.success:
        tqtpmuva.free()
        return {"success": false, "error_message": drfopyxw.error_message, "node_type": znuvcuge.get_class(), "subresource_type": oevmoife.get_class()}

    siprrlzf.pack(tqtpmuva)
    var esozlkfp = ResourceSaver.save(siprrlzf, oobpfjnc)
    tqtpmuva.free()

    if esozlkfp == OK:
        return {"success": true, "error_message": "", "node_type": znuvcuge.get_class(), "subresource_type": oevmoife.get_class()}
    else:
        var rmjnzgpc = "Failed to save the packed scene."
        push_error(rmjnzgpc)
        return {"success": false, "error_message": rmjnzgpc, "node_type": znuvcuge.get_class(), "subresource_type": oevmoife.get_class()}


                                                                             
         
                                                                             
static func blaezikp(xzqtrgie: Resource, zagjawzx: Dictionary) -> Dictionary:
    for property_name in zagjawzx.keys():
        var nfvragbl = zagjawzx[property_name]
        var wdqppmnc = rvzeaoum._parse_value(nfvragbl)
        if wdqppmnc == null and nfvragbl != null:
            var iyiyzjrv = "Failed to parse value '%s' for property '%s'." % [str(nfvragbl), property_name]
            push_error(iyiyzjrv)
            return {"success": false, "error_message": iyiyzjrv}

        if not rvzeaoum.synrxueg(xzqtrgie, property_name, wdqppmnc):
                                               
            var iyiyzjrv = "Failed to set property '%s' on resource '%s'." % [property_name, xzqtrgie.get_class()]
            return {"success": false, "error_message": iyiyzjrv}

    return {"success": true, "error_message": ""}

                                                                             
            
                                                       
                                                                
                                                                                                                     
                                                                             
static func parse_line(cqtaghyo: String, umojcpjk: String) -> Dictionary:
    if cqtaghyo.begins_with("edit_subresource("):
        var xcdvuwtg = cqtaghyo.replace("edit_subresource(", "")
        if xcdvuwtg.ends_with(")"):
            xcdvuwtg = xcdvuwtg.substr(0, xcdvuwtg.length() - 1)             
        xcdvuwtg = xcdvuwtg.strip_edges()

                                                                                                
        var ugsyieas = []
        var raztolzr = 0
        var lchrnqlv = 0
        while lchrnqlv < 3:                             
            var avyycztx = xcdvuwtg.find('"',raztolzr)
            if avyycztx == -1:
                break                         
            var ttidhjix = xcdvuwtg.find('"', avyycztx + 1)
            if ttidhjix == -1:
                break                       
            ugsyieas.append(xcdvuwtg.substr(avyycztx + 1, ttidhjix - (avyycztx + 1)))             
            raztolzr = ttidhjix + 1
            lchrnqlv += 1
                                                                         
            var abkoqbnn = xcdvuwtg.find(",", raztolzr)
            if abkoqbnn != -1:
                raztolzr = abkoqbnn + 1
            else:
                                                                                                    
                if lchrnqlv < 3: break                                               

        if ugsyieas.size() < 3:
            push_error("Edit Subresource: Failed to parse required string arguments (node_name, scene_path, subresource_property_name). Line: " + cqtaghyo)
            return {}

                                                                        
        var rxszwbhv = xcdvuwtg.find("{", raztolzr)                                 
        var zaivfaca = xcdvuwtg.rfind("}")
        if rxszwbhv == -1 or zaivfaca == -1 or zaivfaca < rxszwbhv:
            push_error("Edit Subresource: Failed to find or parse properties dictionary. Line: " + cqtaghyo)
            return {}

        var gituwoyl = xcdvuwtg.substr(rxszwbhv, zaivfaca - rxszwbhv + 1)             
                                                                           
        var wufxqhiu = ebmsdhxr.copjdxfr(gituwoyl)                                 

                                                                           
                                                                                   

        return {
            "type": "edit_subresource",
            "node_name": ugsyieas[0],
            "scene_path": ugsyieas[1],
            "subresource_property_name": ugsyieas[2],
            "properties": wufxqhiu                                         
        }

    return {}
