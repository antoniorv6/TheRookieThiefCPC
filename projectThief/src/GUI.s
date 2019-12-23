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

.include "cpcteleraFuncs.h.s"
.include "GUI.h.s"
.include "doubleBuffer.h.s"
.include "collectable.h.s"

string: .asciz "Cash:"
numberOfKeys: .db #0x00
pointsUnits: .db #0x00
pointsUnitsCH: .db #0x00
pointsDecensCH: .db #0x00
pointsDecens: .db #0x00
x: .db #25
y: .db #100
counterKeys: .db 0x00
keysX: .db #50
keysY: .db #150

startGUI:
    ;; Set up draw char colours before calling draw string
    ld    h, #0         ;; D = Background PEN (0)
    ld    l, #3         ;; E = Foreground PEN (3)
    call cpct_setDrawCharM0_asm   ;; Set draw char colours
ret

num_to_char:

    ld a, (pointsUnits)
    add #48
    ld (pointsUnitsCH), a

    ld a, (pointsDecens)
    add #48
    ld (pointsDecensCH), a

ret

draw_Punctuation:

    call num_to_char 

    call get_back_buffer
    ld    b, #150                  ;; B = y coordinate (24 = 0x18)
    ld    c, #05                  ;; C = x coordinate (16 = 0x10)

    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ld iy, #string
    call cpct_drawStringM0_asm  

    call get_front_buffer
    ld    b, #150                  ;; B = y coordinate (24 = 0x18)
    ld    c, #05                  ;; C = x coordinate (16 = 0x10)

    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL 

    ld iy, #string
    call cpct_drawStringM0_asm

    call get_back_buffer
    ld b, #150
    ld c, #32
    call cpct_getScreenPtr_asm

    ld a, (pointsUnitsCH)
    ld e, a
    call cpct_drawCharM0_asm

    call get_front_buffer
    ld b, #150
    ld c, #32
    call cpct_getScreenPtr_asm

    ld a, (pointsUnitsCH)
    ld e, a
    call cpct_drawCharM0_asm



    call get_back_buffer
    ld b, #150
    ld c, #26
    call cpct_getScreenPtr_asm

    ld a, (pointsDecensCH)
    ld e, a
    call cpct_drawCharM0_asm

    call get_front_buffer
    ld b, #150
    ld c, #26
    call cpct_getScreenPtr_asm

    ld a, (pointsDecensCH)
    ld e, a
    call cpct_drawCharM0_asm

    call draw_keys  

ret

addPoints:
    ld a, (pointsUnits)
    inc a            ;;A has now the result of the adding
    ld b, a             ;;We exchange
    ld a, #10

    cp b ;; 10 - b
    jr z, changeUnits
    jp m, changeUnits
    
    ld a, b
    ld (pointsUnits), a

    call draw_Punctuation

    ret

    changeUnits:        ;;B > 10
    ld a, (pointsDecens)
    inc a
    ld (pointsDecens), a

    ld a, b
    sub #10
    ld (pointsUnits), a

    call draw_Punctuation

ret

getPunctuation:
    ld hl, (pointsUnitsCH)
    ld de, (pointsDecensCH)
ret

resetPunctuation:
    ld a, #0
    ld (numberOfKeys), a
    ld (pointsUnits), a
    ld (pointsDecens), a

ret

add_keys:
    ld a, (numberOfKeys)
    inc a
    ld (numberOfKeys), a
    call draw_keys
ret

erase_keys:
    ld a, (numberOfKeys)
    dec a
    ld (numberOfKeys), a
    call draw_keys
ret

;; FUNCTION TO DRAW THE KEYS, NEEDS TO BE OPTIMIZED

draw_keys:


call get_back_buffer

    call get_back_buffer
    ld     a, (keysX) 
    ld     c, a               ;; C = Entity Y
    ld     a, (keysY)         ;; B = Entity X
    ld     b, a
    call cpct_getScreenPtr_asm
    
    ex    de, hl   ;; DE = Pointer to memory
    ld  a, #0x00   ;; Color
    ld  b, #0x10   ;; alto
    ld  c, #0x16   ;; Ancho

    call cpct_drawSolidBox_asm

    call get_front_buffer
    ld     a, (keysX) 
    ld     c, a               ;; C = Entity Y
    ld     a, (keysY)         ;; B = Entity X
    ld     b, a
    call cpct_getScreenPtr_asm
    
    ex    de, hl   ;; DE = Pointer to memory
    ld  a, #0x00   ;; Color
    ld  b, #0x10   ;; alto
    ld  c, #0x16   ;; Ancho

    call cpct_drawSolidBox_asm

ld a, (numberOfKeys)
ld (counterKeys), a ;;Store in counter keys the quantity of keys we have

cp #0
jr nz, key_drawLoop ;;If there are keys, we get to business

ret

key_drawLoop:

    call get_back_buffer
    ld     a, (keysX) 
    ld     c, a               ;; C = Entity Y
    ld     a, (keysY)         ;; B = Entity X
    ld     b, a               ;; B = Entity X
    call cpct_getScreenPtr_asm
    
    ex    de, hl   ;; DE = Pointer to memory
    ld  hl, #_key
    ld  b, #0x10   ;; Alto
    ld  c, #0x04   ;; Ancho
    
    call cpct_drawSpriteMasked_asm

    call get_front_buffer
    ld     a, (keysX) 
    ld     c, a               ;; C = Entity Y
    ld     a, (keysY)         ;; B = Entity X
    ld     b, a               ;; B = Entity X
    call cpct_getScreenPtr_asm
    
    ex    de, hl   ;; DE = Pointer to memory
    ld hl, #_key
    ld  b, #0x10   ;; Alto
    ld  c, #0x04   ;; Ancho
    
    call cpct_drawSpriteMasked_asm

    ld a, (keysX)
    ld b, #0x04
    add b
    ld (keysX), a

    ld a, (counterKeys)
    dec a
    ld (counterKeys), a
    jr nz, key_drawLoop

    ld a, #50
    ld (keysX), a

ret

;;Will return 0 if there aren't keys and will return anything else if there is a key
hasKeys:

    ld a, (numberOfKeys)
    cp #0

ret