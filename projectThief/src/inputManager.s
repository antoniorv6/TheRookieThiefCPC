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

.include "cpcteleraFuncs.h.s"
.include "entity.h.s"
.include "inputManager.h.s"

keyboardBinds:
    .dw #Key_P, #entity_move_right
    .dw #Key_O, #entity_move_left
    .dw #Joy0_Right, #entity_move_right
    .dw #Joy0_Left, #entity_move_left
    .dw #Key_Q, #start_jump
    .dw #Joy0_Up, #start_jump
    .dw #Key_Space, #punch
    .dw #Joy0_Fire1, #punch
    .dw #Key_A, #block
    .dw #Joy0_Down, #block
    .dw #0xFFFF

processInputs:

    ld iy, #keyboardBinds

    call cpct_scanKeyboard_asm

    inputRoutine:

        ld h, 1(iy)
        ld l, (iy)                        ;;Load the key into HL

        ld a, h
        cp #0xFF                          ;;Check if we have reached the end of the array
        jr nz, continue                   

        ld a, l
        cp #0xFF
        jr z, end                         ;;We get to the end of our array

        continue:
            call cpct_isKeyPressed_asm  ;;Check if the key is pressed
            jr nz, key_pressed
            
            inc iy
            inc iy
            inc iy
            inc iy                      ;;Jump 4 positions in order to get to the next key
        
        jr inputRoutine

        key_pressed:

            inc iy                          
            inc iy                      ;;We get to the function
            ld h, 1(iy)
            ld l, (iy)                     ;;We retrieve the function in HL

            call callfunction                    ;;Call the function

            inc iy                      ;;Once called, we get to the next key
            inc iy
        
    jr inputRoutine

    end:
        

ret

callfunction:
jp (hl)