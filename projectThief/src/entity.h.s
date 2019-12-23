;;=============================================================
;;  ENTITY 
;;  It will inherit Drawable Component
;;=============================================================

.macro Entity _name, entity_x, entity_y, entity_vx, entity_vy, entity_js, entity_w, entity_h, entity_spr, entity_update, entity_alive, entity_attacking, entityxC0, entityyC0, entityx80, entityy80, alive, room, chasing, type, blocking, blocksLeft, frame, total_frames, direction
_name:
    ;;I'll save these lines as comment because we might need them in the future
    ;Movable _name'movable, entity_x, entity_y, entity_vx, entity_vy, entity_js  
    ;movableSize = . - #_name
    .db entity_x, entity_y      ;;X and Y position of the entity --> Move after to DRAWABLE COMPONENT(??)
    .db entity_vx, entity_vy    ;;X and Y velocity of the entity
    .db entity_js               ;;Entity's jump state
    .db entity_w, entity_h      ;;Width and Height of the entity --> Move after to DRAWABLE COMPONENT
    .dw entity_spr
    .dw entity_update           ;;Change to .dw and move after to DRAWABLE COMPONENT
    .db entity_alive            ;;The entity is alive or not (1 -> alive, 0 -> dead)
    .db entity_attacking        ;;The entity is attacking or not (1 -> attacking, 0 -> not attacking)
    .db entityxC0, entityyC0
    .db entityx80, entityy80
    .db alive                   ;;Indicator if the entity is alive
    .db room                    ;;Where the entity is
    .db chasing                 ;;If the entity is chasing another one
    .db type                    ;;Type of entity
    .db blocking                ;;See if entity is blocking
    .db blocksLeft              ;;How many blocks has the entity left
    .db frame                   ;;Current frame
    .db total_frames            ;;Total frames of the current animation
    .db direction               ;;The direction of the entity - 0 is Right and 1 is Left
    _name'_size = . - _name
.endm

.macro EnemyDefault _name, _number
    Entity _name'_number, 0x10, 0x65, 0x00, 0x00, 0xFF , 0x02, 0x08, _enemy_idle_0, enemy_update, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
.endm

.macro NEntities _name, _howmany 
    _counter = 0
    .rept _howmany
        EnemyDefault _name, \_counter
        _counter = _counter + 1
    .endm

.endm

e_x     = 0
e_y     = 1
e_vx    = 2
e_vy    = 3
e_js    = 4
e_w     = 5
e_h     = 6
e_spr_l = 7
e_spr_h = 8 
e_updl  = 9
e_updh  = 10 
e_a     = 11
e_att   = 12
e_xC0   = 13
e_yC0   = 14
e_x80   = 15
e_y80   = 16
e_aliv  = 17
e_room  = 18
e_chas  = 19
e_type  = 20
e_block = 21
e_blocksLeft = 22
e_fr    = 23
e_total = 24
e_dir = 25

;;Definition of public methods
    .globl entity_update
    .globl entity_draw
    .globl entity_erase
    .globl hero
    .globl enemymodel
    .globl jump_control
    .globl getEnemyVector
    .globl getEntitySize
    .globl runFunconEnemyVector
    .globl kill_entity
    .globl reset_hero
    .globl updateRoom
    .globl getPlayerRoom
    .globl storeCoordinatesToEraseBuffer
    .globl _idle_0
    .globl _attack_0
    .globl _run_0
    .globl _protect_0
    .globl _jump_0
    .globl _enemy_idle_0
    .globl _enemy_attack_0
    .globl _enemy_run_0
    .globl entity_move_right
    .globl entity_move_left
    .globl block
    .globl start_jump
    .globl punch
    .globl _door
;;==================================

