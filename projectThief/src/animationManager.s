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

    .include "cpcteleraFuncs.h.s"
    .include "animationManager.h.s"
    .include "entity.h.s"
    .include "doubleBuffer.h.s"
    .include "frame.h.s"

.area _CODE
;; 
;; Declare all function entry points as global symbols for the compiler.
;; (The linker will know what to do with them)
;; WARNING: Every global symbol declared will be linked, so DO NOT declare 
;; symbols for functions you do not use.
;;

sprite_first: .dw #0x0000
actual_frame: .db #0
frameProcessing: .dw #0x0000

;;==============================================
;;  SET ANIMATION
;;  Decides what type of animation hero has
;;  to do checking his status value
;;  DESTROYS -> 
;;  RETURNS -> NONE
;;==============================================
draw_animation:

    call pick_animation
    call get_frame
    call draw_frame

ret

pick_animation:

    ld a, e_fr(ix)     ;;We check in which frame is the entity
    cp #0
    jr nz, outoffunc   ;;If the frame isn't the first one, we get him out

    ld a, e_type(ix)
    cp #0
    jr z, enemy_animations
    cp #1
    jr z, enemy_animations

    call hero_frames_picking
    jr transfer

    enemy_animations:
    call enemy_frames_picking
    
    transfer:
    ld e_spr_l(ix), h
    ld e_spr_h(ix), l  ;;Now we've got the animation we want stored in our entity

    outoffunc:
ret

get_frame:

    ;;IY now has the pointer to the first animation "frame"
    ld a, e_fr(ix)

    ld h, e_spr_l(ix)
    ld l, e_spr_h(ix)   

    push hl
    pop iy             ;;Now iy has the pointer to the pointer to the pointer of the sprite

    ld c, a
    ld b, #0x00

    add iy, bc

    ld h, 1(iy)
    ld l, 0(iy)       ;;HL has the pointer to the pointer of the sprite

    push hl
    pop iy

    ld h, f_sp_h(iy)
    ld l, f_sp_l(iy)     ;;Now I think HL has the pointer to the sprite

    inc a
    inc a

    ld b, e_total(ix)
    
    cp b
    jr nz, endframepick
    ld a, #0

    endframepick:
    ld e_fr(ix), a


ret

draw_frame:

    ld (frameProcessing), hl ;;I store HL in auxiliar because it could be destroyed

    call checkFlip

    call get_back_buffer
    ld     c, e_x(ix)         ;; C = Entity Y
    ld     b, e_y(ix)         ;; B = Entity X
    call cpct_getScreenPtr_asm
    
    ex    de, hl      ;; DE = Pointer to memory

    ld  b, e_h(ix)    ;; alto
    ld  c, e_w(ix)    ;; Ancho
    ld hl, (frameProcessing)

    call cpct_drawSpriteMasked_asm

ret

checkFlip:

    ld h, e_spr_l(ix)
    ld l, e_spr_h(ix)   

    push hl
    pop iy             ;;Now iy has the pointer to the pointer to the pointer of the sprite

    ld c, a
    ld b, #0x00

    add iy, bc

    ld h, 1(iy)
    ld l, 0(iy)       ;;HL has the pointer to the pointer of the sprite

    push hl
    pop iy

    ld a, f_dir(iy)
    ld b, a
    ld a, e_dir(ix)
    xor b
    jr z, no_flip

    ;;We have to flip the frame
    ld  b, e_h(ix)    ;; alto
    ld  c, e_w(ix)    ;; Ancho

    ld hl, (frameProcessing)

    call cpct_hflipSpriteMaskedM0_asm

    ld a, e_dir(ix)
    ld f_dir(iy), a


    no_flip:


ret


hero_frames_picking:
    
    ld a, e_js(ix)
    cp #-1
    jr nz, jump_animation

    ld a, e_block(ix)
    cp #0
    jr nz, block_animation

    ld a, e_att(ix)
    cp #0
    jr nz, punch_animation

    ld a, e_vx(ix)
    cp #0
    jr nz, run_animation

    jr idle_animation
    
    run_animation:
    ld hl, #hero_run
    ld e_total(ix), #6
    jr exit

    punch_animation:
    ld hl, #hero_punch
    ld e_total(ix), #18
    jr exit

    jump_animation:
    ld hl, #hero_jump
    ld e_total(ix), #4
    jr exit

    block_animation:
    ld hl, #hero_block
    ld e_total(ix), #10
    jr exit

    idle_animation:
    ld hl, #hero_idle  ;;This is just a test, we pick the idle animation, we point towards the first frame
    ld e_total(ix), #12

    exit:
ret

enemy_frames_picking:

    ld a, e_att(ix)
    cp #1
    jr z, enemy_attack_animation

    ld a, e_vx(ix)
    cp #0
    jr nz, enemy_run_animation

    ld hl, #enemy_idle
    ld e_total(ix), #4
    jr exitf

    enemy_attack_animation:
    ld hl, #enemy_attack
    ld e_total(ix), #4
    jr exitf

    enemy_run_animation:
    ld hl, #enemy_run
    ld e_total(ix), #4



    exitf:
ret



