;;========================================================================
;; COLLECTABLE CLASS
;; It defines the data and behavour of collectable objects for the player
;;=========================================================================

.macro Collectable _name, collectable_x, collectable_y, collectable_w, collectable_h, collectable_spr, collectable_room, collectable_points, collectable_highlighted, collectable_isPickable, roomLocation, iskey
_name:
    .db collectable_x, collectable_y    ;;X and Y position of the collectable
    .db collectable_w, collectable_h    ;;Width and Heigth of the collectable
    .dw collectable_spr                 ;;It will have to change in order to introduce sprites
    .db collectable_room                ;;Room that the collectable is located (as there will be several rooms in our map)
    .db collectable_points              ;;Points that the collectable will give to the player
    .db collectable_highlighted         ;;Flag to indicate the player if the object is pickable or it has to go propper
    .db collectable_isPickable          ;;Flag to indicate if the collectable has to be drawn
    .db roomLocation                    ;;Where the object is locateed
    .db iskey                           ;;Is it a key? 01 yes, 00 no
    _name'_size = . - _name
.endm

.macro CollectableDefault _name, _number
    Collectable _name'_number, 0x30, 0x28, 0x02, 0x08, _key, 0x01, 0x01, 0x00, 0x01, 0x02, 0x00
.endm

.macro NCollectables _name, _howmany 
    _counter = 0
    .rept _howmany
        CollectableDefault _name, \_counter
        _counter = _counter + 1
    .endm

.endm

coll_x = 0
coll_y = 1
coll_w = 2
coll_h = 3
coll_sp_l = 4
coll_sp_h = 5
coll_r = 6
coll_p = 7
coll_hi = 8
coll_pi = 9
coll_ro = 10
coll_isk = 11

;;=============== GLOBAL METHODS TO BE CALLED =====================
.globl collectable_draw
.globl collectable_update
.globl collectable_erase
.globl create_collectable
.globl runFunconCollectableVector
.globl edit_collectable
.globl resetCollectables
.globl collectableModel
.globl collectable_copy
.globl defineKey
.globl _key
.globl _key_highlight
.globl _cash