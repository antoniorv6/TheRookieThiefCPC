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

.include "frame.h.s"

;;======= HERO ANIMATION FRAMES =========
Frame h_idle_0, #_idle_0, 0x00
Frame h_idle_1, #_idle_1, 0x00
Frame h_idle_2, #_idle_2, 0x00
Frame h_idle_3, #_idle_3, 0x00
Frame h_idle_4, #_idle_4, 0x00
Frame h_idle_5, #_idle_5, 0x00

hero_idle: .dw #h_idle_0, #h_idle_1, #h_idle_2, #h_idle_3, #h_idle_4, #h_idle_5

Frame h_run_0, #_run_0, 0x00
Frame h_run_1, #_run_1, 0x00
Frame h_run_2, #_run_2, 0x00

hero_run:  .dw #h_run_0, #h_run_1, #h_run_2

Frame h_jump_0, #_jump_0, 0x00
Frame h_jump_1, #_jump_1, 0x00

hero_jump: .dw #h_jump_0, #h_jump_1

Frame h_block_0, #_protect_0, 0x00
Frame h_block_1, #_protect_1, 0x00
Frame h_block_2, #_protect_2, 0x00
Frame h_block_3, #_protect_3, 0x00
Frame h_block_4, #_protect_4, 0x00

hero_block: .dw #h_block_0, #h_block_1, #h_block_2, #h_block_3, #h_block_4

Frame h_punch_0, #_attack_0, 0x00
Frame h_punch_1, #_attack_1, 0x00
Frame h_punch_2, #_attack_2, 0x00
Frame h_punch_3, #_attack_3, 0x00
Frame h_punch_4, #_attack_4, 0x00
Frame h_punch_5, #_attack_5, 0x00
Frame h_punch_6, #_attack_6, 0x00
Frame h_punch_7, #_attack_7, 0x00
Frame h_punch_8, #_attack_8, 0x00

hero_punch: .dw #h_punch_0, #h_punch_1, #h_punch_2, #h_punch_3, #h_punch_4, #h_punch_5, #h_punch_6, #h_punch_7, #h_punch_8   

Frame e_idle_0, #_enemy_idle_0, 0x00
Frame e_idle_1, #_enemy_idle_1, 0x00

enemy_idle: .dw #e_idle_0, #e_idle_1

Frame e_run_0, #_enemy_run_0, 0x00
Frame e_run_1, #_enemy_run_1, 0x00

enemy_run: .dw #e_run_0, #e_run_1

Frame e_attack_0, #_enemy_attack_0, 0x00
Frame e_attack_1, #_enemy_attack_1, 0x00

enemy_attack: .dw #e_attack_0, #e_attack_1
;;=======================================