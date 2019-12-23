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

.include "collectable.h.s"
.include "door.h.s"
.include "enemy.h.s"
.include "room.h.s"
.include "entity.h.s"
.include "initializer.h.s"

lastCollectable: .dw #0x0000
lastDoor: .dw #0x0000
lastEnemy: .dw #0x0000

tilesetX: .db #0
tilesetY: .db #0
roomInspected: .db #0x00
tileInspected: .dw #0x0000
makeKey: .db #0x00



;;=========================================================================
;;  INIT OBJECTS BY TILESET
;;  Reads the tileset and creates the objects depending on the tile it is reading
;;  Now with our current tileset is
;;      09 -> Normal object
;;      14 -> Key      
;;  INPUTS: Nothing
;;  DESTROYS: All the registers, why to lie
;;  RETURNS: Nothing
;;
;;=========================================================================
initTilesetObjects:

    ld a, (roomInspected)           ;;Load in a the room that we are analysing
    ld c, a                         ;;Load into c the room that we are inspecting now
    ld b, #0                        ;;Load into b a 0, to avoid headbreaking errors
    call decompressCertainRoom      ;;We decompress the room in 0x40, but we don't draw it!!
    
    tileset_read_loop:              ;;The loop where all the magic happens

    ld a, (hl)                      ;;Charge into A what our pointer to the tile we are analysing
                                    ;;We must remember that the earlier call retrieves in HL a pointer to de first tile of our tileset :)
    cp #204                         ;;| Is the tile marked as a object position?
    jr z, create_normal_obj         ;;| If it is, go to the section where we prepare to create a normal object!!

    cp #207                          ;;| Is the tile marked as a key location?
    jr nz, next_tileset             ;;| If it isn't, then we can assume that the tile doesn't interest us, we get to the next tile calculation routine

    ld a, #0x01                     ;;| If it is a key, then we load into our key creation flag a nice and cozy 1 
    ld (makeKey), a                 ;;|
    jr callfunc                     ;;| And we go to the point where we call the function 

    create_normal_obj:              ;; This is only reachable if we jump towards it
    ld a, #0x00                     ;;
    ld (makeKey), a                 ;; We have to mark our key flag to 0, just to ensure that we create a cool object

    callfunc:                       ;; Call the awesome and amazing superfunction which makes our game pretty extreme and happy 
    ld (tileInspected), hl          ;; First, as we destroy HL with the function we are calling, we save it's value (memory position of the tile) to retrieve it later
    call create_object_mapped       ;; OH MY GOD MOM GET THE CAMERA, WE ARE CALLING THE FUNCTION -- The object will be created and stored into our collectables array
    ld hl, (tileInspected)          ;; We retrieve the tile memory position to continue our inspection

    next_tileset:
    inc hl                          ;;First, we increase HL to jump towards the next tile that is stored into our memory
    
    ;;------- THE CALCULUS HANDLED NOW IS FOR OBJECT POSITIONING AND TILESET ENDING ----------

    ld a, (tilesetX)                ;;|       
    inc a                           ;;|
    ld (tilesetX), a                ;;| Increment the X value of our tileset
    cp #40                          ;;
    jr nz, tileset_read_loop        ;; Is it in the with of our tileset, if it isn't, keep reading tiles

    ld a, (tilesetY)                ;;| 
    cp #33                          ;;|
    jr z, next_phase                ;;| If it is, we have to check if the tileset is completed. How?  Y = Tileset_Height as well
    
    
    ld a, #0                        ;;|
    ld (tilesetX), a                ;;| If it isn't over yet, we reset X to 0
    ld a, (tilesetY)                ;;
    inc a                           ;;|            
    ld (tilesetY), a                ;;| Increment de Y value
    
    jr tileset_read_loop            ;;And we keep reading tilesets with our loop

    
    ;; --- TILESET CHANGE ---
    next_phase:                     
    ld a, #0                        ;;|
    ld (tilesetX), a                ;;|
    ld (tilesetY), a                ;;| We reset all the coordinates to 0, because we are changing our tileset
;;
    ld a, (roomInspected)           ;;|
    inc a                           ;;|
    inc a                           ;;| Increment the room we are hanling by 2 (Remember that the vector is a vector of WORDS)
    ld (roomInspected), a           ;; - Update the value of room inspected
    cp #12                          ;;  We check if we have inspected all of our rooms
    jr nz, initTilesetObjects       ;; If we didn't, back to the loop

    ld a, #0x00                     ;;|
    ld (roomInspected), a           ;;| If it is 0, welp, we ended our routine

ret


;;=========================================================================
;;  CREATE OBJECTS MAPPED WITH THE TILESET
;;  Creates a object
;;  
;;  INPUTS: None
;;  DESTROYS: All the registers, why to lie
;;  RETURNS: Nothing
;;=========================================================================
    
create_object_mapped:
    
    call create_collectable     ;;|
    ld (lastCollectable), hl    ;;|
    ex de, hl                   ;;|
    call collectable_copy       ;;|
    ld hl, (lastCollectable)    ;;| We create and copy our object

    ld a, (tilesetX)            ;;| Charge the X value into a
    sla a                       ;;| Pos_object_X = Tileset_position_X * 2 + Origin_map
    ld b, a                     ;;| Load the result in b

    ld a, (tilesetY)            ;;| Charge the Y value into a
    sla a                       ;;|
    sla a                       ;;| Pos_object_Y = Tileset_position_Y * 2 + Origin_map    
    ld c, a                     ;;  Load into C the result

    ld a, (roomInspected)       ;;|
    ld d, a                     ;;| Load into d the room where the object is located

    call edit_collectable       ;;  We edit the collectable

    ld hl, (lastCollectable)    ;;|
    ld a, (makeKey)             ;;| We use the flag we settled before calling the function
    cp #01                      ;;|
    call z, defineKey           ;;| Is it a key? If it is, then we have to set it as a key

ret

;;Initializing the doors
initDoors:
    ;;DOOR TO ROOM 3
    call create_door
    ld (lastDoor), hl
    ex de, hl
    call door_copy
    ld hl, (lastDoor)

    ld b, #0x30
    ld c, #0x50
    ld d, #0x00
    call edit_door
    ld b, #0x40
    ld c, #0x50
    ld d, #0x04
    call edit_door_roomParameters
    
    ld hl, (lastDoor)
    call lock_door
    
    ;;DOOR TO ROOM 1
    call create_door
    ld (lastDoor), hl
    ex de, hl
    call door_copy
    ld hl, (lastDoor)

    ld b, #0x40
    ld c, #0x50
    ld d, #0x04
    call edit_door
    ld b, #0x30
    ld c, #0x50
    ld d, #0x00
    call edit_door_roomParameters

    ;;DOOR TO ROOM 6
    call create_door
    ld (lastDoor), hl
    ex de, hl
    call door_copy
    ld hl, (lastDoor)

    ld b, #0x40
    ld c, #0x50
    ld d, #0x02
    call edit_door
    ld b, #0x30
    ld c, #0x10
    ld d, #0x08
    call edit_door_roomParameters

    ;;DOOR TO ROOM 2
    call create_door
    ld (lastDoor), hl
    ex de, hl
    call door_copy
    ld hl, (lastDoor)

    ld b, #0x30
    ld c, #0x10
    ld d, #0x08
    call edit_door
    ld b, #0x40
    ld c, #0x50
    ld d, #0x02
    call edit_door_roomParameters

    ;;ESCAPE DOOR
    call create_door
    ld (lastDoor), hl
    ex de, hl
    call door_copy
    ld hl, (lastDoor)

    ld b, #0x00
    ld c, #0x50
    ld d, #0x00
    call edit_door
    ld b, #0x40
    ld c, #0x50
    ld d, #0xFF
    call edit_door_roomParameters

ret

initEnemies:

    call create_enemy
    ld (lastEnemy), hl
    ex de, hl
    call enemy_copy

    call create_enemy
    ld (lastEnemy), hl
    ex de, hl
    call enemy_copy
    ld hl, (lastEnemy)
    ld d, #0x02
    ld c, #1
    call edit_enemy

    call create_enemy
    ld (lastEnemy), hl
    ex de, hl
    call enemy_copy
    ld hl, (lastEnemy)
    ld d, #0x04
    ld c, #0
    call edit_enemy

    call create_enemy
    ld (lastEnemy), hl
    ex de, hl
    call enemy_copy
    ld hl, (lastEnemy)
    ld d, #0x06
    ld c, #0
    call edit_enemy

ret

init_hero:

    ld ix, #hero
    ld e_x(ix), #0x19
    ld e_y(ix), #0x50
    ld e_room(ix), #0x00

ret
