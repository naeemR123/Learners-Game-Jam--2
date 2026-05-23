                                                                 
@tool
extends Node

const hjgwfjfs = preload("action_parser_utils.gd")
const egosydts = preload("edit_node_action.gd")

static func execute(ecpgjoob: String, gbtemkdp: String, hgkmxnvb: String, pyacnsoq: String, sodnddit: Dictionary) -> Dictionary:
    var mqbkkrfk = EditorPlugin.new().get_editor_interface()
    var ffilphiq = mqbkkrfk.get_open_scenes()
    
    var rfpwlbde = load(gbtemkdp)
    if not rfpwlbde is PackedScene:
        var hkykxmsz = "Invalid or non-existent scene file: " + gbtemkdp
        push_error(hkykxmsz)
        return {"success": false, "error_message": hkykxmsz}
    
    if hgkmxnvb in ffilphiq:
        return nbgbfmdm(ecpgjoob, rfpwlbde, hgkmxnvb, pyacnsoq, sodnddit)
    else:
        return vtlwfjqe(ecpgjoob, rfpwlbde, hgkmxnvb, pyacnsoq, sodnddit)

static func nbgbfmdm(fqbbehhl: String, olmxafeg: PackedScene, tohcudgx: String, hdjvkvpg: String, jxtdpwtm: Dictionary) -> Dictionary:
    var bwbpongq = EditorPlugin.new().get_editor_interface()
    bwbpongq.reload_scene_from_path(tohcudgx)
    var xqkeekjw = bwbpongq.get_edited_scene_root()
    
    var uqnyuwtr = xqkeekjw if (hdjvkvpg.is_empty() or hdjvkvpg == xqkeekjw.name) else xqkeekjw.find_child(hdjvkvpg, true, true)
    if not uqnyuwtr:
        var ucjispnb = "Parent node '%s' not found in scene '%s'." % [hdjvkvpg, tohcudgx]
        push_error(ucjispnb)
        return {"success": false, "error_message": ucjispnb}
    
    var elagvpks = olmxafeg.instantiate()
    elagvpks.name = fqbbehhl
    uqnyuwtr.add_child(elagvpks)
    elagvpks.set_owner(xqkeekjw)
    
    if not jxtdpwtm.is_empty():
        var eynmorrr = egosydts.bxunlhro(elagvpks, jxtdpwtm, xqkeekjw)
        if not eynmorrr.success:
            return eynmorrr                                       
    
    if EditorPlugin.new().get_editor_interface().save_scene() == OK:
        return {"success": true, "error_message": ""}
    else:
        var ucjispnb = "Failed to save scene '%s'." % tohcudgx
        push_error(ucjispnb)
        return {"success": false, "error_message": ucjispnb}


static func vtlwfjqe(xvpixkin: String, oyllwjbx: PackedScene, hakoxnac: String, lbxtupgo: String, kecboqhv: Dictionary) -> Dictionary:
    var wqabjqad = load(hakoxnac)
    if not wqabjqad is PackedScene:
        var kuxkqrpt = "Invalid or non-existent target scene: " + hakoxnac
        push_error(kuxkqrpt)
        return {"success": false, "error_message": kuxkqrpt}
    
    var ypkywxef = wqabjqad.instantiate()
    var reateevf = ypkywxef if (lbxtupgo.is_empty() or lbxtupgo == ypkywxef.name) else ypkywxef.find_child(lbxtupgo, true, true)
    if not reateevf:
        var kuxkqrpt = "Parent node '%s' not found in scene '%s'." % [lbxtupgo, hakoxnac]
        push_error(kuxkqrpt)
        return {"success": false, "error_message": kuxkqrpt}
    
    var ppnnxkxi = oyllwjbx.instantiate()
    ppnnxkxi.name = xvpixkin
    reateevf.add_child(ppnnxkxi)
    ppnnxkxi.set_owner(ypkywxef)
    
    if not kecboqhv.is_empty():
        var iutzylnh = egosydts.bxunlhro(ppnnxkxi, kecboqhv, ypkywxef)
        if not iutzylnh.success:
            return iutzylnh                                       
    
    wqabjqad.pack(ypkywxef)
    if ResourceSaver.save(wqabjqad, hakoxnac) == OK:
        return {"success": true, "error_message": ""}
    else:
        var kuxkqrpt = "Failed to save packed scene '%s'." % hakoxnac
        push_error(kuxkqrpt)
        return {"success": false, "error_message": kuxkqrpt}

static func parse_line(nvyzqniw: String, lidmpkuc: String) -> Dictionary:
    if nvyzqniw.begins_with("add_existing_scene("):
        var fysnlyou = nvyzqniw.replace("add_existing_scene(", "").strip_edges()
        if fysnlyou.ends_with(")"):
            fysnlyou = fysnlyou.substr(0, fysnlyou.length() - 1).strip_edges()
        
        var mksaswfq = []
        var gjstuccy = 0
                                             
        for _i in range(4):
            var zswvgpvb = fysnlyou.find('"',gjstuccy)
            if zswvgpvb == -1: return {}
            var uwvgdfks = fysnlyou.find('"', zswvgpvb + 1)
            if uwvgdfks == -1: return {}
            mksaswfq.append(fysnlyou.substr(zswvgpvb + 1, uwvgdfks - zswvgpvb - 1))
            gjstuccy = uwvgdfks + 1
        
                                        
        var ijcqmlzf = {}
        var bgeukffh = fysnlyou.substr(gjstuccy).strip_edges()
        if bgeukffh.begins_with("{"):
            ijcqmlzf = hjgwfjfs.copjdxfr(bgeukffh)
        
        return {
            "type": "add_existing_scene",
            "node_name": mksaswfq[0],
            "existing_scene_path": mksaswfq[1],
            "target_scene_path": mksaswfq[2],
            "parent_path": mksaswfq[3],
            "modifications": ijcqmlzf
        }
    return {}
