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
.include "collectable.h.s"
.include "entity.h.s"
.include "room.h.s"
.include "GUI.h.s"
.include "doubleBuffer.h.s"
.include "AIManager.h.s"
.include "soundManager.h.s"

maxCollectables = 20
numCollectables: .db 0   

collectablesVector:
NCollectables collectablesVector, maxCollectables

nextCollectable: .dw #collectablesVector

collectablesSize = collectablesVector0_size

collectabletoEdit: .dw #0x0000

Collectable collectableModel, 0x30, 0x28, 0x04, 0x010, _key, 0x01, 0x01, 0x00, 0x01, 0x02, 0x00


;;==============================================
;;  CREATE A COLLECTABLE
;;  Creates a collectable and adds it to the vector
;;  DESTROYS -> HL, AF, BX
;;  RETURNS -> HL pointer to the new entity
;;==============================================
create_collectable:
    ld a, (numCollectables)
    cp #maxCollectables
    jr z, endofcreation
    inc a
    ld (numCollectables), a  ;;Increment the number of entities

    ld hl, (nextCollectable) ;;HL points to nextEnemy
    ld bc, #collectablesSize
    add hl, bc               ;;Add the size to HL
    ld (nextCollectable), hl ;;Update nextEnemy value
    or a                     ;;Carry = 0, **Secure measeure for next step**
    sbc hl, bc               ;;Substract bc to hl, in order to retrieve the pointer to the new enemy!!!

    endofcreation:
ret

;;=========================================================================
;;  THIS FUNCTION COULD EXPAND WHEN WE PUT SPRITES AND OTHER STUFF
;;  EDIT COLLECTABLE
;;  Edits a collectable data (Usually used after initialization in vector)
;;  INPUTS -> HL - Pointer to the collectable
;;            B  - X position of the collectable
;;            C  - Y position of the collectable
;;            D  - Room where the collectable has to be drawn
;;=========================================================================
edit_collectable:
    ld (collectabletoEdit), hl 
    ld ix, (collectabletoEdit)
    
    ld a, b        
    ld coll_x(ix), a    ;;Change X value
    ld a, c
    ld coll_y(ix), a    ;;Change Y value
    ld a, d
    ld coll_ro(ix), a   ;;Change the room

ret
;;=========================================================================
;;  THIS FUNCTION COULD EXPAND WHEN WE PUT SPRITES AND OTHER STUFF
;;  DEFINE KEY
;;  Edits a collectable data in order to set a key
;;  INPUTS -> HL - Pointer to the collectable
;;=========================================================================
defineKey:
    ld (collectabletoEdit), hl
    ld ix, (collectabletoEdit)
    ld coll_isk(ix), #0x01
    ;;The key is defined yesss
ret

;;==============================================
;;  RUN FUNC ON COLLECTABLE VECTOR
;;  Runs a function into the enemy vector
;;  INPUT: HL - Pointer to function to execute
;;==============================================
runFunconCollectableVector:
   ld a, (numCollectables)
   cp #0
   jr z, evacuate
   ld ix, #collectablesVector
   ld (method), hl
    loop:
        push af
        method = . + 1
        call collectable_draw
        pop af
        ld bc, #collectablesSize
        add ix, bc
        dec a
    jr nz, loop

    evacuate:

ret


;;==============================================
;;  COLLECTABLE_DRAW
;;  Draws the collectables into the screen
;;  INPUTS -> IX - The collectable to be drawn
;;  DESTROYS -> HL, BC, AF, DE
;;  RETURNS -> None
;;==============================================
collectable_draw:
    ld a, coll_pi(ix)         ;;Check if the collectable is picked
    cp #0
    jr z, no_draw

    call getActualRoom
    ld b, coll_ro(ix)
    cp a, b
    jr nz, no_draw

    call get_back_buffer
    ld     c, coll_x(ix)         ;; C = Entity Y
    ld     b, coll_y(ix)         ;; B = Entity X
    call cpct_getScreenPtr_asm
    
    ex    de, hl   ;; DE = Pointer to memory

    ld a, coll_isk(ix)
    cp #0
    jr z, is_cash

    ld a, coll_hi(ix)  ;;We check if the key is highlighted or not
    cp #1
    jr z, highlight

    ld  l, coll_sp_l(ix)
    ld  h, coll_sp_h(ix)
    jr continue

    highlight:
    ld  hl, #_key_highlight
    jr continue

    is_cash:
    ld a, coll_hi(ix)  ;;We check if the key is highlighted or not
    cp #1
    jr z, cash_highlight

    ld  hl, #_cash
    jr continue

    cash_highlight:
    ld  hl, #_cash_highlight

    continue:
    ld  b, coll_h(ix)   ;; alto
    ld  c, coll_w(ix)   ;; Ancho
    
    call cpct_drawSpriteMasked_asm

    no_draw:

ret

;;==============================================
;;  COLLECTABLE_UPDATE
;;  Updates the collectables 
;;  DESTROYS -> HL, BC, AF, DE
;;  RETURNS -> None
;;==============================================
collectable_update:
    ld iy, #hero                         ;;Loads our "hero" into the iy register
    call collectable_checkForHighlight   ;;Calls the function to highlight the object on the spot
    call collectable_checkPicking        ;;Calls for checking if our object has to be collected
ret

;;==============================================
;;  COLLECTABLE_ERASE
;;  Draws a box with the same color as the background
;;  INPTUS -> IX : Entity to erase
;;  DESTROYS -> AF and whatever is destroyed in collectable_draw
;;  RETURNS -> None
;;==============================================
collectable_erase:
    ld b, coll_y(ix)
    ld c, coll_x(ix)
    
    ld e, coll_w(ix)
    ld d, coll_h(ix)

    call room_draw_part

    ld b, coll_y(ix)
    ld c, coll_x(ix)
    
    ld e, coll_w(ix)
    ld d, coll_h(ix)

    call room_draw_partfb
ret

;;==============================================
;;  COLLECTABLE_CHECKFORHIGLIGHT
;;  Checks for a collision between the object and the player in the X axis and highlight the object in order to 
;;  indicate that it can be picked
;;  INPTUS -> IX : Collectable to be evaluated
;;            IY : Our hero
;;
;;  It will have to severely change when we put sprites on it.....
;;
;;  DESTROYS -> AF, BC
;;  RETURNS -> None
;;==============================================
collectable_checkForHighlight:
    ld  a, e_x(iy)      
    ld  c, e_w(iy)
    add c
    ld  b, coll_x(ix)
    sub b
    jr z, no_collision
    jp m, no_collision

    ld a, coll_x(ix)       
    ld c, coll_w(ix)
    add c
    ld b, e_x(iy)
    sub b
    jr z, no_collision
    jp m, no_collision
    
    ;;There is a collision in X axis

    ;;Check if the player is UNDER the collectable object
    ld  a, e_y(iy)      
    ld  c, e_h(iy)
    add c
    ld  b, coll_y(ix)
    sub b
    jp m, no_collision

    cp #0x20
    jp m, drawit
    jr no_collision

    drawit:

    ld a, coll_pi(ix) ;;Check if the object is already picked
    cp #0
    jr z, end
    
    ld coll_hi(ix), #0x01 ;;Indicate that it is highighted
    jr end
    
    no_collision:
    ld coll_hi(ix), #0x00 ;;Indicate that it isn't highlighted
    
    end:
ret

;;==============================================
;;  COLLECTABLE_CHECKPICKING
;;  Checks if the player presses E and picks up the collectable
;;  INPTUS -> IX : Collectable to be evaluated
;;  DESTROYS -> AF, BC, HL
;;  RETURNS -> None
;;==============================================

collectable_checkPicking:
    call cpct_scanKeyboard_asm
    
    ld hl, #Key_E
    call cpct_isKeyPressed_asm
    jr nz, nextStepPick
    
    ld hl, #Joy0_Fire2
    call cpct_isKeyPressed_asm
    jr z, no_pick
    
    nextStepPick:
    ;;E is pressed now, check first if our character is in the correct room - Patch for no rushing E XD
    call getActualRoom
    ld b, coll_ro(ix)
    cp a, b
    jr nz, no_pick
    
    ;;Now we have to check if the object is highlighted and not picked
    ld a, coll_hi(ix)
    ld b, a
    ld a, coll_pi(ix)
    and b ;; If it is pickable and is highlighted the AND operation will retrieve a nz flag, either if it is not the case, flag Z will be triggered
    jr z, no_pick
    
    ;;I can be picked!!!
    next_picking:
    call collectable_erase ;;Erase the object
    ld coll_pi(ix), #0x00  ;;Unavailable the object
    ld b, coll_p(ix)

    ld a, coll_isk(ix)
    cp #0x01
    jr nz, normal_picking

    call add_keys

    jr nextStep

    normal_picking:

    call addPoints

    nextStep:
    ld a, #2
    call setSFXInstrument
    call AIManager_decrementIntensity
    call AIManager_decrementIntensity   ;;Decrement the Intensity by 2


    no_pick:
ret

;;==============================================
;;  COPY_ENEMY
;;  Creates a enemy and adds it to the vector
;;  INPUTS -> HL - Origin 
;;            DE - Destiny
;;  DESTROYS -> 
;;  RETURNS -> 
;;==============================================
collectable_copy:
    ld hl, #collectableModel
    ld bc, #collectablesSize
    ldir
ret


resetCollectables:

    ld hl, #collectablesVector
    ld (nextCollectable), hl
    ld a, #0
    ld (numCollectables), a
    ld hl, #0x0000
    ld (collectabletoEdit), hl

ret