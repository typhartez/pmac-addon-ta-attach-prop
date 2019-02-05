// TA Attach Prop v0.1 Add-on for PMAC
// By Typhaine Artez, based on PAO-NC Multi-PRops v2.0 by Aine Caoimhe
// January 2019
// Provided under Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
// Please be sure you read and adhere to the terms of this license: https://creativecommons.org/licenses/by-nc-sa/4.0/
//
// This script uses the following OSSL functions so they must be enabled for the owner in the region:
// - osMessageObject()      // to communicate with a rezzed prop to kill it
// Also it rezzes an object so it needs to be owned by someone with sufficient permission to rez an object in the parcel
//
// QUICK INSTRUCTIONS (see the companion READ ME notecard for more detailed instructions)
// This add-on rezzes any number of props (including a single prop) and attach them to sitting avatars whenever
// an animation is played that has a command to use one
// Expected command format is: TA_ATTACH_PROP{string prop_name::integer sitter_index::vector prop_position::rotation prop_rotation::string|integer attach_point}
// You can rez the same prop multiple times for a single animation if you want to.
//
// When creating a new prop:
// - add the object to your avatar, add the script ".TA Attached Prop v0.1" to its content, edit its attached position
// - touch the attached prop, and copy the text in the local chat
// - detach the object and put it into the PMAC object
// - paste the text said by the prop into the command block for any animation you want to have the prop attached
// - replace in the command block the <sit> text with the sitter index who will get the attachment
// - add the "..addon TA Attach Prop v0.1" (this script) in the PMAC object
//
// Don't change anything below here unless you know what you're doing!
//

// list of props currently rezzed and in use: prop key| prop_object
list currentProps = [];
// list of props needed for the next animationlist: prop_object | sitter | position | rotation | attach
list nextProps = [];
// flag...to indicate that this script is in the process of rezzing items
integer rezzing = FALSE;  
// list of current sitting avatars (keys) in order
list sitters = [];

// http://wiki.secondlife.com/wiki/Category:LSL_Attachment
list ATTACH_POINTS = [ "auto"
    // 1-5
    , "chest", "skull", "left shoulder", "right shoulder", "left hand"
    // 6-10
    , "right hand", "left foot", "right foot", "spine", "pelvis"
    // 11-15
    , "mouth", "chin", "left ear", "right ear", "left eye"
    // 16-20
    , "right eye", "nose", "right upper arm", "right lower arm", "left upper arm"
    // 21-25
    , "left lower arm", "right hip", "right upper leg", "right lower leg", "left hip"
    // 26-30
    , "left upper leg", "left lower leg", "stomach", "left pectoral", "right pectoral"
    // 31-35
    , "HUD center 2", "HUD top right", "HUD top", "HUD top left", "HUD center"
    // 36-40
    , "HUD bottom left", "HUD bottom", "HUD bottom right", "neck", "avatar center"
    // 41-45
    , "left ring finger", "right ring finger", "tail base", "tail tip", "left wing"
    // 46-50
    , "right wing", "jaw", "alt left ear", "alt right ear", "alt left eye"
    // 51-55
    , "alt right eye", "tongue", "groin", "left hind foot", "right hind foot"
];

integer getAttach(string text) {
    if (text == "0" || (integer)text > 0) return (integer)text;
    integer c = llGetListLength(ATTACH_POINTS);
    while (~(--c)) {
        if (llToUpper(text) == llToUpper(llList2String(ATTACH_POINTS, c))) return c;
    }
    return 0;
}
/*
list relToReg(vector refPos,rotation refRot) {
    vector regionPos=refPos*llGetRot()+llGetPos();
    rotation regionRot=refRot*llGetRot();
    return [regionPos,regionRot];
}
*/
doProps() {
    // first reposition any props that have already been rezzed and remove any unneeded props
    if (!rezzing) {
        list keep = []; // temp holding list for the props that don't need to be removed
        while (llGetListLength(currentProps)) {
            key pkey = llList2Key(currentProps, 0);
            string name = llList2String(currentProps, 1);
            integer i = llListFindList(nextProps, [name]);
            if (!~i) {
                // prop not used for next animation, remove it
                if (pkey == NULL_KEY) llOwnerSay("WARNING! NULL_KEY value for stored prop object was called when auto-attach props was checking an existing prop with name \""+name+"\"");
                else {
                    if (llGetObjectDetails(pkey, [OBJECT_NAME]) == []) llOwnerSay("WARNING! Unable to locate expected prop object \""+name+"\" when attempting to remove it from the region.");
                    else osMessageObject(pkey, "TA_OBJECT_DIE");
                }
            }
            else {
                // TODO reusing this prop: should we send a DIE and a new attach?
                nextProps = llDeleteSubList(nextProps, i, i+4);
                keep += [pkey, name];
            }
            currentProps = llDeleteSubList(currentProps, 0, 1);
        }
        currentProps = keep;
    }
    // any remaining items in the nextProps list are to be rezzed
    rezzing = FALSE;
    integer valid = FALSE;
    while (llGetListLength(nextProps) && valid == FALSE) {
        // ensure it is in inventory
        string item = llList2String(nextProps, 0);
        if (llGetInventoryType(item) != INVENTORY_OBJECT) {
            llSay(0, "ERROR! auto-attach props was told to rez \""+item+"\" but was not found in inventory. Skipping it...");
            nextProps = llDeleteSubList(nextProps, 0, 4);
        }
        else /*if (!osIsNpc(llList2Key(sitters, llList2Integer(nextProps, 1)))) */{
            // skip NPCs, they can't accept an attach request
            valid = TRUE;
            rezzing = TRUE;
            llRezAtRoot(item, llList2Vector(nextProps, 2)*llGetRot()+llGetPos(), ZERO_VECTOR, llList2Rot(nextProps, 3), 1);
        }
    }
}

removeAll() {
    nextProps = [];
    rezzing = FALSE;
    doProps();
}

default {
    state_entry() {
        if (llGetAttached()) return;
        removeAll();
    }
    link_message(integer sender, integer num, string str, key id) {
        if (num) return; // ignore non zero messages
        list l = llParseString2List(str, ["|"], []);
        str = llList2String(l, 0);
        if (str == "GLOBAL_NEXT_AN") {
            sitters = llParseString2List((string)id, ["|"], []);
            list block = llParseString2List(llList2String(l, 1), ["{","}"], []);
            num = llListFindList(block, ["TA_ATTACH_PROP"]);
            if (~num) nextProps = llParseString2List(llList2String(block, num+1), ["::"], []);
            else nextProps = [];
            rezzing = FALSE;
            doProps();
        }
        else if (str == "GLOBAL_SYSTEM_RESET") {
            removeAll();
            llResetScript();
        }
        else if (str == "GLOBAL_SYSTEM_GOING_DORMANT") {
            removeAll();
        }
    }
    object_rez(key id) {
        if (!rezzing) return;
        string name = llList2String(llGetObjectDetails(id, [OBJECT_NAME]), 0);
        integer i = llListFindList(nextProps, [name]);
        if (!~i) return;
        integer sitter = llList2Integer(nextProps, i+1);
        osMessageObject(id, llDumpList2String(["TA_OBJECT_ATTACH",
            llList2Key(sitters, sitter),
            getAttach(llList2String(nextProps,i+4)),
            sitter
        ], "|"));
        // update working lists and do the next prop
        currentProps += [id, name];
        nextProps = llDeleteSubList(nextProps, 0, 4);
        doProps();
    }
}
