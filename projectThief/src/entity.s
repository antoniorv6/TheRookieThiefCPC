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

;;
;; Start of _DATA area 
;;  SDCC requires at least _DATA and _CODE areas to be declared, but you may use
;;  any one of them for any purpose. Usually, compiler puts _DATA area contents
;;  right after _CODE area contents.
;;
.area _DATA

.include "doubleBuffer.h.s"
.include "cpcteleraFuncs.h.s"
.include "entity.h.s"
.include "room.h.s"
.include "enemy.h.s"
.include "animationManager.h.s"
.include "inputManager.h.s"
.include "soundManager.h.s"

.area _CODE
;; 
;; Declare all function entry points as global symbols for the compiler.
;; (The linker will know what to do with them)
;; WARNING: Every global symbol declared will be linked, so DO NOT declare 
;; symbols for functions you do not use.
;;
;;.include "cpctelera.h.s"

;;Jump table
jumptable:         
    .db #-5, #-4, #-3, #-2
    .db #-1, #00, #00, #01
    .db #02, #03, #04, #05
    .db #0x80

Entity hero, 0x19, 0x40, 0x00, 0x00, 0xFF , 0x04, 0x20, _idle_0, entity_move_keyboard, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x03, 0x00, 0x0A, 0x00, 0x00, 0x00

Entity enemymodel, 0x25, 0x65, 0xFF, 0x00, 0xFF , 0x04, 0x20, _enemy_idle_0, enemy_update, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

;;Change entity_move for entity_IA when we implement enemy.s which is going to be controlled by an AI
hero_attackTimer: .db #0
hero_blockTimer: .db #0

maxEnemies = 10
enemyVector:
NEntities enemyVector, maxEnemies

entitySize = enemyVector0_size

;;Function to always draw the hero's position
updateRoom:
    call getActualRoom
    ld e_room(ix), a
ret
;;==============================================
;;  GET_ENEMY_VECTOR
;;  Get the memory address of the enemy vector
;;  DESTROYS -> HL
;;  RETURNS -> HL - Pointer to the enemy vector
;;==============================================
getEnemyVector:
    ld hl, #enemyVector
ret

;;==============================================
;;  GET_ENTITY_SIZE
;;  Get the size of an entity
;;  DESTROYS -> BC
;;  RETURNS -> BC - Size of the entity
;;==============================================
getEntitySize:
    ld bc, #entitySize
ret

;;==============================================
;;  PUBLIC METHODS
;;==============================================

;;==============================================
;;  UPDATE METHOD
;;  Calls entity update method
;;  INPTUS -> IX : Entity to update
;;  DESTROYS -> HL
;;  RETURNS -> None
;;==============================================
entity_update:
    call jump_control
    call check_attacking
    call check_blocking
    ld h, e_updh(ix)
    ld l, e_updl(ix)
    jp (hl)


;;==============================================
;;  CHECK_ATTACKING
;;  Checks if the entity is attacking and if timer is 0, then it resets it
;;  INPTUS -> IX : Entity to check
;;  DESTROYS -> AF
;;  RETURNS -> None
;;==============================================
check_attacking:
    ld a, e_att(ix) ;;Charge in A hero attacking status
    cp #0
    jr z, no_attacking ;;Is the hero attacking?

    ld a, (hero_attackTimer) ;;Charge in A the attack timeout
    cp #0
    jr nz, no_acting    ;;Timer is 0?

    ;ld e_spr(ix), #0xFE ;;Restore the original color (For now)
    ld e_att(ix), #0x00 ;;He is no attacking now
    
    ret                 ;;Out of the function
    
    no_acting:
         dec a               ;;Decrement the timer
         ld (hero_attackTimer), a    ;;Get the timer to 0
    
    no_attacking:       ;;No attacking, exit

ret

check_blocking:

    ld a, e_block(ix) ;;Charge in A hero attacking status
    cp #0
    jr z, no_blocking ;;Is the hero attacking?

    ld a, (hero_blockTimer)
    cp #0
    jr nz, no_change

;    ld e_spr(ix), #0xFE   
    ld e_block(ix), #0x00

    ret

    no_change:
        dec a
        ld (hero_blockTimer), a

    no_blocking:

ret

;;==============================================
;;  DRAW ENTITY
;;  Draws an solid box in a certain screen position
;;  INPTUS -> IX : Entity to check
;;  DESTROYS -> HL, DE, BC
;;  RETURNS -> None
;;==============================================
entity_draw:

    ld a, e_aliv(ix)
    cp #0
    jr z, no_draw ;;If not alive, die

    ld b, e_room(ix)   ;;Charge the room
    call getActualRoom ;;Load in a the room
    sub b              ;;Substract if the room is correct
    jr nz, no_draw


    call get_back_buffer
    ld     c, e_x(ix)         ;; C = Entity Y
    ld     b, e_y(ix)         ;; B = Entity X
    call cpct_getScreenPtr_asm
    
    ex    de, hl      ;; DE = Pointer to memory
    ld l, e_spr_l(ix)
    ld h, e_spr_h(ix)
    ld  b, e_h(ix)    ;; alto
    ld  c, e_w(ix)    ;; Ancho
    
    call draw_animation

    call storeCoordinatesToEraseBuffer

    no_draw:

ret

;;==============================================
;;  ERASE ENTITY
;;  Draws a box with the same color as the background
;;  INPTUS -> IX : Entity to check
;;  DESTROYS -> AF
;;  RETURNS -> None
;;==============================================
entity_erase:
    
    call getCoordinatesToEraseBuffer
    
    ld e, e_w(ix)
    ld d, e_h(ix)

    call room_draw_part
ret

;;==============================================
;;  MOVE ENTITY WITH KEYBOARD
;;  Searches for keyboard inputs and acts in consequence
;;  INPTUS -> IX : Entity to check
;;  DESTROYS -> HL, AF
;;  RETURNS -> None
;;==============================================
entity_move_right:

    ld e_vx(ix), #2
    ld e_dir(ix), #0x00

ret

entity_move_left:

    ld e_vx(ix), #-2
    ld e_dir(ix), #0x01


ret

punch:

    ld a, e_att(ix)
    cp #0
    jr nz, exit ;;Is the entity attacking

    ld e_att(ix), #1         ;;He is not attacking, now he attacks
    ld a, #10
    ld (hero_attackTimer), a    ;;Add ten cycles to the attack

    ld a, #3
    call setSFXInstrument

ret

block:

    ld a, e_block(ix)
        cp #0
        jr nz, exit
        
        ld a, e_blocksLeft(ix)
        cp #0
        jr z, noblock ;;He can't block anymore

        ld e_block(ix), #0x01
        ld a, #10
        ld (hero_blockTimer), a
        ;ld e_spr(ix), #0x10
    noblock:
ret

checkBoundaries:

    ld a, #80-6 ;;Check screen borders
    ld b, e_x(ix)
    sub b
    jr z, change_right
    jp m, change_right

    ld a, e_x(ix) ;;Check screen borders
    cp #2
    jr z, change_left
    jp m, change_left

    ret

    change_right:
        ld a, #2
        ld c, a
        call change_room
        jr z, exit
        ld e_x(ix), #7
        ret

    change_left:
        ld a, #-2
        ld c, a
        call change_room
        jr z, exit
        ld e_x(ix), #80-7
        ret
    
    exit:

ret

entity_move_keyboard:

    ld e_vx(ix), #0x00
    ld e_vy(ix), #0x00
    call cpct_scanKeyboard_asm
    call processInputs
    call checkBoundaries

jp entity_move



;;==============================================
;;  MOVE ENTITY
;;  Moves the entity on x and y axis
;;  INPTUS -> IX : Entity to check
;;  DESTROYS -> A, HL
;;  RETURNS -> None
;;==============================================
entity_move:

   call checkoffLimits
   jr z, stop
   
   ld    a, e_x(ix)
   ld    d, a
   add   e_vx(ix)
   ld    e_x(ix), a

   stop:
   ld    a, e_y(ix)
   ld    e, a
   add   e_vy(ix)
   ld    e_y(ix), a

   
   
ret

checkoffLimits:
    ld a, e_vx(ix)
    cp #2
    jr z, positive_check

    ld a, e_x(ix)
    cp #2
    jr z, no_move
    jp m, no_move

    ret

    positive_check:
    ld a, e_x(ix)
    cp #80-6
    jp m, endfunc

    no_move:
    ld a, #0
    and a
    
    endfunc:
ret

;;==============================================
;;  JUMP CONTROL
;;  Jumps as high as is defined in the JumpTable
;;  INPTUS -> IX : Entity to check
;;  DESTROYS -> HL, DE, BC
;;  RETURNS -> None
;;==============================================
jump_control:               ;;Space pressed
    ld a, e_js(ix)     ;;A = Hero_jump status
 	cp #-1			        ;;A=-1? If it's not, is jumping
 	ret z			        ;;ret if it's not jumping

 	;; Get the jump value from jumptable
 	ld	hl, #jumptable      ;;HL -> Pointer to the first position of the array
 	ld	 c, a		        ;;|
 	ld	 b, #00		        ;;| BC = A(Offset)  
 	add hl, bc		        ;; HL += BC

 	;;Check End of jumping
 	ld a, (hl)
 	cp #0x80
 	jr z, end_of_jump
	
	
 	;; Jump
 	ld	b, a		        ;;B = Jump value
 	ld	a, e_y(ix)          ;;A = Hero_y
 	add b

 	ld e_y(ix), a 	        ;;We put the jump value

 	;;Increment jump state index
	
 	ld	a, e_js(ix)	    ;;| A= hero_jump
 	cp  #0x80
 	jr  nz, continue_jump

 		;;Ending the jump
         ld a, #-2 

 	continue_jump:	
 	inc a				;;| 
 	ld e_js(ix), a	;;|

 	ret

 	;; Put -1 in the jump index when jump ends
 	end_of_jump:
 		ld a, #-1		
 		ld e_js(ix), a	;; Hero_jump = -1
 	ret
;;==============================================
;;  START JUMP
;;  Ckecks the jump status so it can jump or not
;;  INPTUS -> IX : Entity to check
;;  DESTROYS -> A
;;  RETURNS -> None
;;==============================================
start_jump:
    ld a, e_js(ix)
 	cp #-1				;;We check if the jump state is active -> (-1--1 = 0)
	ret nz	            ;;We don't jump if the result is not 0

    ld 	a, #0
 	ld	e_js(ix), a

    ld a, #1
    call setSFXInstrument
	
 ret

 ;;==============================================
;;  KILL ENTITY
;;  Edits entity's update function pointer to
;;  do_nothing so the entity is not updated anymore.
;;
;;  Edits its color as background's color so it
;;  doesn't appear on the screen anymore.
;;
;;  INPTUS -> IX : Entity to check
;;  DESTROYS -> A
;;  RETURNS -> None
;;==============================================
kill_entity:
    ld e_aliv(ix), #0  ;;Entity dies
    call entity_erase
ret

do_nothing:

ret

reset_hero:
    ld ix, #hero
    ld e_x(ix),     #0x19
    ld e_y(ix),     #0x65
    ld e_vx(ix),    #0x00
    ld e_vy(ix),    #0x00
    ld e_aliv(ix),  #0x01
;    ld e_spr(ix),   #0x01
ret


storeCoordinatesToEraseBuffer:

    call get_back_buffer
    ld a, d
    cp #0xC0
    jr nz, storein80

    ld a, e_x(ix)
    ld e_xC0(ix), a
    ld a, e_y(ix)
    ld e_yC0(ix), a

    jr outofFunc

    storein80:

    ld a, e_x(ix)
    ld e_x80(ix), a
    ld a, e_y(ix)
    ld e_y80(ix), a

    outofFunc:

ret

getCoordinatesToEraseBuffer:

    call get_back_buffer
    ld a, d
    cp #0xC0
    jr nz, getin80

    ld b, e_yC0(ix)
    ld c, e_xC0(ix)

    jr outofFunc1

    getin80:

    ld b, e_y80(ix)
    ld c, e_x80(ix)

    outofFunc1:

ret

;;Returns in D the room where our hero is located
getPlayerRoom:
    ld iy, #hero
    ld d, e_room(iy)
ret
