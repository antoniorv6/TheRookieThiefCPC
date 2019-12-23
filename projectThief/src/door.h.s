;;==========================================
;;  DOOR CLASS
;;  Will let you travel through rooms
;;==========================================

.macro Door _name, door_x, door_y, door_w, door_h, door_sp, door_room, door_droom, door_dX, door_dY, door_lck
_name:
    .db door_x, door_y
    .db door_w, door_h
    .dw door_sp
    .db door_room, door_droom
    .db door_dX, door_dY
    .db door_lck
     _name'_size = . - _name
.endm

.macro DoorDefault _name, _number
    Door _name'_number, 0x25, 0x56, 0x04, 0x16, _door, 0x00, 0x04, 0x40, 0x65, 0x00 
.endm

.macro NDoors _name, _howmany 
    _counter = 0
    .rept _howmany
        DoorDefault _name, \_counter
        _counter = _counter + 1
    .endm

.endm

do_x = 0     ;;X location of the door
do_y = 1     ;;Y location of the door
do_w = 2     ;;Door width
do_h = 3     ;;Door height
do_sp_l = 4    ;;Door sprite, will have to change
do_sp_h = 5 
do_r = 6     ;;Room of the door (I use the room number)
do_dr = 7    ;;Destiny room
do_dX = 8    ;;Where the player should be in x coordinates when crossing the door
do_dY = 9    ;;Where the player should be in y coordinates when crossing the door
do_lck = 10   ;;Is the door locked? -> 01 yes, 00 no

;;Public methods
.globl door_draw
.globl create_door
.globl runFunconDoorVector
.globl edit_door
.globl door_update
.globl edit_door_roomParameters
.globl resetDoors
.globl door_copy
.globl lock_door
