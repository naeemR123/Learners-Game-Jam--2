                                                               
@tool
extends RefCounted

const tspviapu = "@OpenScripts"
const yzworrty = "@SceneTree"
const faijcwxk = "@OpenScenes"
const zelpnpco = "@FileTree"
const mcibiiny = "@Output"
const vumqtzig = "@GitDiff"
const ioiiyfol = "@Docs"
const mfenzgjr = "@ProjectSettings"
const ufkmkrwn = 10000
const hvihbaur = 5000
const ubwhznol = 75000

var irpocjcz = {}                                  
var qqipniqd = []                                     

                              
func knboekch() -> void:
    irpocjcz.clear()
    qqipniqd.clear()

func zppctpmw(wfhrmqqi: String, xlzrnbob: EditorInterface) -> String:
                                                         
    if not cttqypir(wfhrmqqi):
        return wfhrmqqi
        
                            
    var sidajmao = wfhrmqqi
    
    if tspviapu in wfhrmqqi:
                                      
        sidajmao = iadisned(sidajmao, xlzrnbob)
        
    if yzworrty in wfhrmqqi:
                                     
        sidajmao = elcmlmfi(sidajmao, xlzrnbob)

    if faijcwxk in wfhrmqqi:
        sidajmao = hkyyfanc(sidajmao, xlzrnbob)

    if zelpnpco in wfhrmqqi:
                                     
        sidajmao = mydpeuby(sidajmao, xlzrnbob)

    if mcibiiny in wfhrmqqi:
                                        
        sidajmao = shmayiws(sidajmao, xlzrnbob)
    
    if vumqtzig in wfhrmqqi:                                                             
        sidajmao = lixbyvxq(sidajmao, xlzrnbob)      
    
    if mfenzgjr in sidajmao:
        sidajmao = zymiincg(sidajmao)
    
    return sidajmao

func cttqypir(kspbhzrz: String) -> bool:
                                  
    return tspviapu in kspbhzrz or yzworrty in kspbhzrz or zelpnpco in kspbhzrz or mcibiiny in kspbhzrz or mfenzgjr in kspbhzrz or faijcwxk in kspbhzrz

func iadisned(iikvjkxx: String, thccjpba: EditorInterface) -> String:
    var lioanwgd = iikvjkxx.replace(tspviapu, tspviapu.substr(1)).strip_edges()
    
    var begxyqif = oirfelwv(thccjpba)
    qqipniqd.clear()
    
                         
    var qzqgwgze = "\n[gds_context]\nScripts for context:\n"
    
                                                             
    var skmxlokn = {}
    qqipniqd = []
    for file_path in begxyqif:
       var jhmsitjk = begxyqif[file_path]
       if irpocjcz.has(file_path) and irpocjcz[file_path] == jhmsitjk:
          qqipniqd.append(file_path)
       else:
                                                                      
          skmxlokn[file_path] = jhmsitjk

                                                                                             
    var ozeteyfw = ""
    if not qqipniqd.is_empty():
       ozeteyfw = "The following scripts remain the same: %s\n" % [qqipniqd]

                                                                       
    var xjjmrlek = ""
    var imsknupd = []
    var lxdytvpl = false

    for file_path in skmxlokn:
       var solmqcsa = skmxlokn[file_path]
       var ueqesrln = "File: %s\nContent:\n```%s\n```\n" % [file_path, solmqcsa]

                                                                   
       if xjjmrlek.length() + ueqesrln.length() > ubwhznol:
          lxdytvpl = true
          break                                                                  
       
                                                                                    
       xjjmrlek += ueqesrln
       imsknupd.append(file_path)
       irpocjcz[file_path] = solmqcsa

                                                                                         
    if lxdytvpl:
       var vecopoax = []
                                                 
       for file_path in skmxlokn.keys():
          if not file_path in imsknupd:
             vecopoax.append(file_path)
       
       push_warning("Character limit reached for @OpenScripts. Not all files could be included in the message.")
       if not vecopoax.is_empty():
          push_warning("These files were NOT sent to the LLM: %s" % [vecopoax])

                                                         
    qzqgwgze = qzqgwgze + ozeteyfw + xjjmrlek
        
    return lioanwgd + qzqgwgze + "\n[/gds_context]"

func oirfelwv(knomsyfq: EditorInterface) -> Dictionary:
    var ihptrqab = knomsyfq.get_script_editor()
    var crvrixfu: Array = ihptrqab.get_open_scripts()
    
    var orivnuus: Dictionary = {}
    
    for script in crvrixfu:
        var cbsozsxm: String = script.get_source_code()
        var mimmyqkd: String = script.get_path()
                                            
        orivnuus[mimmyqkd] = cbsozsxm
        
    return orivnuus

func elcmlmfi(qkpxkxfi: String, ttntuoog: EditorInterface) -> String:
                                                                                                                          
    var tsoikoqh = qkpxkxfi.replace(yzworrty, yzworrty.substr(1)).strip_edges()
    
                               
    var gcpnxnwb = ttntuoog.get_edited_scene_root()
    if not gcpnxnwb:
        return tsoikoqh + "\n[gds_context]Node tree: No scene is currently being edited.[/gds_context]"
    
                                
    var bolnrlor = "\n[gds_context]Node tree:\n"
    bolnrlor += fvllfshr(gcpnxnwb)
    bolnrlor += "--\n"

    if bolnrlor.length() > ufkmkrwn:                                                            
        bolnrlor = bolnrlor.substr(0, ufkmkrwn) + "..."
        
    bolnrlor += "\n[/gds_context]"
        
    return tsoikoqh + bolnrlor

func fvllfshr(ewnpbmjt: Node, jjrmkrse: String = "") -> String:
    var lspsxger = jjrmkrse + "- " + ewnpbmjt.name
    lspsxger += " (" + ewnpbmjt.get_class() + ")"
    
                                                 
    if ewnpbmjt is Node2D:
        lspsxger += " position " + str(ewnpbmjt.position)
    elif ewnpbmjt is Control:                      
        lspsxger += " position " + str(ewnpbmjt.position)
    elif ewnpbmjt is Node3D:
        lspsxger += " position " + str(ewnpbmjt.position)

                                                                              
    if ewnpbmjt.owner and ewnpbmjt.owner != ewnpbmjt:
        lspsxger += " [owner: " + ewnpbmjt.owner.name + "]"
    
    lspsxger += "\n"
    var bjsraybs = jjrmkrse + "  "
    
                                                  
    if ewnpbmjt is CollisionObject2D or ewnpbmjt is CollisionObject3D:
        var axqwebbx = []
        var gnbkokpn = []
        
                            
        for i in range(1, 33):                                
            if ewnpbmjt.get_collision_layer_value(i):
                axqwebbx.append(str(i))
            if ewnpbmjt.get_collision_mask_value(i):
                gnbkokpn.append(str(i))
        
        if axqwebbx.size() > 0 or gnbkokpn.size() > 0:
            lspsxger += bjsraybs + "Collision: layer: " + ",".join(axqwebbx)
            lspsxger += " mask: " + ",".join(gnbkokpn) + "\n"
    
                                                                          
                                                                 
    if ewnpbmjt.is_inside_tree():
                                
        var sjptesej = []
        for prop in ewnpbmjt.get_property_list():
            var hccloreg = prop["name"]
            var lnjuapxj = ewnpbmjt.get(hccloreg)
            if lnjuapxj is Resource and lnjuapxj != null:
                var zrvhinxo = lnjuapxj.get_class()
                if lnjuapxj.resource_name != "":
                    zrvhinxo = lnjuapxj.resource_name
                sjptesej.append("%s (%s)" % [hccloreg, zrvhinxo])
            
        if not sjptesej.is_empty():
            lspsxger += bjsraybs + "Assigned subresources: " + ", ".join(sjptesej) + "\n"
        
                                       
    if ewnpbmjt.get_script():
        lspsxger += bjsraybs + "Script: " + ewnpbmjt.get_script().resource_path + "\n"
    
                            
    if ewnpbmjt.unique_name_in_owner:
        lspsxger += bjsraybs + "Unique name: %" + ewnpbmjt.name + "\n"
    
                
    var tqlieubk = ewnpbmjt.get_groups()
    if not tqlieubk.is_empty():
                                                              
        tqlieubk = tqlieubk.filter(func(group): return not group.begins_with("_"))
        if not tqlieubk.is_empty():
            lspsxger += bjsraybs + "Groups: " + ", ".join(tqlieubk) + "\n"
    
                                           
    if ewnpbmjt.scene_file_path:
        lspsxger += bjsraybs + "Instanced from: " + ewnpbmjt.scene_file_path + "\n"
    
                      
    for child in ewnpbmjt.get_children():
        lspsxger += fvllfshr(child, bjsraybs)
    return lspsxger

func hkyyfanc(trfrargv: String, xfhvqcrn: EditorInterface) -> String:
    var asriqqdy = trfrargv.replace(faijcwxk, faijcwxk.substr(1)).strip_edges()

    var bmazgcxk: Array = Array(xfhvqcrn.get_open_scenes())
    if bmazgcxk.is_empty():
        return asriqqdy + "\n[gds_context]Node tree:\n No scenes are currently open.[/gds_context]"

    var poikbpua = "\n[gds_context]Node tree:\n"
    
    for scene_path in bmazgcxk:
        var vcsozzvm: PackedScene = load(scene_path)
        if not vcsozzvm:
            poikbpua += "Could not load scene: %s\n" % scene_path
            continue

        var swyejdri: Node = vcsozzvm.instantiate()
        if not swyejdri:
            continue

        var kqpjqqgq = fvllfshr(swyejdri)

        poikbpua += "Scene: %s\n" % scene_path
        poikbpua += kqpjqqgq
        poikbpua += "--\n"
        
                                
        swyejdri.free()

    if poikbpua.length() > ufkmkrwn:
        poikbpua = poikbpua.substr(0, ufkmkrwn) + "..."

    poikbpua += "\n[/gds_context]"

    return asriqqdy + poikbpua

func mydpeuby(bvkjfdhx: String, jsvzhzpz: EditorInterface) -> String:
                                                                                                                          
    var owdykcwz = bvkjfdhx.replace(zelpnpco, zelpnpco.substr(1)).strip_edges()

    var vpkrzlel = jsvzhzpz.get_resource_filesystem()
    var uvlgwutd = "res://"
    
                                
    var aqzmppfz = "\n[gds_context]\nFile Tree:\n"
    aqzmppfz += rwokqfop(vpkrzlel.get_filesystem_path(uvlgwutd))
    aqzmppfz += "--\n"
    
    if aqzmppfz.length() > ufkmkrwn:                                                            
        aqzmppfz = aqzmppfz.substr(0, ufkmkrwn) + "..."
            
    aqzmppfz += "\n[/gds_context]"
    
    return owdykcwz + aqzmppfz

func rwokqfop(sazmoulz: EditorFileSystemDirectory, gaqkropm: String = "") -> String:
    var qgpyerob = ""
    
                                                          
    var xobvmlgh = sazmoulz.get_path()
    if xobvmlgh == "res://addons/gamedev_assistant/":
                                
        var fodlomob = EditorInterface.get_editor_settings()
        var wjahqxai = fodlomob.has_setting("gamedev_assistant/development_mode") and fodlomob.get_setting("gamedev_assistant/development_mode") == true
        if not wjahqxai:
            return gaqkropm + "+ gamedev_assistant/\n"                                            
    
                                                   
    if sazmoulz.get_path() != "res://":
        qgpyerob += gaqkropm + "+ " + sazmoulz.get_name() + "/\n"
        gaqkropm += "  "
    
                                      
    for i in sazmoulz.get_subdir_count():
        var ozwcpezm = sazmoulz.get_subdir(i)
        qgpyerob += rwokqfop(ozwcpezm, gaqkropm)
    
    for i in sazmoulz.get_file_count():
        var otthzchd = sazmoulz.get_file(i)
        qgpyerob += gaqkropm + "- " + otthzchd + "\n"
    
    return qgpyerob

func shmayiws(vhkxkyfu: String, xkyvkwps: EditorInterface) -> String:
                                                                                                                          
    var vzqheuvp = vhkxkyfu.replace(mcibiiny, mcibiiny.substr(1)).strip_edges()

                                                                                                       
    var rqiygvfv: Node = xkyvkwps.get_base_control()
    var erjrqdgj: RichTextLabel = euqpecar(rqiygvfv)

    if erjrqdgj:
        var lqmrfdjn = erjrqdgj.get_parsed_text()
        
        if lqmrfdjn.length() > hvihbaur:                     
                                                                                            
            lqmrfdjn = lqmrfdjn.substr(-hvihbaur) + "..."
        
        if lqmrfdjn.length() > 0:
            return vzqheuvp + "\n[gds_context]\nOutput Panel:\n" + lqmrfdjn + "\n[/gds_context]"
        else:
            return vzqheuvp + "\n[gds_context]No contents in the Output Panel.[/gds_context]"
    else:
        print("No RichTextLabel under @EditorLog was found.")
        return vzqheuvp + "\n--\nOutput Panel: Could not find the label.\n--\n"

func euqpecar(dtqbnssf: Node) -> RichTextLabel:
                                              
    if dtqbnssf is RichTextLabel:
        var cjrdymzw: Node = dtqbnssf.get_parent()
        if cjrdymzw:
            var sknqhelb: Node = cjrdymzw.get_parent()
                                                           
            if sknqhelb and sknqhelb.name.begins_with("@EditorLog"):
                return dtqbnssf

                              
    for child in dtqbnssf.get_children():
        var jmlfvhjv: RichTextLabel = euqpecar(child)
        if jmlfvhjv:
            return jmlfvhjv

    return null

func lixbyvxq(rbaudkup: String, mijleelb: EditorInterface) -> String:         
                                                                                                                          
    var hhkihdfl = rbaudkup.replace(vumqtzig, vumqtzig.substr(1)).strip_edges()
                                                                                                    
                                                                                                  
    var nkxbvblj = []                                                                              
    var puazaqbs = OS.execute("git", ["diff"], nkxbvblj, true)                                    
                                                                                                    
    if puazaqbs == 0:                                                                            
        var dbqpxtip = "\n[gds_context]\nGit Diff:\n" + "\n".join(nkxbvblj) + "\n"  
        
        if dbqpxtip.length() > ufkmkrwn:                                                            
            dbqpxtip = dbqpxtip.substr(0, ufkmkrwn) + "..."
        
        dbqpxtip += "[/gds_context]"
        
        return hhkihdfl + dbqpxtip                                                
    else:                                                                                         
        return hhkihdfl + "\n--\nGit Diff: Failed to execute git diff command.\n--\n"

func vzzsnamb(putpfswv: String, aredtftc: EditorInterface) -> String:
                                                                                                                          
    var uvbemhvx = putpfswv.replace(ioiiyfol, ioiiyfol.substr(1)).strip_edges()
    return uvbemhvx

func zymiincg(qzgmlofz: String) -> String:
    var miptslne = qzgmlofz.replace(mfenzgjr, mfenzgjr.substr(1)).strip_edges()
    
    var sazgrfyg = []
    var pxehyczb = ProjectSettings.get_property_list()
    
    for prop in pxehyczb:
        var cgndpeud: String = prop["name"]
        var dbfaevpi = ProjectSettings.get(cgndpeud)
        
                                             
        if cgndpeud.begins_with("input/"):
            if dbfaevpi is Dictionary or dbfaevpi is Array:
                sazgrfyg.append("%s = %s" % [cgndpeud, str(dbfaevpi)])
            elif dbfaevpi == null or (dbfaevpi is String and dbfaevpi.is_empty()):
                continue
            else:
                sazgrfyg.append("%s = %s" % [cgndpeud, dbfaevpi])
            continue
        
                                         
        if dbfaevpi is Dictionary or dbfaevpi is Array:
            continue
            
                                                      
        if dbfaevpi == null or (dbfaevpi is String and dbfaevpi.is_empty()):
            continue
            
        sazgrfyg.append("%s = %s" % [cgndpeud, dbfaevpi])
    
    sazgrfyg.sort()
    var gyfajfcq = "Unassigned project settings have been omitted from this list:\n" + "\n".join(sazgrfyg)
    
    miptslne = miptslne + "\n" + gyfajfcq
    return miptslne
