.include "gameOverScreen.h.s"
.include "cpcteleraFuncs.h.s"
;;.include "cpctelera.h.s"
.include "GUI.h.s"
.include "entity.h.s"

string1: .asciz "YOU ESCAPED!"
string2: .asciz "You earned: "
string3: .asciz "$"
string4: .asciz "Press X to get back"
string5: .asciz "YOU DIED!"

x: .db #25
y: .db #60

charUnits: .db #0x00
charDecens: .db #0x00

finalPoints: .db #0x00

endscreen:
    
    ;; Set up draw char colours before calling draw string
        ld    h, #0         ;; D = Background PEN (0)
        ld    l, #5         ;; E = Foreground PEN (3)
        call cpct_setDrawCharM0_asm   ;; Set draw char colours
    
        ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
        ld    b, #30                  ;; B = y coordinate (24 = 0x18)
        ld    c, #13                   ;; C = x coordinate (16 = 0x10)

        call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

        ld   a,  e_aliv(iy)
        cp #0
        jr z, dead 
        
        ld   iy, #string1 
        jr continue  

        dead:
          ld iy, #string5

    continue:

        call cpct_drawStringM0_asm ;; Draw the string

        call getPunctuation     ;;HL is Units and DE is decens
        
        ld a, l
        ld (charUnits), a
        ld a, e
        ld (charDecens), a

        ld de, #CPCT_VMEM_START_ASM
        ld b, #60
        ld c, #60
        call cpct_getScreenPtr_asm

        ld a, (charUnits)
        ld e, a
        call cpct_drawCharM0_asm

        ld de, #CPCT_VMEM_START_ASM
        ld b, #60
        ld c, #55
        call cpct_getScreenPtr_asm

        ld a, (charDecens)
        ld e, a
        call cpct_drawCharM0_asm


        

        ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
        ld    b, #60                  ;; B = y coordinate (24 = 0x18)
        ld    c, #5                   ;; C = x coordinate (16 = 0x10)

        call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

        ld   iy, #string2  

        call cpct_drawStringM0_asm ;; Draw the string

        ;; Set up draw char colours before calling draw string
        ld    h, #0         ;; D = Background PEN (0)
        ld    l, #5         ;; E = Foreground PEN (3)
        call cpct_setDrawCharM0_asm   ;; Set draw char colours

        ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
        ld    b, #85                  ;; B = y coordinate (24 = 0x18)
        ld    c, #2                   ;; C = x coordinate (16 = 0x10)

        call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

        ld   iy, #string4   

        call cpct_drawStringM0_asm ;; Draw the string
        
        
ret