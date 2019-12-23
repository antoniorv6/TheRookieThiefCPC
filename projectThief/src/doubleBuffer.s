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
.include "doubleBuffer.h.s"
.include "room.h.s"

m_frontBuffer: .db #0xC0
m_backBuffer:  .db #0x80

;;==================================================================
;;  CLEARBACKBUFFER
;;  Cleans the back buffer (0x8000)
;;  INPUTS: None
;;  DESTROYS: AF, HL, DE
;;  RETURN: DE -> Pointer to the first back buffer memory pointer
;;==================================================================
clearbackBuffer:
    ld a, (m_backBuffer) ;;A gets the value of the first byte of the back buffer
    ld h, a              ;;H = A
    ld de, #0x0000       ;;Load into DE the value that we want to put into our buffer (0 in this case) 
    ld l, e              ;;Charge E value to L, because it makes the coincidence to be 0
    ld bc, #0x4000       ;;Carge in BC the ammount of memory that we are going to clean
    call _cpct_memset_f64_asm
ret

;;==================================================================
;;  GET BACK BUFFER
;;  Charges into DE the back buffer memory pointer
;;  INPUTS: None
;;  DESTROYS: DE, AF
;;  RETURN: DE -> Pointer to the first back buffer memory pointer
;;==================================================================
get_back_buffer:
    ld a, (m_backBuffer) ;;A gets the value of the first byte of the back buffer
    ld d, a              ;;D = A
    ld e, #0             ;;E = 0 (As it is C000 and 8000)
ret

;;==================================================================
;;  GET FRONT BUFFER
;;  Charges into DE the front buffer memory pointer
;;  INPUTS: None
;;  DESTROYS: DE, AF
;;  RETURN: DE -> Pointer to the first front buffer memory pointer
;;==================================================================
get_front_buffer:
    ld a, (m_frontBuffer)
    ld d, a
    ld e, #0
ret

;;=======================================================
;;  SWITCH BUFFERS
;;  Changes the video memory pointer to the back buffer
;;  INPUTS: None
;;  DESTROYS: AF, BC
;;=======================================================
switch_buffer:
    ld a, (m_backBuffer)            ;;A -> First byte of the back buffer
    ld b, a                         ;;Load into B the value of A
    ld a, (m_frontBuffer)           ;;A -> First byte of the front buffer
    ld (m_backBuffer), a            ;;Update the back buffer value with the front buffer stored before
    ld a, b                         ;;Get the back buffer value from our auxiliar register B
    ld (m_frontBuffer), a           ;;Update the front buffer with the pointer to the back buffer

    srl b                           ;;Divide B by 4 to get the six first singifactive bits of our buffer
    srl b

    ld l, b                         ;; L -> B
    jp cpct_setVideoMemoryPage_asm  ;;CPCtelera function to change the video memory pointer value


;;====================================================================================
;;  BLOCK C0 BUFFER
;;  Optimization for the menus, we block the C0 buffer and clean it to display things
;;  INPUTS: None
;;  DESTROYS: AF
;;====================================================================================
blockC0Buffer:
    ld a, #0xC0
    ld (m_backBuffer), a
    ld a, #0x80
    ld (m_frontBuffer), a

    call clearbackBuffer
    call switch_buffer

ret
