
.macro Frame _name, sprite, direction
_name:
    .dw sprite
    .db direction    
.endm
f_sp_l     = 0
f_sp_h     = 1
f_dir      = 2

;; DEFINITION OF GLOBAL SPRITES 
;;==========================================================
.globl _idle_0
.globl _idle_1
.globl _idle_2
.globl _idle_3
.globl _idle_4
.globl _idle_5
.globl _run_0
.globl _run_1
.globl _run_2
.globl _jump_0
.globl _jump_1
.globl _protect_0
.globl _protect_1
.globl _protect_2
.globl _protect_3
.globl _protect_4
.globl _attack_0
.globl _attack_1
.globl _attack_2
.globl _attack_3
.globl _attack_4
.globl _attack_5
.globl _attack_6
.globl _attack_7
.globl _attack_8
.globl _enemy_idle_0
.globl _enemy_idle_1
.globl _enemy_run_0
.globl _enemy_run_1
.globl _enemy_attack_0
.globl _enemy_attack_1
;;==========================================================

;;DEFINITION OF GLOBAL VECTORS
;;==========================================================

.globl hero_idle
.globl hero_run
.globl hero_jump
.globl hero_block
.globl hero_punch
.globl enemy_idle
.globl enemy_run
.globl enemy_attack

;;==========================================================