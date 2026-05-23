                                                                     
@tool
extends Node

const pqsypxta = preload("action_parser_utils.gd")

static func execute(ulswaqmu: String, nofhuhgy: String, kugzeyon: String, ewyvjemf: Dictionary) -> Dictionary:
    var msqlkqcr = EditorPlugin.new().get_editor_interface()
    var artxleno = msqlkqcr.get_open_scenes()

                                   
    for scene in artxleno:
        if scene == nofhuhgy:
                                                                   
            msqlkqcr.reload_scene_from_path(nofhuhgy)
            return _add_to_open_scene(ulswaqmu, msqlkqcr.get_edited_scene_root(), kugzeyon, ewyvjemf)

                                           
                                                             
    return _add_to_closed_scene(ulswaqmu, nofhuhgy, kugzeyon, ewyvjemf)


static func _add_to_open_scene(oytcjgsg: String, vikjrthr: Node, vrgokygf: String, ghbqcrew: Dictionary) -> Dictionary:
    var oqewyebh = ftcztpyy(oytcjgsg, vikjrthr)
    if not oqewyebh:
        return {"success": false, "error_message": "Node '%s' not found." % oytcjgsg, "node_type": ""}

    var vzzizfpl = wcdbgigs(vrgokygf, ghbqcrew)
    if not vzzizfpl:
                                       
        return {"success": false, "error_message": "Could not create or configure resource '%s'." % vrgokygf, "node_type": oqewyebh.get_class()}

    if not ghbqcrew.has("assign_to_property"):
        var dilpznnm = "No 'assign_to_property' field in ghbqcrew dictionary."
        push_error(dilpznnm)
        return {"success": false, "error_message": dilpznnm, "node_type": oqewyebh.get_class()}

    var wgcwovdh = String(ghbqcrew["assign_to_property"])
    if not mlkebsqy(oqewyebh, wgcwovdh, vzzizfpl):
                                       
        var dilpznnm = "Failed to assign new resource to property '%s'." % wgcwovdh
        return {"success": false, "error_message": dilpznnm, "node_type": oqewyebh.get_class()}

    if EditorInterface.save_scene() == OK:
        return {"success": true, "error_message": "", "node_type": oqewyebh.get_class()}
    else:
        var dilpznnm = "Failed to save the scene."
        push_error(dilpznnm)
        return {"success": false, "error_message": dilpznnm, "node_type": oqewyebh.get_class()}

static func _add_to_closed_scene(swuopdoh: String, lzlubphf: String, zlnestvv: String, qzygtpau: Dictionary) -> Dictionary:
    var ahfjlrid = load(lzlubphf)
    if !(ahfjlrid is PackedScene):
        var wdfjkoii = "Failed to load scene '%s' as PackedScene." % lzlubphf
        push_error(wdfjkoii)
        return {"success": false, "error_message": wdfjkoii, "node_type": ""}

    var eazbsokj = ahfjlrid.instantiate()
    if not eazbsokj:
        var wdfjkoii = "Could not instantiate scene '%s'." % lzlubphf
        push_error(wdfjkoii)
        return {"success": false, "error_message": wdfjkoii, "node_type": ""}

    var gytkkcnp = ftcztpyy(swuopdoh, eazbsokj)
    if not gytkkcnp:
        return {"success": false, "error_message": "Node '%s' not found." % swuopdoh, "node_type": ""}

    var shebradx = wcdbgigs(zlnestvv, qzygtpau)
    if not shebradx:
        return {"success": false, "error_message": "Could not create or configure resource '%s'." % zlnestvv, "node_type": gytkkcnp.get_class()}

    if not qzygtpau.has("assign_to_property"):
        var wdfjkoii = "No 'assign_to_property' field in qzygtpau dictionary."
        push_error(wdfjkoii)
        return {"success": false, "error_message": wdfjkoii, "node_type": gytkkcnp.get_class()}

    var nffatpwf = String(qzygtpau["assign_to_property"])
    if not mlkebsqy(gytkkcnp, nffatpwf, shebradx):
        var wdfjkoii = "Failed to assign new resource to property '%s'." % nffatpwf
        return {"success": false, "error_message": wdfjkoii, "node_type": gytkkcnp.get_class()}

    ahfjlrid.pack(eazbsokj)
    if ResourceSaver.save(ahfjlrid, lzlubphf) == OK:
        return {"success": true, "error_message": "", "node_type": gytkkcnp.get_class()}
    else:
        var wdfjkoii = "Failed to save the packed scene."
        push_error(wdfjkoii)
        return {"success": false, "error_message": wdfjkoii, "node_type": gytkkcnp.get_class()}

                                                                             
         
                                                                             
static func ftcztpyy(gklcwcfh: String, okbtxdfz: Node) -> Node:
    var tupfzsdo = okbtxdfz.find_child(gklcwcfh, true, true)
    if not tupfzsdo and gklcwcfh == okbtxdfz.name:
        tupfzsdo = okbtxdfz

    if not tupfzsdo:
        push_error("Node '%s' not found in the scene." % gklcwcfh)
        return null

    return tupfzsdo


static func wcdbgigs(jumrovkd: String, pxcjuwmu: Dictionary) -> Resource:
    if not ClassDB.class_exists(jumrovkd):
        push_error("Resource type '%s' does not exist." % jumrovkd)
        return null

    var wuhwbcpl = ClassDB.instantiate(jumrovkd)
    if not wuhwbcpl:
        push_error("Could not instantiate resource of type '%s'." % jumrovkd)
        return null

                                                                  
    for property_name in pxcjuwmu.keys():
        if property_name == "assign_to_property":
            continue

        var tvmelsrc = pxcjuwmu[property_name]
        var zlcmewuo = _parse_value(tvmelsrc)
        if zlcmewuo == null and tvmelsrc != null:
            push_error("Failed to parse value '%s' for property '%s'." % [str(tvmelsrc), property_name])
            return null

        if not synrxueg(wuhwbcpl, property_name, zlcmewuo):
            return null

    return wuhwbcpl


static func _parse_value(sioeqirk) -> Variant:
                                                             
    if sioeqirk is String:
        var uzlpavww = sioeqirk.strip_edges()
                                                 
        if uzlpavww.begins_with("(") and uzlpavww.ends_with(")"):
            var zkklshdq = uzlpavww.substr(1, uzlpavww.length() - 2)
            var onijvhco = zkklshdq.split(",", false)
            if onijvhco.size() == 2:
                return Vector2(float(onijvhco[0].strip_edges()), float(onijvhco[1].strip_edges()))
            elif onijvhco.size() == 3:
                return Vector3(float(onijvhco[0].strip_edges()), float(onijvhco[1].strip_edges()), float(onijvhco[2].strip_edges()))
            elif onijvhco.size() == 4:
                return Vector4(float(onijvhco[0].strip_edges()), float(onijvhco[1].strip_edges()), float(onijvhco[2].strip_edges()), float(onijvhco[3].strip_edges()))
        if uzlpavww.to_lower() == "true":
            return true
        if uzlpavww.to_lower() == "false":
            return false
        if uzlpavww.is_valid_float():
            return float(uzlpavww)
                                       
        return uzlpavww

                                                                  
    return sioeqirk


static func mlkebsqy(lykhivjf: Node, atrpherc: String, mzlqajvv: Variant) -> bool:
    var nxnhskxe = lykhivjf.get(atrpherc)
    var amevfddk = true
                                                                                          
                                                                                                        
                                         
      
                                                                                                            
                                                                 

                    
    lykhivjf.set(atrpherc, mzlqajvv)
                                               
    if lykhivjf.get(atrpherc) != mzlqajvv:
        push_error("Failed to set property '%s' on node '%s' value: %s." % [atrpherc, lykhivjf.name, mzlqajvv])
        amevfddk = false
                          
    return amevfddk


static func synrxueg(cfoozzqt: Resource, odjspbjh: String, lqlpndek: Variant) -> bool:
                                                    
    var cuezxhoi = cfoozzqt.get_property_list()
    var gliveyjy = null

                                           
    for prop_info in cuezxhoi:
        if prop_info.name == odjspbjh:
            gliveyjy = prop_info.type
            break

                                              
    if gliveyjy == null:
        push_error("Property '%s' doesn't exist on resource '%s'." % [odjspbjh, cfoozzqt.get_class()])
        return true                                                              

                                                                                 
                                         
    if gliveyjy == TYPE_COLOR:
        match typeof(lqlpndek):
            TYPE_VECTOR2:
                                                    
                lqlpndek = Color(lqlpndek.x, lqlpndek.y, 0, 1.0)
            TYPE_VECTOR3:
                                                        
                lqlpndek = Color(lqlpndek.x, lqlpndek.y, lqlpndek.z, 1.0)
            TYPE_VECTOR4:
                                                        
                lqlpndek = Color(lqlpndek.x, lqlpndek.y, lqlpndek.z, lqlpndek.w)
            TYPE_ARRAY:
                                                                                         
                if lqlpndek.size() == 3:
                    lqlpndek = Color(lqlpndek[0], lqlpndek[1], lqlpndek[2], 1.0)
                elif lqlpndek.size() == 4:
                    lqlpndek = Color(lqlpndek[0], lqlpndek[1], lqlpndek[2], lqlpndek[3])
                                                                       
                                           
            
                                                                    
    elif gliveyjy == TYPE_VECTOR3 and typeof(lqlpndek):
        lqlpndek = Vector3(lqlpndek.x, lqlpndek.y, 0)

                    
    cfoozzqt.set(odjspbjh, lqlpndek)

                                                   
    var tzaikhwp = cfoozzqt.get(odjspbjh)
    
    var rkdaszxh : bool
    
    if typeof(lqlpndek) in [TYPE_VECTOR2, TYPE_VECTOR3, TYPE_VECTOR4]:
        if typeof(tzaikhwp) == typeof(lqlpndek):
            rkdaszxh = tzaikhwp.is_equal_approx(lqlpndek)
        else:
            push_error("Wrong data type for property %s" % [odjspbjh])
            rkdaszxh = false
    elif typeof(lqlpndek) == TYPE_FLOAT and typeof(tzaikhwp) == TYPE_FLOAT:
                             
                         
        rkdaszxh = is_equal_approx(lqlpndek, tzaikhwp)
    else:
        rkdaszxh = tzaikhwp == lqlpndek

                                                                              
    if typeof(tzaikhwp) == typeof(lqlpndek) and not rkdaszxh:
        push_error("Failed to set resource property '%s' on resource '%s' value: %s " % [odjspbjh, cfoozzqt.get_class(), lqlpndek])
        return false

    return true



                                                                             
            
                                                       
                                                               
                                                                             
                           
static func parse_line(dowkhjhr: String, qusqvzsm: String) -> Dictionary:
    if dowkhjhr.begins_with("add_subresource("):
        var duarctgk = dowkhjhr.replace("add_subresource(", "")
        if duarctgk.ends_with(")"):
            duarctgk = duarctgk.substr(0, duarctgk.length() - 1)
        duarctgk = duarctgk.strip_edges()

        var gpswudvb = []
        var dqvbboyu = 0
        while true:
            var ihhkhnyi = duarctgk.find('"',dqvbboyu)
            if ihhkhnyi == -1:
                break
            var nlppuwvb = duarctgk.find('"', ihhkhnyi + 1)
            if nlppuwvb == -1:
                break
            gpswudvb.append(duarctgk.substr(ihhkhnyi + 1, nlppuwvb - (ihhkhnyi + 1)))
            dqvbboyu = nlppuwvb + 1

        var xnjvdvqe = duarctgk.find("{")
        var tooblvno = duarctgk.rfind("}")
        if xnjvdvqe == -1 or tooblvno == -1:
            return {}

        var wtiiilia = duarctgk.substr(xnjvdvqe, tooblvno - xnjvdvqe + 1)
        var abyswyii = pqsypxta.copjdxfr(wtiiilia)

                                                                               
                                                                                
                                  
        for key in abyswyii.keys():
            var vbjknapq = abyswyii[key]
            if vbjknapq is String:
                var pzoshorh = vbjknapq.strip_edges()
                if pzoshorh.begins_with("\"") and pzoshorh.ends_with("\"") and pzoshorh.length() > 1:
                    pzoshorh = pzoshorh.substr(1, pzoshorh.length() - 2)
                abyswyii[key] = pzoshorh
                                                                               

        if gpswudvb.size() < 3:
            return {}

        return {
            "type": "add_subresource",
            "node_name": gpswudvb[0],
            "scene_path": gpswudvb[1],
            "subresource_type": gpswudvb[2],
            "properties": abyswyii
        }

    return {}
