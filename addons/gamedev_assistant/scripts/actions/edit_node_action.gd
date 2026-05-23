                                                               
@tool
extends Node

const xpakwtti = preload("action_parser_utils.gd")

static func execute(reocxbwo: String, zabvhdqf: String, volegvcg: Dictionary) -> Dictionary:
    var vpylmkgu = EditorPlugin.new().get_editor_interface()
    var gdtejzzz = vpylmkgu.get_open_scenes()

                                   
    for scene in gdtejzzz:
        if scene == zabvhdqf:
                                                     
            vpylmkgu.reload_scene_from_path(zabvhdqf)
                                                             
            return yccedmdw(reocxbwo, vpylmkgu.get_edited_scene_root(), volegvcg)

                                                        
                                               
    return pkazajvf(reocxbwo, zabvhdqf, volegvcg)


static func yccedmdw(zpcfrmxq: String, plafwwen: Node, duqyjgam: Dictionary) -> Dictionary:
    var hqaairvj = plafwwen.find_child(zpcfrmxq, true, true)
    
    if not hqaairvj and zpcfrmxq == plafwwen.name:
        hqaairvj = plafwwen

    if not hqaairvj:
        var unrukqvs = "Node '%s' not found in open scene root '%s'." % [zpcfrmxq, plafwwen.name]
        push_error(unrukqvs)
        return {"success": false, "error_message": unrukqvs, "node_type": ""}

                                                 
    var usakhvmz = bxunlhro(hqaairvj, duqyjgam, plafwwen)
    if not usakhvmz.success:
        return {"success": false, "error_message": usakhvmz.error_message, "node_type": hqaairvj.get_class()}
        
                                                  
    if EditorInterface.save_scene() == OK:
        return {"success": true, "error_message": "", "node_type": hqaairvj.get_class()}
    else:
        var unrukqvs = "Failed to save the scene."
        push_error(unrukqvs)
        return {"success": false, "error_message": unrukqvs, "node_type": hqaairvj.get_class()}


static func pkazajvf(qubiblov: String, axtwjnbq: String, lqoidmsj: Dictionary) -> Dictionary:
    var jmndbugu = load(axtwjnbq)
    if !(jmndbugu is PackedScene):
        var dpyutblt = "Failed to load scene '%s' as PackedScene." % axtwjnbq
        push_error(dpyutblt)
        return {"success": false, "error_message": dpyutblt, "node_type": ""}

    var rafdvqfn = jmndbugu.instantiate()
    if not rafdvqfn:
        var dpyutblt = "Could not instantiate scene '%s'." % axtwjnbq
        push_error(dpyutblt)
        return {"success": false, "error_message": dpyutblt, "node_type": ""}

    var tsynksuv = rafdvqfn.find_child(qubiblov, true, true)
    
    if not tsynksuv and qubiblov == rafdvqfn.name:
        tsynksuv = rafdvqfn

    if not tsynksuv:
        var dpyutblt = "Node '%s' not found in scene instance root '%s'." % [qubiblov, rafdvqfn.name]
        push_error(dpyutblt)
        return {"success": false, "error_message": dpyutblt, "node_type": ""}

                                                        
    var bpjdottw = bxunlhro(tsynksuv, lqoidmsj, rafdvqfn)
    if not bpjdottw.success:
        return {"success": false, "error_message": bpjdottw.error_message, "node_type": tsynksuv.get_class()}

                                
    jmndbugu.pack(rafdvqfn)
    if ResourceSaver.save(jmndbugu, axtwjnbq) == OK:
        return {"success": true, "error_message": "", "node_type": tsynksuv.get_class()}
    else:
        var dpyutblt = "Failed to save the packed scene."
        push_error(dpyutblt)
        return {"success": false, "error_message": dpyutblt, "node_type": tsynksuv.get_class()}


static func bxunlhro(aouedvcm: Node, qgupzrdz: Dictionary, kxlfwgxo: Node = null) -> Dictionary:
    for property_name in qgupzrdz.keys():
        var pmeyacut = qgupzrdz[property_name]
        var xgtxbrtm = _parse_value(pmeyacut)
        if xgtxbrtm == null and pmeyacut != null:
            var dlterhnu = "Failed to parse value '%s' for property '%s'." % [str(pmeyacut), property_name]
            push_error(dlterhnu)
            return {"success": false, "error_message": dlterhnu}
            
                                     
                                                                                                           
                                                             
        var oaioldqk = _try_set_property(aouedvcm, property_name, xgtxbrtm, kxlfwgxo)
        if not oaioldqk:
                                                                       
            var dlterhnu = "Failed to set property '%s' on node '%s'." % [property_name, aouedvcm.name]
            return {"success": false, "error_message": dlterhnu}

    return {"success": true, "error_message": ""}

static func _parse_value(afccgkum) -> Variant:
                                                                                            
    if afccgkum is String:
        var gceimphd = afccgkum.strip_edges()
        
                                                        
        if gceimphd.length() >= 2 and gceimphd.begins_with('"') and gceimphd.ends_with('"'):
            gceimphd = gceimphd.substr(1, gceimphd.length() - 2)
        elif gceimphd.length() >= 2 and gceimphd.begins_with("'") and gceimphd.ends_with("'"):
            gceimphd = gceimphd.substr(1, gceimphd.length() - 2)
        
        if gceimphd.begins_with("(") and gceimphd.ends_with(")"):
            var mhtleifh = gceimphd.substr(1, gceimphd.length() - 2)
            var pbebhigc = mhtleifh.split(",", false)
                                                  
            if pbebhigc.size() == 2:
                var itddxryg = float(pbebhigc[0].strip_edges())
                var bqfwndxt = float(pbebhigc[1].strip_edges())
                return Vector2(itddxryg, bqfwndxt)
                                                  
            if pbebhigc.size() == 3:
                var ytvpbsfn = float(pbebhigc[0].strip_edges())
                var avmckmjt = float(pbebhigc[1].strip_edges())
                var ryujfarf = float(pbebhigc[2].strip_edges())
                return Vector3(ytvpbsfn, avmckmjt, ryujfarf)
                                                  
            if pbebhigc.size() == 4:
                var vagdfiid = float(pbebhigc[0].strip_edges())
                var ohgddfia = float(pbebhigc[1].strip_edges())
                var vfacmnwp = float(pbebhigc[2].strip_edges())
                var gltxvnfs = float(pbebhigc[3].strip_edges())
                return Vector4(vagdfiid, ohgddfia, vfacmnwp, gltxvnfs)
                               
        if gceimphd.to_lower() == "true":
            return true
        if gceimphd.to_lower() == "false":
            return false
                                
        if gceimphd.is_valid_float():
            return float(gceimphd)
                                                
        return gceimphd

                                                             
    return afccgkum

static func gsdvuioq(yiknhgsk: String, mkvaanwd: String) -> String:
    var lxbgfzwx = ""
    var dgjhwosc = yiknhgsk.length()
    var jwumaxpl = mkvaanwd.length()
    var yqibaden = min(dgjhwosc, jwumaxpl)

    for i in range(yqibaden):
        if yiknhgsk[i] != mkvaanwd[i]:
            lxbgfzwx += "Difference at index: " + str(i) + ", String1: " + yiknhgsk[i] + ", String2: " + mkvaanwd[i]
            break

    return lxbgfzwx


static func _try_set_property(zeydjwro: Node, frziwrnr: String, klfnhqjq: Variant, ruyzcqkx: Node = null) -> bool:  
                                      
    if frziwrnr == "parent":
        if not klfnhqjq is String:
            push_error("Parent value must be a string (name of the new parent)")
            return false

        if ruyzcqkx == null:
            push_error("Cannot re-parent without a valid scene root.")
            return false

        var qdlnxqje = klfnhqjq.strip_edges()
        var linuevtn: Node

                                                 
                                                                          
        if qdlnxqje == "" or qdlnxqje == ruyzcqkx.name:
            linuevtn = ruyzcqkx
        else:
            linuevtn = ruyzcqkx.find_child(qdlnxqje, true, true)
            if not linuevtn:
                push_error("Failed to find parent node with name: %s" % qdlnxqje)
                return false
        
                   
        if zeydjwro.get_parent():
            zeydjwro.get_parent().remove_child(zeydjwro)
        linuevtn.add_child(zeydjwro)

                                                                          
        zeydjwro.set_owner(ruyzcqkx)

        return true

                                      
    var jgagnicl = zeydjwro.get_property_list()
    for prop in jgagnicl:
        if prop.name == frziwrnr:
                        
            if prop.type == TYPE_COLOR:
                match typeof(klfnhqjq):
                    TYPE_VECTOR2:
                                                            
                        klfnhqjq = Color(klfnhqjq.x, klfnhqjq.y, 0, 1.0)
                    TYPE_VECTOR3:
                                                                
                        klfnhqjq = Color(klfnhqjq.x, klfnhqjq.y, klfnhqjq.z, 1.0)
                    TYPE_VECTOR4:
                        klfnhqjq = Color(klfnhqjq.x, klfnhqjq.y, klfnhqjq.z, klfnhqjq.w)
                    TYPE_ARRAY:
                                                                                                  
                        if klfnhqjq.size() == 3:
                            klfnhqjq = Color(klfnhqjq[0], klfnhqjq[1], klfnhqjq[2], 1.0)
                        elif klfnhqjq.size() == 4:
                            klfnhqjq = Color(klfnhqjq[0], klfnhqjq[1], klfnhqjq[2], klfnhqjq[3])

                                                                       
            elif prop.type == TYPE_OBJECT and prop.hint == PROPERTY_HINT_RESOURCE_TYPE:
                var vxqsavrx = prop.hint_string
                
                                           
                if vxqsavrx == "Texture2D" or vxqsavrx.contains("Texture2D"):
                    var ivwwfyfc = load(klfnhqjq)

                                                                                        
                    if "_" in frziwrnr:
                        var vtrrdnei = frziwrnr.split("_")
                        if vtrrdnei.size() > 1:
                            var dmhlrdon = vtrrdnei[1]
                            var uzehuisz = "set_texture_" + dmhlrdon
                            if zeydjwro.has_method(uzehuisz):
                                zeydjwro.call(uzehuisz, ivwwfyfc)
                                return true

                                                                           
                    if zeydjwro.has_method("set_texture"):
                        zeydjwro.set_texture(ivwwfyfc)
                        return true
                        
                                             
                elif vxqsavrx == "Mesh" or vxqsavrx.contains("Mesh"):
                    var ynoffceo = load(klfnhqjq)
                    if not ynoffceo:
                        push_error("Failed to load mesh at path: %s" % klfnhqjq)
                        return false
                    
                    if "_" in frziwrnr:
                        var vtrrdnei = frziwrnr.split("_")
                        if vtrrdnei.size() > 1:
                            var dmhlrdon = vtrrdnei[1]
                            var uzehuisz = "set_mesh_" + dmhlrdon
                            if zeydjwro.has_method(uzehuisz):
                                zeydjwro.call(uzehuisz, ynoffceo)
                                return true
                    
                    zeydjwro.set(frziwrnr, ynoffceo)
                    return true
                
                                                
                elif vxqsavrx == "AudioStream" or vxqsavrx.contains("AudioStream"):
                    var otevkcnu = load(klfnhqjq)
                    if not otevkcnu:
                        push_error("Failed to load audio stream at path: %s" % klfnhqjq)
                        return false
                    zeydjwro.set(frziwrnr, otevkcnu)
                    return true



                                                                 
    if not zeydjwro.has_method("get") or zeydjwro.get(frziwrnr) == null:
        push_error("Property '%s' doesn't exist on node '%s'." % [frziwrnr, zeydjwro.name])
        return false

                                    
    zeydjwro.set(frziwrnr, klfnhqjq)

                                                               
                                                          
    return true


                                                                             
                 
                                                                      
                                                                             
static func parse_line(qtwffhlf: String, scpgkumz: String) -> Dictionary:
                                                     
    if qtwffhlf.begins_with("edit_node("):
        var adyogfok = xpakwtti.eotwzqyl(qtwffhlf)
                                                            
        if adyogfok.size() == 0:
            return {}
        if not adyogfok.has("node_name") \
            or not adyogfok.has("scene_path") \
            or not adyogfok.has("modifications"):
            return {}

        return {
            "type": "edit_node",
            "node_name": adyogfok.node_name,
            "scene_path": adyogfok.scene_path,
            "modifications": adyogfok.modifications
        }

    return {}
