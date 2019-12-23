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

;;.include "cpctelera.h.s"
.include "cpcteleraFuncs.h.s"
.include "room.h.s"
.include "doubleBuffer.h.s"

.globl escape_building

actualRoomNumber: .db #0x00

rooms: .dw #_room1_pack_end, #_room2_pack_end, #_room3_pack_end, #_room4_pack_end, #_room5_pack_end, #_room6_pack_end

width: .dw #0x0000
height: .dw #0x0000

actualRoom: .dw #0x0000
roomInspect: .dw #0x000

decompress_buffer= 0x040
levelmaxsize     = 0x528
decompress_buffer_end = decompress_buffer + levelmaxsize - 1
tileset_ptr =      decompress_buffer + 0

init_levels:
    ld hl, (rooms)
    ld (actualRoom), hl
    ld a, #0x00
    ld (actualRoomNumber), a
ret

;;Inputs: BC-> The Room to decompress
decompressCertainRoom:

    ld ix, #rooms
    add ix, bc ;;We locate the room we want to analyse
    
    ld h, 1(ix)
    ld l, (ix)

    ld de, #decompress_buffer_end
    call cpct_zx7b_decrunch_s_asm

    ld hl, #tileset_ptr
    
ret

decompressRoom:
    ld hl, (actualRoom)
    ld de, #decompress_buffer_end
    call cpct_zx7b_decrunch_s_asm
ret

;;==============================================
;;  GETACTUALROOM
;;  Picks the actual room number                                                            
;;  DESTROYS -> AF
;;  RETURNS -> AF - RoomNumber
;;==============================================
getActualRoom:
    ld a, (actualRoomNumber)
ret


;;==============================================
;;  DRAW A TILEROOM
;;  Draws an entire tileroom (It is called in very specific times) -> Game initialization, Room change                                                            
;;  DESTROYS -> HL, BC, DE, AF
;;  RETURNS -> HL pointer to the new entity
;;==============================================
room_draw:
    call decompressRoom

    ld hl, #_tileset                    ;;HL - Pointer to the tileset colors
    call cpct_etm_setTileset2x4_asm

    ld hl, #tileset_ptr
    push hl

    call get_back_buffer
    ex de, hl
    push hl

    ld bc, #0000
    ld de, #0x2128
    ld a, #40

    call cpct_etm_drawTileBox2x4_asm

    ld hl, #tileset_ptr
    push hl

    call get_front_buffer
    ex de, hl
    push hl

    ld bc, #0000
    ld de, #0x2128
    ld a, #40

    call cpct_etm_drawTileBox2x4_asm

ret


;;==============================================
;;  DRAW A TILEROOM
;;  Draws a part of the tileroom in order to erase correctly an entity    
;;  INPUTS -> BC - X and Y coordinates of our entity
;;            DE - Height and width of our entity                                                       
;;  DESTROYS -> HL, BC, DE, AF
;;  RETURNS -> Nothing
;;==============================================
room_draw_part:

    ld (width), bc
    ld (height), de

    ld hl, #_tileset                    ;;HL - Pointer to the tileset colors
	call cpct_etm_setTileset2x4_asm

    ld hl, #tileset_ptr                       ;;HL - Pointer to the actual room we must draw
	push hl

    call get_back_buffer
    ex de, hl
	push hl

    ld bc, (width)
    ld de, (height)

    srl b
    srl b                               ;;Divide Y coordinate of our entity by 4
    srl c                               ;;Divide X coordinate of our entity by 2
    srl d                               ;;Divide Height by 2 in order to get bytes
    srl d
    inc d

    dec e

    ld a, #40

   call cpct_etm_drawTileBox2x4_asm

ret

room_draw_partfb:

    ld (width), bc
    ld (height), de

    ld hl, #_tileset                    ;;HL - Pointer to the tileset colors
	call cpct_etm_setTileset2x4_asm

    ld hl, #tileset_ptr                       ;;HL - Pointer to the actual room we must draw
	push hl

    call get_front_buffer
    ex de, hl
	push hl

    ld bc, (width)
    ld de, (height)

    srl b
    srl b                               ;;Divide Y coordinate of our entity by 4
    srl c                               ;;Divide X coordinate of our entity by 2
    srl d                               ;;Divide Height by 2 in order to get bytes
    

    ld a, #40

   call cpct_etm_drawTileBox2x4_asm

ret


;;==============================================
;;  CHANGE ROOM
;;  Changes the room ptr and the number to make our dynamic map!!!    
;;  INPUTS -> C - Increment of the pointer, could be possitive or negative
;;  HOW THIS WORKS -> 4 directions: UP = +4, DOWN = -4, LEFT = -2, RIGHT = +2                                                       
;;  DESTROYS -> HL, BC, DE, AF
;;  RETURNS -> Z active if the room cannot be changed
;;==============================================

change_room:

   call check_room_status
   jr z, no_change

   ld a, (actualRoomNumber) ;;Charge the actual room number (offset)
   add a, c                 ;;Add the quantity we need (Instructions on the top of the function) 
   ld (actualRoomNumber), a ;;We store the new value in actualRoomNumber

   ld c, a                  ;;We load it into C to make the next operation
   ld b, #0x00              ;;Ensure that B is 0
   ld iy, #rooms            ;;Load the room structure in HL
   add iy, bc               ;;Go to that memory position we want
   ld h, 1(iy)
   ld l, (iy)               ;;Load into hl the new room we have to draw

   ld (actualRoom), hl      ;;ActualRoom now settled to make a new draw
   call room_draw

   ld a, #01
   or a                     ;;Operation could trigger Z flag. As it is a crucial part of the return value, I have to put it NZ mandatory
   ret
   no_change:

ret


;;==============================================
;;  CHANGE ROOM DIRECTLY WITH NO FEARS
;;  Changes the room ptr and the number. It is used by doors  
;;  INPUTS -> C - Room number to change                                                      
;;  DESTROYS -> HL, BC, DE, AF
;;  RETURNS -> Nothing
;;==============================================

change_room_direct:
    
    ld a, c
    cp #0xFF                ;;Has our thief escaped the buliding?
    jr nz, changeit
    call escape_building
    ret

    changeit:
    ld (actualRoomNumber),a ;;We change the room number first

    ld b, #0x00 ;;We ensure that b is zero
    ld iy, #rooms            ;;Load the room structure in iy
    add iy, bc               ;;Go to that memory position we want
    ld h, 1(iy)
    ld l, (iy)               ;;Load into hl the new room we have to draw

    ld (actualRoom), hl      ;;ActualRoom now settled to make a new draw
    call room_draw

    ld a, #01
    or a                     ;;Operation could trigger Z flag. As it is a crucial part of the return value, I have to put it NZ mandatory
ret

;;==============================================
;;  CHECK ROOM STATUS
;;  Checks if the room can be changed  
;;  INPUTS -> C - Increment of the pointer, could be possitive or negative
;;  DESTROYS: AF
;;  RETURNS -> Flag Z = 1 if the room cannot be changed
;;==============================================
check_room_status:

    ld a, c
    cp #-2
    jr z, check_left_limit

    cp #2
    jr z, check_right_limit

    check_left_limit:
        ld a, (actualRoomNumber)
        cp #0
        
        ret
    
    check_right_limit:
        ld a, (actualRoomNumber)
        cp #10

ret

