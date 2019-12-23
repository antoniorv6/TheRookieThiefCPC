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

.include "soundManager.h.s"
.include "cpcteleraFuncs.h.s"

tempo: .db #06
instrument: .db #00

stopMusic:

    call cpct_akp_stop_asm

ret

loadMainMenuMusic:

       ld de, #_main_menu_theme
       call cpct_akp_musicInit_asm

ret

loadIngameMusic:

    ld de, #_ingame_theme
    call cpct_akp_musicInit_asm

ret

;;====================================================================
;;  LOADSOUNDEFFECTS
;;  It loads the whole sound effects package and sets it ready to play
;;====================================================================
loadSoundEffects:

      ld de, #_sound_effects
      call cpct_akp_SFXInit_asm

ret

;;INPUTS - A: Instrument
setSFXInstrument::

    ld (instrument), a

ret
;;====================================================================
;;  PLAYSOUNDEFFECT
;;  It plays a certain sound effect
;;  INPUTS: L - Sound effect to be played
;;====================================================================
playSoundEffect:
    
    ld a, (instrument)
    cp #0
    jr z, no_play

    ld l, a
    ld h, #15 ;;Volume of the sound effect
    ld e, #100 ;;Note to be played - CO is 0
    ld d, #0  ;;Speed as original sound
    ld bc, #0x0000 ;;I think this mustn't be touched
    ld a, #0b00000100 ;;Play on channel 3

    call cpct_akp_SFXPlay_asm

    ld a, #0
    ld (instrument), a

    no_play:

ret


;;=============================================================
;;  INTERRUPTION HANDLER
;;  It plays the music as it must be with no problems of tempo
;;=============================================================
playMusic:
    ex af, af'
    exx
    push af
    push bc
    push de
    push hl
    push iy

    ld a, (tempo)
    dec a
    ld (tempo), a
    jr nz, return

    call cpct_akp_musicPlay_asm
    call playSoundEffect
    
    ld a, #06
    ld (tempo), a

    return:

    pop iy
    pop hl
    pop de
    pop bc
    pop af
    exx
    ex af, af'

ret

