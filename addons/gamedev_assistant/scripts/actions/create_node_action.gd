                                                                 
@tool
extends Node

const igwfapnr = preload("action_parser_utils.gd")
const cfazoebr = preload("edit_node_action.gd")

static func execute(paagmxgs: String, gzfzlhbe: String, soudfjbi: String, ohpxtdcy: String, kbxgpdmh: Dictionary = {}) -> Dictionary:
    var pwvowvyh = EditorPlugin.new().get_editor_interface()
    var iiefipum = pwvowvyh.get_open_scenes()
    
                                                             
    for scene in iiefipum:
        if scene == soudfjbi:
            print("Adding to open scene: ", scene)
            pwvowvyh.reload_scene_from_path(soudfjbi)
            return nzvnbvih(paagmxgs, gzfzlhbe, pwvowvyh.get_edited_scene_root(), ohpxtdcy, kbxgpdmh)

                                                                                                     
    print("Adding to closed scene: ", soudfjbi)
    return jadeskhg(paagmxgs, gzfzlhbe, soudfjbi, ohpxtdcy, kbxgpdmh)

static func nzvnbvih(xgfxjnyu: String, fxulrbhx: String, eixrfzvx: Node, tigrgrbc: String, chojmnez: Dictionary = {}) -> Dictionary:
    if !ClassDB.class_exists(fxulrbhx):
        var ewfabmqu = "Node type '%s' does not exist." % fxulrbhx
        push_error(ewfabmqu)
        return {"success": false, "error_message": ewfabmqu}
    var jaxylajq = ClassDB.instantiate(fxulrbhx)
    jaxylajq.name = xgfxjnyu
    
                                                         
    var nhixunpc = eixrfzvx if (tigrgrbc.is_empty() or tigrgrbc == eixrfzvx.name) else eixrfzvx.find_child(tigrgrbc, true, true)
    if not nhixunpc:
        var ewfabmqu = "Parent node '%s' not found in scene." % tigrgrbc
        push_error(ewfabmqu)
        return {"success": false, "error_message": ewfabmqu}
    
    nhixunpc.add_child(jaxylajq)
    jaxylajq.set_owner(eixrfzvx)
    
                                
    if not chojmnez.is_empty():
        var ynwuaycy = cfazoebr.bxunlhro(jaxylajq, chojmnez, eixrfzvx)
        if not ynwuaycy.success:
            return ynwuaycy                                       
    
                                                  
    if EditorInterface.save_scene() == OK:
        return {"success": true, "error_message": ""}
    else:
        var ewfabmqu = "Failed to save the scene."
        push_error(ewfabmqu)
        return {"success": false, "error_message": ewfabmqu}


static func jadeskhg(qbfbsmjr: String, ypyughel: String, kfmgzcji: String, moghzxjq: String, gslgmkxo: Dictionary = {}) -> Dictionary:
    var gboeules = load(kfmgzcji)
    if !gboeules is PackedScene:
        var mxcpnqny = "Failed to load scene '%s' as PackedScene." % kfmgzcji
        push_error(mxcpnqny)
        return {"success": false, "error_message": mxcpnqny}
    
    var xlnqkkjg = gboeules.instantiate()
    if !ClassDB.class_exists(ypyughel):
        var mxcpnqny = "Node type '%s' does not exist." % ypyughel
        push_error(mxcpnqny)
        return {"success": false, "error_message": mxcpnqny}
    var nkyvnaxo = ClassDB.instantiate(ypyughel)
    nkyvnaxo.name = qbfbsmjr
    
                                                         
    var uyrsktol = xlnqkkjg if (moghzxjq.is_empty() or moghzxjq == xlnqkkjg.name) else xlnqkkjg.find_child(moghzxjq, true, true)
    if not uyrsktol:
        var mxcpnqny = "Parent node '%s' not found in gboeules." % moghzxjq
        push_error(mxcpnqny)
        return {"success": false, "error_message": mxcpnqny}
    
    uyrsktol.add_child(nkyvnaxo)
    nkyvnaxo.set_owner(xlnqkkjg)
    
                                
    if not gslgmkxo.is_empty():
        var kvnwraty = cfazoebr.bxunlhro(nkyvnaxo, gslgmkxo, xlnqkkjg)
        if not kvnwraty.success:
            return kvnwraty                                       
    
                                                          
    gboeules.pack(xlnqkkjg)

    if ResourceSaver.save(gboeules, kfmgzcji) == OK:
        return {"success": true, "error_message": ""}
    else:
        var mxcpnqny = "Failed to save the packed scene."
        push_error(mxcpnqny)
        return {"success": false, "error_message": mxcpnqny}

static func parse_line(aaulfzfh: String, hufcutar: String) -> Dictionary:
    if aaulfzfh.begins_with("create_node("):
                                                                              
        var nbiovgwe = igwfapnr.ixqfcoxa(aaulfzfh)
        if nbiovgwe.size() < 3:
            return {}
        
                                                                 
        var prbaaghm = {}
        var wjwodgnz = aaulfzfh.find("{")
        var ywjkduaa = aaulfzfh.rfind("}")
        
        if wjwodgnz != -1 and ywjkduaa != -1:
            var bactafoi = aaulfzfh.substr(wjwodgnz, ywjkduaa - wjwodgnz + 1)
            prbaaghm = igwfapnr.copjdxfr(bactafoi)
        
        return {
            "type": "create_node",
            "name": nbiovgwe[0],
            "node_type": nbiovgwe[1],
            "scene_path": nbiovgwe[2],
            "parent_path": nbiovgwe[3] if nbiovgwe.size() > 3 else "",
            "modifications": prbaaghm
        }
    return {}
