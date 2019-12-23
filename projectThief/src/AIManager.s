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
;;AI Manager, where all the AI magic is supposed to happen

.include "entity.h.s"        ;;Needed for our hero data
.include "enemy.h.s"         ;;Needed for our enemy data
.include "doubleBuffer.h.s"  ;;Debug purposes
.include "AIManager.h.s"

intensity:          .db #0x00    ;;Intensity of the player, measures the level of action that is being over the game
genericTimer:       .db #100     ;;Time that the sustain intensity lasts
enemySpawnTimer:    .db #100     ;;I need it specially now, evaluate if there is another way to not confuse the personelle
sustainIterations:  .db #0x05
relaxIterations:    .db #0x03

state: .db #0x00            ;;State where the AI Manager is working:
                            ;; 00 - Build
                            ;; 01 - Sustain
                            ;; 02 - Fade
                            ;; 03 - Relax 

AIManager_init:
    ld a, #0x00
    ld (intensity), a
    ld (state), a
    ld a, #100
    ld (genericTimer), a
    ld (enemySpawnTimer), a
    ld a, #0x05
    ld (sustainIterations), a
    ld a, #0x03
    ld (relaxIterations), a
ret

;;=========================================
;;  AIMANAGER_UPDATE
;;  Updates the enemies environment depending on the state that we are now
;;  INPUTS: None
;;  DESTROYS: AF
;;  RETURNS: None
;;=========================================

AIManager_update:

    ld a, (state) ;;A -> Intensity of the player
    cp #0
    jr z, build_state 
    cp #1
    jp z, sustain_state
    cp #2
    jp z, fade_state
    jp relax_state 

ret ;;Safe escape for not corrupting the pile if there is any error or something

;;============================================================================
;;  AIMANAGER_INCREMENTINTENSITY
;;  Increments the intensity of the player (it is activated by other entities)
;;  INPUTS: None
;;  DESTROYS: AF
;;  RETURNS: None
;;============================================================================

AIManager_incrementIntensity:
    ld a, (intensity)
    inc a
    ld (intensity), a
ret

;;============================================================================
;;  AIMANAGER_DECREMENT
;;  Decrements the intensity of the player (it is activated by other entities)
;;  INPUTS: None
;;  DESTROYS: AF
;;  RETURNS: None
;;============================================================================

AIManager_decrementIntensity:
    ld a, (intensity)
    dec a
    ld (intensity), a
ret

;;============================================================================
;;  BUILD_STATE
;;  It's function is to spawn two enemies by iteration, in order to dramatically increment
;;  player's intensity. When it reaches the intensity peak, it goes to the next state
;;  
;;  INTPUS: None
;;  DESTROYS: AF, and what respawnEnemiesBuild destroys (DE and HL are for debug purposes)
;;============================================================================
build_state:
    
    ld a, (genericTimer)
    dec a
    ld (genericTimer), a
    jr nz, noRespawn

    ld b, #0
    call respawnEnemy           ;;  We call a function where we respawn two enemies (Pend to finish implementation)
    ld b, #1
    call respawnEnemy
    ld a, #100
    ld (genericTimer), a

    noRespawn:

    ld a, (intensity)           ;;|
    ld b, a                     ;;| Load into B the intensity of the player
    ld a, #100                  
    cp b                        ;;  100 is the maximum intensity peak for the player to be 
    jr z, change_sustain        ;;|
    jp m, change_sustain        ;;| If we get into that limit, then we have to change to the sustain state
    ret         
    
    change_sustain:
        ld a, #0x01             ;;|
        ld (state), a           ;;| Just changing the state here, nothing special
        ld a, #200
        ld (genericTimer), a

ret

;;============================================================================
;;  SUSTAIN_STATE
;;  It just tries to keep that intensity peak more or less for a period of time
;;  it will check the intensity to spawn enemies or it will pass till it gets a little bit lower
;;  
;;  INTPUS: None
;;  DESTROYS: AF (DE and HL are for debug purposes)
;;============================================================================
sustain_state:

    ;;Same as buildup but with more time of delay
    ld a, (enemySpawnTimer)
    dec a
    ld (enemySpawnTimer), a
    jr nz, noRespawnSust

    ld b, #0x00
    call respawnEnemy           ;;Spawns only in the left
    ld b, #0x01
    call respawnEnemy

    ld a, #150
    ld (enemySpawnTimer), a     ;;reset our timer 


    noRespawnSust:

    ld a, (genericTimer)        ;;A-> Time of sustain     
    dec a                       ;;|
    ld (genericTimer), a        ;;|
    cp #0                       ;;|
    jr z, check_Iterations      ;;| Check if it hits 0 and then get to the check for iterations (in order to keep it counting down more time)
    ret
    
    check_Iterations:
        ld a, (sustainIterations)   ;;A -> Sustain Iterations to be done
        dec a
        ld (sustainIterations), a
        cp #0                      
        jr z, change_fade           ;;If the iterations are not Zero, we reset it and keep counting !!
        ld a, #200
        ld (genericTimer), a
        ret

    change_fade:
        ld a, #0x02                 ;;|
        ld (state), a               ;;|
        ld (sustainIterations), a   ;;|
        ld a, #200                  ;;|
        ld (genericTimer), a        ;;| Just changing the state and reseting variables to use it again!!!!

ret

fade_state:
    
    call AIManager_decrementIntensity

    ld a, (intensity)
    cp #0
    jr z, change_relax
    ret
    
    change_relax:
        ld a, #0x03
        ld (state), a
    
ret

relax_state:

    ld a, (genericTimer)
    dec a
    ld (genericTimer), a
    cp #0
    jr z, check_IterationsR
    ret
    
    check_IterationsR:
        ld a, (relaxIterations)
        dec a
        ld (relaxIterations), a
        cp #0
        jr z, change_build
        ld a, #200
        ld (genericTimer), a
        ld b, #0x00
        call respawnEnemy           ;;Spawns only in the left
        ret

    change_build:
        ld a, #0x00
        ld (state), a
        ld a, #0x03
        ld (relaxIterations), a
        ld a, #200
        ld (genericTimer), a

ret

