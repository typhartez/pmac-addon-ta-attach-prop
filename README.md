# PMAC addon TA Attach Prop

Attach Props Add-on for PMAC (tested with 2.5), by Typhaine Artez - January 2019.

This add-on is similar to the PAO Multi-Props add-on, but enables props to attach to sitters instead of rezzing.

It works by catching when props are rezzed, asking them to attach to one of the avatars sitting on the PMAC object.
It requires a permission request to the avatar getting the attach (automatic in case of a NPC).

## Usage

1) Attach the object to the attach point you want it, and edit it while attached, to adjust its position and rotation

2) While editing it, drop in it the `.TA Attached Prop` script

3) Touch the object, it will give you in local chat the command block to insert into the menu notecard
    As the add-on needs to know to which sitter the prop will be attached, and it is not associated with a sitter for now,
    the command gives a `<sit>` indicator, that should be replaced in the menu notecard

4) Detach the object, edit your PMAC build and put the prop object into it. Then edit the menu notecard that should attach the prop. Locate the line you want and in the plugin commands field (where you usually see `NO_COM`), paste what the object said

5) Replace `<sit>` with the index to the sitter the object should be attached to. Sitters are numbered the same that animations in one pose, starting at `0`. That means the first sitter has index `0`, second has index `1`, and so on.

    This is an example of a command block for a prop to attach on right hand of the first sitter
```
TA_ATTACH_PROP{hairbrush::0::<0.091091,-0.012737,0.003720>::<0.168339,0.016699,-0.371487,0.912897>::right hand}
```

6) Save the notecard and reset PMAC (reset the scripts)

When you sit, select the pose containing the `TA_ATTACH_PROP` command. You should get a permission request dialog, and if you accept, it should attach to your avatar where you asked.

## Command format

```
TA_ATTACH_PROP{prop_name::sitter_num::position::rotation::attach_point}
```

* **prop_name** The object to attach. It must contain the `.TA Attached Prop` script and be in the PMAC object inventory.
* **sitter_num** The index of the sitter getting the attachment request, starting from `0` for the first avatar, `1` for the second, etc...
* **position** The position of the object relative to the attach point
* **rotation** The rotation of the object relative to the attach point
* **attach_point** The attach point, by either the code value or the string reference, or `0` (zero) or `auto` to use the last attach point defined in the object properties.

### Valid values for attach point

String | LSL constant | Value |
-------|--------------|-------|
auto   |  | 0 |
chest  | ATTACH_CHEST | 1
skull  | ATTACH_HEAD | 2
left shoulder | ATTACH_LSHOULDER | 3
right shoulder | ATTACH_RSHOULDER | 4
left hand | ATTACH_LHAND | 5
right hand | ATTACH_RHAND | 6
left foot | ATTACH_LFOOT | 7
right foot | ATTACH_RFOOT | 8
spine | ATTACH_BACK | 9
pelvis | ATTACH_PELVIS | 10
mouth | ATTACH_MOUTH | 11
chin | ATTACH_CHIN | 12
left ear | ATTACH_LEAR | 13
right ear | ATTACH_REAR | 14
left eye | ATTACH_LEYE | 15
right eye | ATTACH_REYE | 16
nose | ATTACH_NOSE | 17
right upper arm | ATTACH_RUARM | 18
right lower arm | ATTACH_RLARM | 19
left upper arm | ATTACH_LUARM | 20
left lower arm | ATTACH_LLARM | 21
right hip | ATTACH_RHIP | 22
right upper leg | ATTACH_RULEG | 23
right lower leg | ATTACH_RLLEG | 24
left hip | ATTACH_LHIP | 25
left upper leg | ATTACH_LULEG | 26
left lower leg | ATTACH_LLLEG | 27
stomach | ATTACH_BELLY | 28
left pectoral | ATTACH_LEFT_PEC | 29
right pectoral | ATTACH_RIGHT_PEC | 30
HUD center 2 | ATTACH_HUD_CENTER_2 | 31
HUD top right | ATTACH_HUD_TOP_RIGHT | 32
HUD top | ATTACH_HUD_TOP_CENTER | 33
HUD top left | ATTACH_HUD_TOP_LEFT | 34
HUD center | ATTACH_HUD_CENTER_1 | 35
HUD bottom left | ATTACH_HUD_BOTTOM_LEFT | 36
HUD bottom | ATTACH_HUD_BOTTOM | 37
HUD bottom right | ATTACH_HUD_BOTTOM_RIGHT | 38
neck | ATTACH_NECK | 39
avatar center | ATTACH_AVATAR_CENTER | 40
left ring finger | ATTACH_LHAND_RING1 | 41
right ring finger | ATTACH_RHAND_RING1 | 42
tail base | ATTACH_TAIL_BASE | 43
tail tip | ATTACH_TAIL_TIP | 44
left wing | ATTACH_LWING | 45
right wing | ATTACH_RWING | 46
jaw | ATTACH_FACE_JAW | 47
alt left ear | ATTACH_FACE_LEAR | 48
alt right ear | ATTACH_FACE_REAR | 49
alt left eye | ATTACH_FACE_LEYE | 50
alt right eye | ATTACH_FACE_REYE | 51
tongue | ATTACH_FACE_TONGUE | 52
groin | ATTACH_GROIN | 53
left hind foot | ATTACH_HIND_LFOOT | 54
right hind foot | ATTACH_HIND_RFOOT | 55
