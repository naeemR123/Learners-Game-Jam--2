            
@tool
extends EditorPlugin

var zcghylew
var hydqnovz = preload("res://addons/gamedev_assistant/scripts/code_editor/CodeContextMenuPlugin.gd")
var ypdlzglc:EditorContextMenuPlugin

func _enter_tree():
                                           
    zcghylew = preload("res://addons/gamedev_assistant/dock/gamedev_assistant_dock.tscn").instantiate()
    add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL, zcghylew)
    
                              
    ypdlzglc = hydqnovz.new(zcghylew)        
    add_context_menu_plugin(EditorContextMenuPlugin.CONTEXT_SLOT_SCRIPT_EDITOR_CODE,ypdlzglc)

func _exit_tree():
                                
    remove_control_from_docks(zcghylew)
    zcghylew.queue_free()
    
    remove_context_menu_plugin(ypdlzglc)
