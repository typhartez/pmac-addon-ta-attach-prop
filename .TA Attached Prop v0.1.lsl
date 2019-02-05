// TA Attach Prop v0.1 Add-on for PMAC
// By Typhaine Artez, based on PAO-NC Multi-PRops v2.0 by Aine Caoimhe
// January 2019
// Provided under Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
// Please be sure you read and adhere to the terms of this license: https://creativecommons.org/licenses/by-nc-sa/4.0/
//
// This script uses the following OSSL functions so they must be enabled for the owner in the region:
// - osMessageObject()      // to communicate with the PMAC build

key rezzer = NULL_KEY;
integer sitter = -1;
integer attach_to = 0;

sayBlock() {
    string s;
    key who;
    if (sitter > -1 && rezzer != NULL_KEY) {
        s = "TA_ATTACH_PROP{"+llGetObjectName()+"::"+(string)sitter;
        who = llGetOwnerKey(rezzer);
    }
    else {
        s = "(replace <sit> with the sitter you want to attach to):\nTA_ATTACH_PROP{"+llGetObjectName()+"::<sit>";
        who = llGetOwner();
    }
    // http://wiki.secondlife.com/wiki/Category:LSL_Attachment
    string at = llList2String(["auto", "chest", "skull", "left shoulder", "right shoulder", "left hand", "right hand", "left foot", "right foot", "spine", "pelvis", "mouth", "chin", "left ear", "right ear", "left eye", "right eye", "nose", "right upper arm", "right lower arm", "left upper arm", "left lower arm", "right hip", "right upper leg", "right lower leg", "left hip", "left upper leg", "left lower leg", "stomach", "left pectoral", "right pectoral", "HUD center 2", "HUD top right", "HUD top", "HUD top left", "HUD center", "HUD bottom left", "HUD bottom", "HUD bottom right", "neck", "avatar center", "left ring finger", "right ring finger", "tail base", "tail tip", "left wing", "right wing", "jaw", "alt left ear", "alt right ear", "alt left eye", "alt right eye", "tongue", "groin", "left hind foot", "right hind foot" ], llGetAttached()));
    if (at == "") at = "auto";
    llRegionSayTo(who, 0, s + "::"+(string)llGetLocalPos()+"::"+(string)llGetLocalRot()+"::"+at+"}");
}

default {
    on_rez(integer start) {
        if (start) state prop;
        sitter = -1;
        attach_to = 0;
    }
    touch_start(integer n) {
        if (llDetectedKey(0) != llGetOwner() || llGetAttached() == 0) return;
        sayBlock();
    }
}

state prop {
    state_entry() {
        llSetClickAction(CLICK_ACTION_TOUCH);
    }
    dataserver(key id, string data) {
        rezzer = id;
        list l = llParseString2List(data, ["|"], []);
        string cmd = llList2String(l, 0);
        if ("TA_OBJECT_ATTACH" == cmd && llGetAttached() == 0) {
            if (llGetAgentSize(llList2Key(l, 1)) == ZERO_VECTOR) {
                osMessageObject(id, "TA_OBJECT_DEREZ");
                llDie();
            }
            sitter = llList2Integer(l, 3);
            attach_to = llList2Integer(l, 2);
            llRequestPermissions(llList2Key(l, 1), PERMISSION_ATTACH);
        }
        else if ("TA_OBJECT_DIE" == cmd) {
            llDetachFromAvatar();
            osMessageObject(id, "TA_OBJECT_DEREZ");
            llDie();
        }
    }
    run_time_permissions(integer p) {
        if (p & PERMISSION_ATTACH) {
            llAttachToAvatarTemp(attach_to);
        }
    }
    touch_start(integer n) {
        if (rezzer == NULL_KEY || llDetectedKey(0) != llGetOwnerKey(rezzer) || llGetAttached() == 0) return;
        sayBlock();
    }
}
