;;-----------------------------LICENSE NOTICE------------------------------------
; The Rookie Thief is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.

;     This program is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.

;     You should have received a copy of the GNU General Public License
;     along with this program.  If not, see <https://www.gnu.org/licenses/>.
;;-------------------------------------------------------------------------------

.include "cpcteleraFuncs.h.s"
.include "entity.h.s"
.include "enemy.h.s"
.include "collectable.h.s"
.include "room.h.s"
.include "door.h.s"
.include "GUI.h.s"
.include "gameOverScreen.h.s"
.include "doubleBuffer.h.s"
.include "initializer.h.s"
.include "main.h.s"
.include "AIManager.h.s"
.include "soundManager.h.s"

game_mode: .db #0
escape: .db #0
title:  .asciz "THE ROOKIE THIEF"
string: .asciz "Press X to start"

frames: .db #6

;;Enables our thief to escape the room
escape_building:
    ld a, #1
    ld (escape), a
ret

set_graphic_env:
	
    call cpct_disableFirmware_asm ;;Unable firmware to stablish mode 0 of video
	
    ld c, #0
	call cpct_setVideoMode_asm

	ld hl, #_tileset_palette
	ld de, #16
	call cpct_setPalette_asm

    ld l, #0x10
    ld h, #0x14
    call cpct_setPALColour_asm ;;Set the border color to black

    call startGUI

ret

;;
;; MAIN function. This is the entry point of the application.
;;    _main:: global symbol is required for correctly compiling and linking
;;
_main::

    ld sp, #0x8000

    call cpct_disableFirmware_asm
        
    call set_graphic_env

    ld hl, #isr
    call cpct_setInterruptHandler_asm

    ld a, (game_mode)
    cp #0
    jp z, menu
    
    game:
        ld a, #1
        ld (game_mode), a

        call AIManager_init

        call initEnemyEnvironment

        call init_hero

        call clearbackBuffer

        call initTilesetObjects

        call initDoors

        call init_levels

        call room_draw
        
        call initEnemies

        call draw_Punctuation

        call stopMusic

        call loadIngameMusic
        call loadSoundEffects


    gameLoop:

       ld ix, #hero
       call  updateRoom
        
       call entity_erase
       ld hl, #entity_erase
       call runFunconEnemyVector

       ld ix, #hero
       call entity_update
       ld iy, #hero
       ld hl, #entity_update
       call runFunconEnemyVector
       ld ix, #hero
       call entity_draw  
       ld hl, #entity_draw
       call runFunconEnemyVector

       ld hl, #door_update
       call runFunconDoorVector
       ld hl, #door_draw
       call runFunconDoorVector
       
       ld hl, #collectable_update
       call runFunconCollectableVector
       ld hl, #collectable_draw
       call runFunconCollectableVector
;;
       ld a, (escape)
       cp #1
       jp z, endgame
;;
       call AIManager_update

        nofx:
       
       call waitIsr
       call cpct_waitVSYNC_asm

       call switch_buffer

    
    jr gameLoop


menu:

       call blockC0Buffer
        ;; Set up draw char colours before calling draw string
       call loadMainMenuMusic

       ld    h, #0         ;; D = Background PEN (0)
       ld    l, #5         ;; E = Foreground PEN (3)
       call cpct_setDrawCharM0_asm   ;; Set draw char colours
          
       ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
       ld    b, #75                  ;; B = y coordinate (24 = 0x18)
       ld    c, #8                   ;; C = x coordinate (16 = 0x10)
       call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL
      
       ld   iy, #string   
       call cpct_drawStringM0_asm ;; Draw the string
      
       ld de, #CPCT_VMEM_START_ASM
       ld b, #30
       ld c, #4
       call cpct_getScreenPtr_asm
       
       ld iy, #title
       call cpct_drawStringM0_asm

       call resetPunctuation

    menu_loop:
        call cpct_scanKeyboard_asm

        ld hl, #Key_X
        call cpct_isKeyPressed_asm
        jr nz, gotogame

        call cpct_waitVSYNC_asm

    jr menu_loop

    gotogame:
        jp game

    endgame:

        call blockC0Buffer

        call resetDoors        ;;Clear door vector
        call resetCollectables ;;Clear collectables
        call resetEnemies      ;;Clear enemy vector this time
        call endscreen
        call reset_hero        ;;Reset our hero properties

        ld a, #0
        ld (game_mode), a
        ld (escape), a

    gameOver_loop:
            call cpct_scanKeyboard_asm

            ld hl, #Key_X
            call cpct_isKeyPressed_asm
            jp nz, _main
            
            call cpct_waitVSYNC_asm

    jr gameOver_loop


isr::
    ld a, (frames)
    cp #0
    jr z, reset
    dec a
    ld (frames), a
    call playMusic
    ret

    reset:
    ld a, #12
    ld (frames), a
    call playMusic
    
ret

waitIsr::

    wait_loop:
    ld a, (frames)
    cp #0
    ret z

    jr wait_loop

ret