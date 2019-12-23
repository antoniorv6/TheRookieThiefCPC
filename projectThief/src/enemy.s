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
.include "enemy.h.s"
.include "main.h.s"
.include "AIManager.h.s"
.include "doubleBuffer.h.s"
.include "room.h.s"
.include "animationManager.h.s"

.globl cpct_getRandom_lcg_u8_asm
.globl cpct_getScreenPtr_asm
.globl cpct_drawSolidBox_asm

nextEnemy:                  .dw #0x0000
numEnemies:                 .db 0   

enemyVector:                .dw #0x0000

enemyToUpdate:              .dw #0x0000

enemy_attackTimer:          .db #8
enemy_patrolTimer:          .db #0
enemy_oldDecision:          .db #0
enemy_stalkTimer:           .db #0
enemy_decisionTimer:        .db #25
enemy_distanceLimitLeft:    .db #-10
enemy_distanceLimitRight:   .db #10

spawns_buildUP:             .db #2
counter:                    .db #5
im_enemy:                   .db #0

;;===============================================================================
;;  ENEMY LOGIC UPDATE
;;  Here will happen all the decisionmaking that will involve our enemy behavour
;;  
;;===============================================================================
enemy_update:
    ld a, e_aliv(ix)
    cp #0
    jr z, no_update ;;Is the enemy dead?
    
    ld a, e_chas(ix)
    cp #0
    jr nz, enemy_chasing_routine ;;The function will return Z if there is a hero and NZ if there is not a hero

    ;; Behaviour by default
    call AI_patrol_routine    
    call AIManager_incrementIntensity    ;;When it stops chasing you, decrement the intensity of gameplay

    ;;If he is not chansing the hero, then he tries to detect it in the same room
    call detect_hero

    jr no_update
    
    enemy_chasing_routine:  ;;DO THIS IF THE ENEMY IS CHASING THE HERO

        call AIManager_decrementIntensity

        ld a, e_type(ix)
        cp #0
        jr nz, stalking_AI

        call enemy_move
        jr no_update

    stalking_AI:

    call AI_stalking_routine

    no_update:
ret

enemy1_update:

ret

;;===============================================================================
;;  DETECTS HERO IN THE SAME ROOM AND FLOOR
;;  Sets enemy behaviour to chasing mode
;;  DESTROYS: a, b
;;  INPUT: iy = hero, ix = enemy 
;;===============================================================================
detect_hero:
    ld a, e_room(iy)
    ld b, e_room(ix)
    sub b
    jr z, chasingstep
    jr endfunc

    chasingstep:    ;;They are in the same room
        ld a, e_y(ix)
        ld b, e_y(iy)
        sub b
        jr nz, endfunc  ;;Are they in the same Y coordinates?
        
        ld e_chas(ix), #1 ;;If so, chase it
        ret

    endfunc:
ret

;;==============================================
;;  INITENEMYENVIRONMENT
;;  Initializes enemy environment to operate
;;  DESTROYS -> HL
;;  RETURNS -> None
;;==============================================
initEnemyEnvironment:
    call getEnemyVector   ;;HL now points to enemyVector
    ld (enemyVector), hl 
    ld (nextEnemy), hl
ret

;;==============================================
;;  CREATE A ENEMY
;;  Creates a enemy and adds it to the vector
;;  DESTROYS -> HL, AF, BX
;;  RETURNS -> HL pointer to the new entity
;;==============================================
create_enemy:
    ld a, (numEnemies)
    inc a
    ld (numEnemies), a ;;Increment the number of entities

    ld hl, (nextEnemy) ;;HL points to nextEnemy
    call getEntitySize
    add hl, bc         ;;Add the size to HL
    ld (nextEnemy), hl ;;Update nextEnemy value
    or a               ;;Carry = 0, **Secure measeure for next step**
    sbc hl, bc         ;;Substract bc to hl, in order to retrieve the pointer to the new enemy!!!

    endofcreation:
ret


;;==============================================
;;  COPY_ENEMY
;;  Creates a enemy and adds it to the vector
;;  INPUTS -> HL - Origin 
;;            DE - Destiny
;;  DESTROYS -> HL, BC, DE
;;  RETURNS -> 
;;==============================================
enemy_copy:
    call getEntitySize
    ld hl, #enemymodel
    ldir
ret

;;==============================================
;;  EDIT_ENEMY
;;  Allows you to edit the enemy room location
;;  INPUTS -> HL -> Pointer to the enemy
;;            D -> Room to change
;;  DESTROYS -> DE, AF
;;  RETURNS -> 
;;==============================================
edit_enemy:
    ld (enemyToUpdate), hl
    ld ix, (enemyToUpdate)
    ld e_room(ix), d        ;;Change the room with the new value
    ld e_type(ix), c        ;;Change the type with the new value

    ld a, e_type(ix)        ;;This kind of sprite editing is provisional
    cp #0
    jr nz, change_sprite

    jr continue_edit

    change_sprite:
;    ld e_spr(ix), #0x01

    continue_edit:    

    ld e_aliv(ix), #0x01    ;;It will be used to revive our awesome enemy
    ld e_chas(ix), #0x00

    ld iy, #hero
    ld a, e_js(iy)
    cp #-1
    jr z, spawn_normal
    ld e_y(ix), #0x50
    ret
    
    spawn_normal:
    ld a, e_y(iy)
    ld e_y(ix), a

ret

;;==============================================
;;  MOVE ENEMY
;;  Moves the enemy in the x and y axes
;;  DESTROYS -> A, HL, IY, B, D, E
;;  RETURNS -> None
;;==============================================
enemy_move:

    ;;Execute chasing routine
    jp AI_chasing_routine

    ;;Move to the right room
    changeroom_right_enemy_move:
        ld a, e_room(ix)
        inc a
        inc a
        ld e_room(ix), a
        ld e_x(ix), #4
        jp next_enemy_move

    ;;Move to the left room
    changeroom_left_enemy_move:
        ld a, e_room(ix)
        dec a
        dec a
        ld e_room(ix), a
        ld e_x(ix), #80-6
        jp next_enemy_move
 
    ;;Continue moving inside the room
    continue_enemy_move:
    call check_collision

    next_enemy_move:

ret

enemy_draw:


ret

;;==============================================
;;  IT CONTROLS THE AI CHASING ROUTINE
;;  Starts the enemy routine of chasing the hero
;;  DESTROYS -> A,B,D
;;  RETURNS -> None
;;==============================================
AI_chasing_routine:

    ;;We calculate if enemy and hero are in the same room
    ld a, e_room(iy)
    ld b, e_room(ix)
    sub b
    jr z, continuemovement

    ;;Check if the hero is in the rooms at our right
    ld a, e_room(iy)     ;;If the hero is in the next room, enemy'll keep moving until he changes room too
    sub b
    cp #2
    jr z, keepchasing_right
    cp #4
    jr z, stop_chasing

    ;;Check if the hero is in the rooms at our left
    ld a, e_room(iy)     ;;If the hero is in the next room, enemy'll keep moving until he changes room too
    sub b
    cp #-2
    jr z, keepchasing_left
    cp #-4
    jr z, stop_chasing

    ;;Check altitude
    ld a, e_y(ix)
    ld b, e_y(iy)
    sub b
    jr nz, stop_chasing  ;;Different altitude = stop chasing

    continuemovement:    ;;If they are in the same room, enemy is chasing hero for sure

    ld    b, e_x(iy)     ;;hero_x
    ld    a, e_x(ix)     ;;enemy_x

    ld    d, a           ;;We save our enemy_x to restore it if it collides

    ;;We check if a<b
    sub b
    jp m, move_right

    move_left:
        ld a, e_x(ix)        ;;enemy_x -= 1 (enemy_x = enemy_x - 1)
        dec a
        ld e_x(ix), a
        ld e_vx(ix), #-1
        ld e_dir(ix), #1
        jp continue_enemy_move ;; Continue in enemy_move

    move_right:           ;;enemy_x += 1 (enemy_x = enemy_x + 1)
        ld a, e_x(ix)
        inc a
        ld e_x(ix), a
        ld e_vx(ix), #1
        ld e_dir(ix), #0
        jp continue_enemy_move ;; Continue in enemy_move

    keepchasing_right:           ;;Enemy keeps moving to the right until he changes room too
            ld a, e_x(ix)
            cp #80-6
            jp z, changeroom_right_enemy_move
            
            inc a
            ld e_x(ix), a
            jp next_AI_chasing_routine

    keepchasing_left:
            ld a, e_x(ix)
            cp #0
            jp z, changeroom_left_enemy_move
            
            dec a
            ld e_x(ix), a

    next_AI_chasing_routine:
    jp next_enemy_move     ;;Return to enemy_move

    stop_chasing:
        ld e_chas(ix), #0   ;;Stop chasing
        jp next_enemy_move     ;;Return to enemy_move

ret

;;==============================================
;;  IT CONTROLS THE AI PATROL ROUTINE
;;  Starts the patrol routine of the enemy
;;  DESTROYS -> A,B,L
;;  RETURNS -> None
;;==============================================
AI_patrol_routine:

     ld a, (enemy_patrolTimer)                ;;We check if its timer is 0
     cp #0
     jr z, decision                           ;;If it's 0 -> Enemy makes a decision about what to do

     ld b, #1
     sub b
     ld (enemy_patrolTimer), a                ;;enemy_patrolTimer -= 1

     ;;No new decision -> Executes the old one
     ld a, (enemy_oldDecision)
     cp #0
     jp z, keepchasing_left

     jp keepchasing_right

     jr next

      decision:
        ld l, #0
        call cpct_getRandom_lcg_u8_asm        ;;We get a random number between 0 and 255
         srl l                                ;;Move 4 positions to the right so we get a number between 0 and 15
         srl l
         srl l
         ld a, #15
         add l                                ;;We add 10 to the random number so we get a random number between 15 and 30
        ld (enemy_patrolTimer), a             ;;This random number is the new timer
                     
        ld l, #0
        call cpct_getRandom_lcg_u8_asm        ;;We get a random number between 0 and 255
         srl l                                 ;;Move 7 positions to the right so we get a number between 0 and 1
         srl l
         srl l
         srl l
         srl l
         srl l
         srl l
         ld a, l
         ld (enemy_oldDecision), a             ;;We keep the old decision
         cp #0                                ;;If it's 0 -> move left
        jp z, keepchasing_left

        jp keepchasing_right                  ;;If it's 1 -> move right

    next:
ret

;;==============================================
;;  IT CONTROLS THE STALKER'S AI CHASING ROUTINE
;;  Starts the enemy routine of stalking the hero
;;  DESTROYS -> AB, C
;;  RETURNS -> None
;;==============================================
AI_stalking_routine:
    ;;We calculate if enemy and hero are in the same room
    ld a, e_room(iy)
    ld b, e_room(ix)
    sub b
    jr z, continue_stalking

    jr finish_stalking

    continue_stalking:
    ;;Check altitude
    ld a, e_y(ix)
    ld b, e_y(iy)
    sub b
    jr nz, finish_stalking   ;;Different altitude = stop chasing

    ;;We check if a<b
    ld e_vx(ix), #1
    ld a, e_x(ix)
    ld b, e_x(iy)
    ld d, a
    sub b
    jp m, move_right2

    ;;move_left2
    ld e_vx(ix), #-1
    ld e_dir(ix), #1
    ld a, (enemy_distanceLimitLeft)     ;;hero_x - security_distance = S // a = S
    ld b, a
    ld a, e_x(iy)
    sub b                               ;;S - enemy_x = +/-
    ld c, e_x(ix)     
    sub c
    jp p, keep_stalking                 ;;If the result is possitive, enemy can't get closer

    ld a, e_x(ix)
    dec a
    ld e_x(ix), a
    jr keep_stalking

    ;;E....H
    move_right2:
    ld e_dir(ix), #0
     ld a, (enemy_distanceLimitRight)     ;;hero_x - security_distance = S // a = S
     ld b, a
     ld a, e_x(iy)
     sub b                               ;;S - enemy_x = +/-
     ld c, e_x(ix)     
     sub c
     jp m, keep_stalking                 ;;If the result is negative, enemy can't get closer

    ld a, e_x(ix)
    inc a
    ld e_x(ix), a
     
    keep_stalking:
    ld a, (enemy_decisionTimer)
    cp #0
    jr z, engage

    dec a
    ld (enemy_decisionTimer), a
    jr finish_stalking

    engage:
    call check_collision
    ld a, #0
    ld (enemy_distanceLimitLeft), a
    ld a, #0
    ld (enemy_distanceLimitRight), a
    ld e_vx(ix), #0

    finish_stalking:
ret
;;==============================================
;;  RUN FUNC ON ENEMY VECTOR
;;  Runs a function into the enemy vector
;;  INPUT: HL - Pointer to function to execute
;;==============================================
runFunconEnemyVector:
   ld a, (numEnemies)
   cp #0
   jr z, evacuate
   ld ix, (enemyVector)
   ld (method), hl
    loop:
        push af
        method = . + 1
        call entity_draw
        pop af
        call getEntitySize
        add ix, bc
        dec a
    jr nz, loop

    evacuate:

ret

;;==============================================
;;  CHECK COLLISIONS
;;  Check if there's collision in x and y axes
;;  INPTUS -> IX, IY: Entities to check
;;  DESTROYS -> A, B, C
;;  RETURNS -> None
;;==============================================
 check_collision::
    ;Check x
    ld iy, #hero
    ld  a, e_x(iy)          ;;hero_x + hero_w - enemy_w <= 0 -> no collision
    ld  c, e_w(iy)
    add c
    ld  b, e_x(ix)
    sub b
    jp z, no_collision
    jp m, no_collision

    ld a, e_x(ix)           ;;enemy_x + enemy_w - hero_x <= 0 -> no collision
    ld c, e_w(ix)
    add c
    ld b, e_x(iy)
    sub b
    jp z, no_collision
    jp m, no_collision


    ;;Check y
    ld  a, e_y(iy)          ;;hero_x + hero_w - enemy_x <= 0 -> no collision
    ld  c, e_h(iy)
    add c
    ld  b, e_y(ix)
    sub b
    jp z, no_collision
    jp m, no_collision

    ld a, e_y(ix)           ;;enemy_x + enemy_w - hero_x <= 0 -> no collision
    ld c, e_h(ix)
    add c
    ld b, e_y(iy)
    sub b
    jp z, no_collision
    jp m, no_collision

    ;;Collision
    ld e_x(ix), d
    ;ld e_y(ix), e          ;;This line fucks everything up
    ld e_vx(ix), #0

    ;;Check if the hero is attacking when the enemy collides
    ld    a, e_att(iy)
    cp #0                   ;;0 -> Hero is not attacking
    jr z, enemy_attack

    call kill_entity

    ld a, #30
    ld (enemy_decisionTimer), a
    ld a, #10
    ld (enemy_distanceLimitRight), a
    ld a, #-10
    ld (enemy_distanceLimitLeft), a

    ld e_att(iy), #0        ;;Restart hero's attack status

    enemy_attack:           ;;We check if time has passed so the enemy can attack again
        ld a, e_type(ix)
        cp #0
        jr nz, stay_and_attack

        jr continue_attack

        stay_and_attack:
        ld a, (counter)
        cp #0
        jr nz, stay

        ld a, #10
        ld (counter), a
        jr continue_attack

        stay:
        ld a, e_x(iy)
        ld b, #3
        add b
        ld e_x(ix), a
        ld a, (counter)
        inc a
        ld (counter), a

        continue_attack:

        ld a, (enemy_attackTimer)
        cp #0
        jr z, attack        ;;If his timer is 0, he'll attack again
        
        ld b, #-4           ;;If it's not, enemy won't attack and we reduce the timing -1
        sub b               ;;a-b -> enemy_attackTimer - 1
        ld (enemy_attackTimer), a

        jr no_collision

        attack:              ;;Enemy attacks hero
          
          ld a, e_block(iy)  ;;Our hero could be blocking this terrible attack
          cp #1
          jr z, blocked      ;;The hero has blocked the attack
        
          ld a, #8
          ld (enemy_attackTimer), a     ;;Enemy attack timer is restored
          ld e_aliv(iy), #0             ;;Hero dies
          call endgame

          blocked:
          ld a, #8
          ld (enemy_attackTimer), a     ;;Enemy attack timer is restored   
          
          ld a, e_blocksLeft(iy)
          dec a
          ld e_blocksLeft(iy), a       
          
          call move_blockage

    no_collision:

ret


move_blockage:
    ld a, e_x(ix)
    ld b, e_x(iy)

    cp b
    jp m, push_right

    dec b
    dec b
    dec b
    ld e_x(iy), b
    ret

    push_right:
    inc b
    inc b
    inc b
    ld e_x(iy), b

ret

resetEnemies:
    ld a, #0
    ld (numEnemies), a
    ld hl, #0x0000
ret

;;========================================================
;;  RESPAWNENEMY
;;  Respawns one single enemy if it is dead
;;  INPUTS:  -> Where to respawn
;;  RETURNS: None
;;  DESTROYS: AF, BC, IX, HL, DE , IY (Pretty much all the registers get corrupted)
;;========================================================

respawnEnemy:

   ld a, (numEnemies)
   cp #0
   jr z, evacuate2

   ld a, b
   cp #0
   jr z, respawnLeft
   jr respawnRight 
   
   evacuate2:

ret

respawnLeft:

    call getPlayerRoom                              ;;We store into D the player room
        ld a, d                                 ;;Change it to A
        cp #0                                   ;;Check if the room is the 0000 (Most left one)
        jr nz, loopRestoreLeft                  ;;If it is, we have to spawn the enemy into the left
    ret

    loopRestoreLeft:
        ld a, (numEnemies)
        ld ix, (enemyVector)

        loopLeft:
            ld (enemyToUpdate), ix
            push af
            
            ld a, e_aliv(ix)                ;;Is the enemy alive?
            cp #0                           
            jr nz, nextone                  ;;If it is alive, then we have to check for another

            call getPlayerRoom              ;;We store into D the player room
            ld a, d                         ;;Change it to A

            dec a   
            dec a

            ld d, a                         ;;Stock the room into D to respawn our enemy
            ld hl, (enemyToUpdate)          ;;We prepare the data for our function of respawn
            ld c, e_type(ix)

            call edit_enemy                 ;;Call the function to respawn this brave man
            
            pop af
            ret
            
            nextone:                       ;;Routine to get the next enemy
            pop af
            call getEntitySize
            add ix, bc
            dec a
    
        jr nz, loopLeft
ret

respawnRight:

    call getPlayerRoom                              ;;We store into D the player room
        ld a, d                                 ;;Change it to A
        cp #10                                   ;;Check if the room is the 0000 (Most left one)
        jr nz, loopRestoreRight                  ;;If it is, we have to spawn the enemy into the left
    ret


    loopRestoreRight:
    
    ld a, (numEnemies)
        
        loopRight:
            ld (enemyToUpdate), ix
            push af
            
            ld a, e_aliv(ix)                ;;Is the enemy alive?
            cp #0                           
            jr nz, nextone2                  ;;If it is alive, then we have to check for another

            call getPlayerRoom              ;;We store into D the player room
            ld a, d                         ;;Change it to A

            inc a   
            inc a

            ld d, a                         ;;Stock the room into D to respawn our enemy
            ld hl, (enemyToUpdate)          ;;We prepare the data for our function of respawn
            ld c, e_type(ix)

            call edit_enemy                 ;;Call the function to respawn this brave man
            
            pop af
            ret
            
            nextone2:                       ;;Routine to get the next enemy
            pop af
            call getEntitySize
            add ix, bc
            dec a
    
        jr nz, loopRight
ret