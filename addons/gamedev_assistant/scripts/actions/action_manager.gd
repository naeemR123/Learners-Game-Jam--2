                                                                  
@tool
extends Node

signal tmvpeqiy(action_type: String, success: bool, error_message: String, node_name: String, subresource_name: String, button: Button)
signal pvbkfcft(action_type: String, disable: bool)

                                     
const htxvqpto = preload("res://addons/gamedev_assistant/scripts/actions/action_parser_utils.gd")
const tcsbwxxt = preload("res://addons/gamedev_assistant/scripts/actions/create_file_action.gd")
const hveeyseg = preload("res://addons/gamedev_assistant/scripts/actions/create_scene_action.gd")
const sgbyijkb = preload("res://addons/gamedev_assistant/scripts/actions/create_node_action.gd")
const lbwffnsc = preload("res://addons/gamedev_assistant/scripts/actions/edit_node_action.gd")
const vnyyrrne = preload("res://addons/gamedev_assistant/scripts/actions/add_subresource_action.gd")
const fbuhcnzg = preload("res://addons/gamedev_assistant/scripts/actions/edit_subresource_action.gd")
const wqsupwoy = preload("res://addons/gamedev_assistant/scripts/actions/assign_script_action.gd")
const cpvqiyww = preload("res://addons/gamedev_assistant/scripts/actions/add_existing_scene_action.gd")
const rjlrjtgs = preload("res://addons/gamedev_assistant/scripts/actions/edit_script_action.gd")

const oqlixqld = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_ActionButton.tscn")
const fdzazmew = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_ApplyAllButton.tscn")
const hoqojduc = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_ActionsContainer.tscn")
const znkjcuwb = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_Spacing.tscn")

var rznskdqj: Control
var ftfvqjym : VBoxContainer
var ninznaax: Array = []
var umkbltgi : Button
var jgytqeje : bool
var ppgpxdty : bool
var trezbqlu = 0

                             
var bxcefyug: Timer

func _ready():
    
    var elphgxkc = EditorInterface.get_editor_settings()       
    ppgpxdty = elphgxkc.has_setting("gamedev_assistant/development_mode") and elphgxkc.get_setting('gamedev_assistant/development_mode') == true    

                                                           
    tmvpeqiy.connect(iyagltjn)
    pvbkfcft.connect(wtkzvbgm)

                                    
    bxcefyug = Timer.new()
    bxcefyug.wait_time = 0.2
    bxcefyug.one_shot = true
    add_child(bxcefyug)
    bxcefyug.timeout.connect(xejdjdgk)

                            
func kofqnnoc(kinmhpea: String, hgjhslgu: int) -> Array:
    var njsovgle = []

    var nywpfgvm = "[gds_actions]"
    var hwmuktfw = "[/gds_actions]"

    var forrjukc = kinmhpea.find(nywpfgvm)
    var tyyckbba = kinmhpea.find(hwmuktfw)

    if forrjukc == -1 or tyyckbba == -1:
        return njsovgle                                       

                                                                
    var ipeiykfc = forrjukc + nywpfgvm.length()
    var cidmmukr = tyyckbba - ipeiykfc
    var ysogjbbw = kinmhpea.substr(ipeiykfc, cidmmukr).strip_edges()
    
    if ppgpxdty:
        print(ysogjbbw)

                                        
    var qubnvslk = ysogjbbw.split("\n")
    for line in qubnvslk:
        line = line.strip_edges()
        if line == "":
            continue

        var iettexlb = fkglragz(line, kinmhpea)
        if iettexlb:
            iettexlb["message_id"] = hgjhslgu
            njsovgle.append(iettexlb)

    return njsovgle


                    
func umozdkno(tdyaxtok: String, afpxofxa: String, fslkeczx: Button) -> bool:
    var xxtvavkj = tcsbwxxt.execute(tdyaxtok, afpxofxa)
    tmvpeqiy.emit("create_file", xxtvavkj.success, xxtvavkj.error_message, "", "", fslkeczx)
    return xxtvavkj.success

                     
func bffrigmn(igvgbscy: String, rhsmzqxq: String, anjnmroa: String, cqnwqhvv: Button) -> bool:
    var vghutxvm = hveeyseg.execute(igvgbscy, rhsmzqxq, anjnmroa)
    tmvpeqiy.emit("create_scene", vghutxvm.success, vghutxvm.error_message, "", "", cqnwqhvv)
    return vghutxvm.success

                    
func hafcrccb(srgurrrg: String, blyvikcy: String, cmwuftra: String, btceozqt: String, macrxrtg: Dictionary, omsmiacp: Button) -> bool:
    var eioztrgs = sgbyijkb.execute(srgurrrg, blyvikcy, cmwuftra, btceozqt, macrxrtg)
    tmvpeqiy.emit("create_node", eioztrgs.success, eioztrgs.error_message, blyvikcy, "", omsmiacp)
    return eioztrgs.success
    
                  
func oiyhnpcp(yhdplpof: String, rulgcuyi: String, kciafdgr: Dictionary, yphkkujm: Button) -> bool:
    var yimslifp = lbwffnsc.execute(yhdplpof, rulgcuyi, kciafdgr)
    tmvpeqiy.emit("edit_node", yimslifp.success, yimslifp.error_message, yimslifp.node_type, "", yphkkujm)
    return yimslifp.success
    
func jjujazzi(obmiaqqy: String, yngnamhj: String, aikrrtfn: String, mzuwhyxo: Dictionary, qmtkzman: Button) -> bool:
    var jrsdvyzs = vnyyrrne.execute(obmiaqqy, yngnamhj, aikrrtfn, mzuwhyxo)
    tmvpeqiy.emit("add_subresource", jrsdvyzs.success, jrsdvyzs.error_message, jrsdvyzs.node_type, aikrrtfn, qmtkzman)
    return jrsdvyzs.success

                         
func yyfailcp(vycgleeb: String, yzckenjq: String, jxqsktcn: String, srlsefqc: Dictionary, lguidwoq: Button) -> bool:
    var jyyqzgcr = fbuhcnzg.execute(vycgleeb, yzckenjq, jxqsktcn, srlsefqc)
                                                                              
    tmvpeqiy.emit("edit_subresource", jyyqzgcr.success, jyyqzgcr.error_message, jyyqzgcr.node_type, jyyqzgcr.subresource_type, lguidwoq)
    return jyyqzgcr.success

func yofyefsi(zgitigri: String, zvgqrnrt: String, ftuzyqzv: String, eudoighd: Button) -> bool:  
      var rivolqxg = wqsupwoy.execute(zgitigri, zvgqrnrt, ftuzyqzv)  
      tmvpeqiy.emit("assign_script", rivolqxg.success, rivolqxg.error_message, "", "", eudoighd)  
      return rivolqxg.success  

func mztytzqe(dqxngsuk: String, acncwvau: String, oucwsvyw: String, oeshcoxp: String, uleizehg: Dictionary, jwcfrueq: Button) -> bool:
    var uxqfxabx = cpvqiyww.execute(dqxngsuk, acncwvau, oucwsvyw, oeshcoxp, uleizehg)
    tmvpeqiy.emit("add_existing_scene", uxqfxabx.success, uxqfxabx.error_message, "", "", jwcfrueq)
    return uxqfxabx.success  
    
func jybwspqh(bfowwcxl: String, gnfjgozh: int, jrtxphdp: Button) -> void:
    var cccdkoxq = $"../APIManager"
    var sdjrohlh = rjlrjtgs.execute(bfowwcxl, gnfjgozh, jrtxphdp, cccdkoxq)
    
                                                                                                     
                                                                                   
    if sdjrohlh is Dictionary:
        tmvpeqiy.emit("edit_script", sdjrohlh.success, sdjrohlh.error_message, "", "", jrtxphdp)
    
                                                                                  
                                                                           


                                 
func bdplldig(iotspmpf: Array, galhomut: Control) -> void:
    
    rznskdqj = galhomut    
    rdfwvlxa()
    
    ftfvqjym = hoqojduc.instantiate()
    var szcxisdj = znkjcuwb.instantiate()
    ftfvqjym.add_child(szcxisdj)
    rznskdqj.add_child(ftfvqjym)
    
                                                        
    if iotspmpf.size() > 1:
        umkbltgi = fdzazmew.instantiate()
        umkbltgi.text = "Apply All"
        umkbltgi.disabled = false
        umkbltgi.pressed.connect(waihbvnk)
        umkbltgi.tooltip_text = "Apply the actions listed below from top to bottom"
        ftfvqjym.add_child(umkbltgi)

    for action in iotspmpf:
        var qcvczjhh = oqlixqld.instantiate()

        var vsmrshrr = ""
        var apgrzvqy = []
        
        match action.type:
            "create_file":
                vsmrshrr = "Create {path}".format({"path": action.path})
                apgrzvqy.append("Create file")
            "create_scene":
                vsmrshrr = "Create {path}".format({
                    "path": action.path,
                })
                apgrzvqy.append("Create scene")
            "create_node":
                var yytcmooy = action.scene_path.get_file()
                var hahudzod = action.parent_path if action.parent_path != "" else "root"
                vsmrshrr = "Create {type} \"{node_name}\"".format({
                    "type": action.node_type,
                    "node_name": action.name
                })
                apgrzvqy.append("Create node")
                apgrzvqy.append("Scene: %s" % yytcmooy)                
            "edit_node":
                var yytcmooy = action.scene_path.get_file()
                vsmrshrr = "Edit %s" % [action.node_name]
                
                apgrzvqy.append("Edit node")
                apgrzvqy.append("Scene: %s" % yytcmooy)
            "add_subresource":
                var yytcmooy = action.scene_path.get_file()
                vsmrshrr = "Add %s to %s" % [
                    action.subresource_type,
                    action.node_name
                ]                
                apgrzvqy.append("Add subresource")
                apgrzvqy.append("Scene: %s" % yytcmooy)
            "edit_subresource":
                var yytcmooy = action.scene_path.get_file()
                vsmrshrr = "Edit %s on %s" % [
                    action.subresource_property_name,                                       
                    action.node_name                                                
                ]
                apgrzvqy.append("Edit subresource")
                apgrzvqy.append("Scene: %s" % yytcmooy)
                apgrzvqy.append("Property: %s" % action.subresource_property_name)                
            "assign_script":  
                var yytcmooy = action.scene_path.get_file()  
                var xwlgcrzz = action.script_path.get_file()
                vsmrshrr = "Attach %s to %s" % [  
                    xwlgcrzz,  
                    action.node_name  
                ]
                apgrzvqy.append("Attach script")
                apgrzvqy.append("File: %s" % xwlgcrzz)
                apgrzvqy.append("Scene: %s" % yytcmooy)                
            "add_existing_scene":
                var jciswleh = action.existing_scene_path.get_file()
                var cvbkdttw = action.target_scene_path.get_file()
                vsmrshrr = "Add %s to %s" % [jciswleh, cvbkdttw]
                
                apgrzvqy.append("Add existing scene")
                apgrzvqy.append("Source: %s" % jciswleh)
                apgrzvqy.append("Target: %s" % cvbkdttw)  
            "edit_script":
                vsmrshrr = "Edit {path}".format({"path": action.path})
                apgrzvqy.append("Edit script")
                apgrzvqy.append("Path: %s" % action.path)
                                
                              
        if action.has("path"):
            apgrzvqy.append("Path: %s" % action.path)
        
        if action.has("scene_name"):
            apgrzvqy.append("Scene: %s" % action.scene_name)
        
        if action.has("node_type"):
            apgrzvqy.append("Node type: %s" % action.node_type)
        
        if action.has("root_type"):
            apgrzvqy.append("Root type: %s" % action.root_type)
            
        if action.has("subresource_type"):
            apgrzvqy.append("Subresource type: %s" % action.subresource_type)
        
        if action.has("name"):
            apgrzvqy.append("Name: %s" % action.name)
        
        if action.has("node_name"):
            apgrzvqy.append("Node name: %s" % action.node_name)
       
        if action.has("parent_path"):      
            apgrzvqy.append("Parent: %s" % (action.parent_path if action.parent_path else "root"))
            
        if action.has("modifications") or action.has("properties"):
            var nftjnlnm = action.get("modifications", action.get("properties", {}))
            if nftjnlnm.size() > 0:
                apgrzvqy.append("\nProperties to apply:")
                for key in nftjnlnm:
                    apgrzvqy.append("• %s = %s" % [key, str(nftjnlnm[key])])
                
        qcvczjhh.tooltip_text = "\n".join(apgrzvqy)

        qcvczjhh.text = vsmrshrr
        qcvczjhh.set_meta("action", action)
        qcvczjhh.pressed.connect(dszderza.bind(qcvczjhh))

        ftfvqjym.add_child(qcvczjhh)
        ninznaax.append(qcvczjhh)


                          
func rdfwvlxa() -> void:
    if rznskdqj == null:
        return
        
                                                                     
    if is_instance_valid(ftfvqjym) and ftfvqjym.is_inside_tree():
                                                                     
        if rznskdqj.has_node(ftfvqjym.get_path()):
                                                                  
            rznskdqj.remove_child(ftfvqjym)
    
                                    
    ninznaax.clear()

                                                  
func dszderza(uixhctsv: Button) -> void:
        jgytqeje = false
        wwpnknof(uixhctsv)

                                                  
func wwpnknof(fzmkiwwg: Button) -> void:
    var jocwupzw = fzmkiwwg.get_meta("action") if fzmkiwwg.has_meta("action") else {}
    
    fzmkiwwg.disabled = true

    match jocwupzw.type:
        "create_file":
            umozdkno(jocwupzw.path, jocwupzw.content, fzmkiwwg)
        "create_scene":
            bffrigmn(jocwupzw.path, jocwupzw.root_name, jocwupzw.root_type, fzmkiwwg)
        "create_node":
            var hyorrlzx = jocwupzw.modifications if jocwupzw.has("modifications") else {}
            hafcrccb(jocwupzw.name, jocwupzw.node_type, jocwupzw.scene_path, jocwupzw.parent_path, hyorrlzx, fzmkiwwg)
        "edit_node":
            oiyhnpcp(jocwupzw.node_name, jocwupzw.scene_path, jocwupzw.modifications, fzmkiwwg)
        "add_subresource":
            jjujazzi(
                jocwupzw.node_name,
                jocwupzw.scene_path,
                jocwupzw.subresource_type,
                jocwupzw.properties,
                fzmkiwwg
            )
        "edit_subresource":
             yyfailcp(
                jocwupzw.node_name,
                jocwupzw.scene_path,
                jocwupzw.subresource_property_name,
                jocwupzw.properties,                                                    
                fzmkiwwg
             )
        "assign_script":  
              yofyefsi(jocwupzw.node_name, jocwupzw.scene_path, jocwupzw.script_path, fzmkiwwg)  
        "add_existing_scene":
            mztytzqe(
                jocwupzw.node_name,
                jocwupzw.existing_scene_path,
                jocwupzw.target_scene_path,
                jocwupzw.parent_path,
                jocwupzw.modifications,
                fzmkiwwg
            )
        "edit_script":
            jybwspqh(jocwupzw.path, jocwupzw.message_id, fzmkiwwg)
        _:
            push_warning("Unrecognized action type: %s" % jocwupzw.type)


                                             
func iyagltjn(rmuukmfi: String, tfdbwyet: bool, pyltngcu: String, ynlfajrr: String, ketganhr: String, iocuijih: Button) -> void:
    if not is_instance_valid(iocuijih):
        return

                                                                         
    var huznbwrk = iocuijih.text
    var ebwnynup = iocuijih.tooltip_text
    
                                                         
    if is_instance_valid(umkbltgi):
        umkbltgi.disabled = true

    var hrwrmmpn = iocuijih.get_meta("action")
    var uoklkoxz = hrwrmmpn.get("message_id", -1)

    if uoklkoxz != -1:
        $"../APIManager".gjnrwvpr(uoklkoxz, tfdbwyet, rmuukmfi, ynlfajrr, ketganhr, pyltngcu)

                                                                             
    if rmuukmfi == hrwrmmpn.type:
        var nymrvmdf = "✓ " if tfdbwyet else "✗ "
        var segzxbfj = "\n\nACTION COMPLETED" if tfdbwyet else "\n\nACTION FAILED:\n%s\nClick to retry." % pyltngcu
        var rxjwgvta = ""                               

                                                                   
        match rmuukmfi:
            "create_file":
                rxjwgvta = ("Created file {path}" if tfdbwyet else "Failed: file creation {path}").format({"path": hrwrmmpn.path})
            "create_scene":
                rxjwgvta = ("Created scene {path}, root: {root_type}" if tfdbwyet else "Failed: scene creation {path}, root: {root_type}").format({
                    "path": hrwrmmpn.path,
                    "root_type": hrwrmmpn.root_type
                })
            "create_node":
                var vhjjjxkf = hrwrmmpn.scene_path.get_file()
                var waapxfyo = hrwrmmpn.parent_path if hrwrmmpn.parent_path != "" else "root"
                var ygyjkvgz = ""
                if hrwrmmpn.has("modifications") and hrwrmmpn.modifications.size() > 0:
                    ygyjkvgz = " with %s props" % hrwrmmpn.modifications.size()
                rxjwgvta = ("Created node {name}, type {type}, parent {parent} in scene {scene}{props}" if tfdbwyet
                                else "Failed: creating node {name}, type {type}, parent {parent} in scene {scene}{props}"
                                ).format({
                                    "name": hrwrmmpn.name,
                                    "type": hrwrmmpn.node_type,
                                    "scene": vhjjjxkf,
                                    "parent": waapxfyo,
                                    "props": ygyjkvgz
                                })
            "edit_node":
                rxjwgvta = ("Edited node \"%s\" in scene %s" if tfdbwyet
                                else "Failed: editing node \"%s\", scene: %s"
                                ) % [hrwrmmpn.node_name, hrwrmmpn.scene_path.get_file()]

            "add_subresource":
                var vhjjjxkf = hrwrmmpn.scene_path.get_file()
                var zqritrae = str(hrwrmmpn.properties.size())
                rxjwgvta = ("Added subresource %s to node %s in scene %s (%s properties)" if tfdbwyet
                                else "Failed: adding subresource %s to node %s, scene: %s (%s properties)"
                                ) % [hrwrmmpn.subresource_type, hrwrmmpn.node_name, vhjjjxkf, zqritrae]
                                
            "edit_subresource":
                 var vhjjjxkf = hrwrmmpn.scene_path.get_file()
                 var zqritrae = str(hrwrmmpn.properties.size())
                 rxjwgvta = ("Edited subresource property '%s' on node '%s' in scene %s (%s properties changed)" if tfdbwyet
                                 else "Failed: editing subresource property '%s' on node '%s', scene: %s (%s properties attempted)"
                                 ) % [hrwrmmpn.subresource_property_name, hrwrmmpn.node_name, vhjjjxkf, zqritrae]

            "assign_script":
                rxjwgvta = ("Assigned script to node \"%s\" in scene %s" if tfdbwyet
                                else "Failed: assigning script to node \"%s\", scene: %s"
                                ) % [hrwrmmpn.node_name, hrwrmmpn.scene_path.get_file()]

            "add_existing_scene":
                var vcopcsvq = hrwrmmpn.target_scene_path.get_file()
                var vhjjjxkf = hrwrmmpn.existing_scene_path.get_file()
                var zqritrae = str(hrwrmmpn.modifications.size())
                rxjwgvta = ("Added %s to %s" if tfdbwyet
                              else "Failed: adding %s to %s"
                              ) % [vhjjjxkf, vcopcsvq]
                if hrwrmmpn.modifications.size() > 0:
                    rxjwgvta += " (%s props)" % zqritrae
            "edit_script":
                rxjwgvta = ("Edited script %s" if tfdbwyet else "Failed: editing script %s") % [hrwrmmpn.path]

                                                         
        iocuijih.text = nymrvmdf + huznbwrk

                                                             
        iocuijih.tooltip_text = ebwnynup + segzxbfj

                                               
                                                             
        print('[GameDev Assistant] ' + nymrvmdf + rxjwgvta) 

        if not tfdbwyet:
            iocuijih.self_modulate = Color(1, 0, 0)                               
            
                                  
        iocuijih.set_meta("completed", true)
        
                               
        if rmuukmfi == "edit_script":
            wtkzvbgm(rmuukmfi, false)
            
                                          
        if tfdbwyet:
            iocuijih.disabled = true
        
                              
func fkglragz(lqopyclr: String, zrwbduia: String) -> Dictionary:
    var bjgesebp = [tcsbwxxt, hveeyseg, sgbyijkb, lbwffnsc, vnyyrrne, fbuhcnzg, wqsupwoy, cpvqiyww, rjlrjtgs]
    for parser in bjgesebp:
        var adcqtmve = parser.parse_line(lqopyclr, zrwbduia)
        if not adcqtmve.is_empty():
            return adcqtmve
    return {}
    
func waihbvnk() -> void:
    if jgytqeje:
        return                                                   
        
    jgytqeje = true
    umkbltgi.disabled = true
    trezbqlu = 0
    
                                                               
    for button in ninznaax:
                                                              
        if not button.get_meta("completed", false):
            button.disabled = true
    
                                                                   
    tmvpeqiy.connect(zeqqpcef)
    
                                                      
    msqidnte()

func zeqqpcef(mgagaxdm, skofzzra, ililbmwu, kfwdmdnw, vhhxycjt, bmxfxoie: Button):
                                                                           
    if not jgytqeje:
        return

                                                                                  
    if ninznaax.size() > trezbqlu and bmxfxoie == ninznaax[trezbqlu]:
        trezbqlu += 1
                                                                                        
        bxcefyug.start()

func msqidnte():
                                                        
    if trezbqlu >= ninznaax.size():
        jgytqeje = false
        tmvpeqiy.disconnect(zeqqpcef)                                     
        print("[GameDev Assistant] Apply All sequence completed.")
        return

                                            
    var diynxyif = ninznaax[trezbqlu]
    if is_instance_valid(diynxyif):
                                                                
        if diynxyif.get_meta("completed", false):
            trezbqlu += 1
            msqidnte()
            return
            
        wwpnknof(diynxyif)
    else:
                                                                            
        trezbqlu += 1
        msqidnte()

func xejdjdgk():
                                                                                    
    call_deferred("msqidnte")

func wtkzvbgm(rbhrflsb: String, lnvdqzbi: bool) -> void:

    if jgytqeje:
        return
    
    for button in ninznaax:
        var pjyivxbt = button.get_meta("action") if button.has_meta("action") else {}
        if pjyivxbt.get("type", "") == rbhrflsb:
                                                
            if not button.get_meta("completed", false):
                button.disabled = lnvdqzbi
