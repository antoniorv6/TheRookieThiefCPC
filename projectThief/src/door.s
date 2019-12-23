;;-----------------------------LICENSE NOTICE------------------------------------
; This file is part of The Rookie Thief.

;     The Rookie Thief is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.

;     Foobar is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.

;     You should have received a copy of the GNU General Public License
;     along with Foobar.  If not, see <https://www.gnu.org/licenses/>.
;;-------------------------------------------------------------------------------

.area _DATA

.area _CODE

;;.include "cpctelera.h.s"
.include "cpcteleraFuncs.h.s"
.include "door.h.s"
.include "entity.h.s"
.include "room.h.s"
.include "doubleBuffer.h.s"
.include "GUI.h.s"

maxDoors = 10
numDoors: .db 0   

doorVector:
NDoors doorVector, maxDoors

nextDoor: .dw #doorVector

doorSize = doorVector0_size

doortoEdit: .dw #0x0000

Door doorModel, 0x25, 0x30, 0x04, 0x22, _door, 0x00, 0x04, 0x40, 0x65, 0x00 

;;==============================================
;;  CREATE DOOR
;;  Creates a door and adds it to the vector
;;  DESTROYS -> HL, AF, BX
;;  RETURNS -> HL pointer to the new entity
;;==============================================
create_door:
    ld a, (numDoors)
    ;;Correct it, i have to use maxdoors
    cp #maxDoors
    jr z, endofcreation
    inc a
    ld (numDoors), a  ;;Increment the number of entities

    ld hl, (nextDoor) ;;HL points to nextEnemy
    ld bc, #doorSize
    add hl, bc               ;;Add the size to HL
    ld (nextDoor), hl        ;;Update nextEnemy value
    or a                     ;;Carry = 0, **Secure measeure for next step**
    sbc hl, bc               ;;Substract bc to hl, in order to retrieve the pointer to the new enemy!!!

    endofcreation:
ret

;;==============================================
;;  RUN FUNC ON COLLECTABLE VECTOR
;;  Runs a function into the door vector
;;  INPUT: HL - Pointer to function to execute
;;==============================================
runFunconDoorVector:
   ld a, (numDoors)
   cp #0
   jr z, evacuate
   ld ix, #doorVector
   ld (method), hl
    loop:
        push af
        method = . + 1
        call door_draw
        pop af
        ld bc, #doorSize
        add ix, bc
        dec a
    jr nz, loop

    evacuate:

ret

;;=========================================================================
;;  THIS FUNCTION COULD EXPAND WHEN WE PUT SPRITES AND OTHER STUFF
;;  EDIT DOOR
;;  Edits a door data (Usually used after initialization in vector)
;;  INPUTS -> HL - Pointer to the collectable
;;            B  - X position of the collectable
;;            C  - Y position of the collectable
;;            D  - Room where the door has to be drawn
;;=========================================================================
edit_door:
    ld (doortoEdit), hl 
    ld ix, (doortoEdit)
    
    ld a, b        
    ld do_x(ix), a    ;;Change X value
    ld a, c
    ld do_y(ix), a    ;;Change Y value
    ld a, d
    ld do_r(ix), a   ;;Change the room

ret
;;=========================================================================
;;  EDIT DOOR ROOMPARAMETERS
;;  Edits a door data (Usually used after initialization in vector)
;;  INPUTS -> HL - Pointer to the door
;;            B  - X position of the destiny door
;;            C  - Y position of the destiny door
;;            D  - Room where the door connects
;;=========================================================================
edit_door_roomParameters:

    ld (doortoEdit), hl
    ld ix, (doortoEdit)

    ld a, b        
    ld do_dX(ix), a    ;;Change X value
    ld a, c
    ld do_dY(ix), a    ;;Change Y value
    ld a, d
    ld do_dr(ix), a   ;;Change the room

ret
;;=========================================================================
;;  LOCK_DOOR
;;  Locks a door(Usually used after initialization in vector)
;;  INPUTS -> HL - Pointer to the door
;;=========================================================================
lock_door:
    ld (doortoEdit), hl
    ld ix, (doortoEdit)     ;;Load the door into IX
    ld do_lck(ix), #0x01     ;;Load the lock status into the door
ret
;;=========================================================================
;;  LOCK_DOOR
;;  Locks a door(Usually used after initialization in vector)
;;  INPUTS -> IX - Door to unlock
;;=========================================================================
unlock_door:
    ld do_lck(ix), #0x00 ;;The door is unlocked
ret

;;==============================================
;;  DOOR_DRAW
;;  Draws the doors into the screen
;;  INPUTS -> IX - The collectable to be drawn
;;  DESTROYS -> HL, BC, AF, DE
;;  RETURNS -> None
;;==============================================
door_draw:
    
    ld b, do_r(ix)
    call getActualRoom
    cp a, b
    jr nz, no_draw

    call get_back_buffer
    ld     c, do_x(ix)         ;; C = Entity Y
    ld     b, do_y(ix)         ;; B = Entity X
    call cpct_getScreenPtr_asm
    
    ex    de, hl   ;; DE = Pointer to memory
    ;ld  a, do_sp(ix) ;; Color
    ld l, do_sp_l(ix)
    ld h, do_sp_h(ix)
    ld  b, do_h(ix)   ;; alto
    ld  c, do_w(ix)   ;; Ancho
    
    call cpct_drawSpriteMasked_asm

    no_draw:

ret

;;==============================================
;;  DOOR_UPDATE
;;  Draws the doors into the screen
;;  INPUTS -> IX - The door to be updated
;;  RETURNS -> None
;;==============================================
door_update:

    ld b, do_r(ix)
    call getActualRoom
    cp a, b
    jr nz, endupdate ;;If it isn't in the room that interests us, we do not update it (avoids bugs)

    call check_collision_hero
    jr z, endupdate

    call check_changeroom

    endupdate:

ret

;;=========================================================
;;  CHECK CHANGEROOM
;;  Checks user input and then procceds to go to other room
;;  DESTROYS -> HL
;;  RETURNS -> NZ active
;;=========================================================
check_changeroom:

    call cpct_scanKeyboard_asm
    ld hl, #Key_E
    call cpct_isKeyPressed_asm
    jr nz, nextStepDoors

    ld hl, #Joy0_Fire2
    call cpct_isKeyPressed_asm
    jr z, no_change

    nextStepDoors:
    ld a, do_lck(ix)            ;;Check if the door is locked
    cp #0x01
    jr z, see_unlock             ;;If the door is locked, we can unlock it with a key
    

    ld iy, #hero            ;;|
    ld a, do_dX(ix)         ;;|
    ld e_x(iy), a           ;;|
                            ;;|
    ld a, do_dY(ix)         ;;|
    ld e_y(iy), a           ;;| Change the hero position with our door destiny

    ;;Pressed!! we have to change the room
    ld c, do_dr(ix)         ;;Load into C the destiny room
    call change_room_direct ;;Call the method of room

    no_change:
    ret

    see_unlock:
        call hasKeys
        jr z, no_unlocking

        ;;The door can be unlocked
        call unlock_door
        call erase_keys
    
    no_unlocking:

ret

;;==============================================
;;  CHECK COLLISIONS
;;  Check if there's collision in x and y axes
;;  INPTUS -> IX: Door to check
;;  DESTROYS -> A, B, C
;;  RETURNS -> None
;;==============================================
check_collision_hero:

    ld iy, #hero
    ;Check x
    ld  a, e_x(iy)       ;;enemy_x + enemy_w - hero_x <= 0 -> no collision
    ld  c, e_w(iy)
    add c
    ld  b, do_x(ix)
    sub b
    jr z, no_collision
    jp m, no_collision

    ld a, do_x(ix)        ;;hero_x + hero_w - enemy_x <= 0 -> no collision
    ld c, do_w(ix)
    add c
    ld b, e_x(iy)
    sub b
    jr z, no_collision
    jp m, no_collision

    ;;Check y
    ld  a, e_y(iy)       ;;enemy_x + enemy_w - hero_x <= 0 -> no collision
    ld  c, e_h(iy)
    add c
    ld  b, do_y(ix)
    sub b
    jr z, no_collision
    jp m, no_collision

    ld a, do_y(ix)        ;;hero_x + hero_w - enemy_x <= 0 -> no collision
    ld c, do_h(ix)
    add c
    ld b, e_y(iy)
    sub b
    jr z, no_collision
    jp m, no_collision

    ld a, e_js(iy)        ;;We check if the hero is jumping, he can't enter a door jumping.
    cp #-1
    jr nz, no_collision

    jr collision

    no_collision:
    ld a, #0x00
    and a
    jr escape_func

    collision:
    ld a, #0x01
    or a

    escape_func:

ret

door_copy:
    ld hl, #doorModel
    ld bc, #doorSize
    ldir
ret

resetDoors:
    ld hl, #doorVector
    ld (nextDoor), hl
    ld a, #0
    ld (numDoors), a
    ld hl, #0x0000
    ld (doortoEdit), hl
ret

