; Imports and exports
global load_idt
extern isr_general

; Defines
%define EMPTY_IDT_ENTRY dq 0

; IDT Macro
%macro IDT_ENTRY 1
    dw ((%1 - $$ + 0x100000) & 0xFFFF)
    dw 0x0008
    dw 0x8E00
    dw 0x0010
%endmacro

%macro EOI_MASTER_PIC 0
    mov al, 0x20
    out 0x20, al
%endmacro

%macro EOI_SLAVE_PIC 0
    mov al, 0x20
    out 0xA0, al
    mov al, 0x20
    out 0x20, al
%endmacro

;
; Main IDT entries
;             
idt:        ; Handler Function  / Description (Wikipedia)
    IDT_ENTRY isr0      ; Division by zero
    IDT_ENTRY isr1      ; Single-step interrupt (see trap flag)
    IDT_ENTRY isr2      ; NMI
    IDT_ENTRY isr3      ; Breakpoint (which benefits from the shorter 0xCC encoding of INT 3)
    IDT_ENTRY isr4      ; Overflow
    IDT_ENTRY isr5      ; Bound Range Exceeded
    IDT_ENTRY isr6      ; Invalid Opcode
    IDT_ENTRY isr7      ; Coprocessor not available
    IDT_ENTRY isr8      ; Double Fault
    IDT_ENTRY isr9      ; Coprocessor Segment Overrun (386 or earlier only)
    IDT_ENTRY isr10     ; Invalid Task State Segment
    IDT_ENTRY isr11     ; Segment not present
    IDT_ENTRY isr12     ; Stack Segment Fault
    IDT_ENTRY isr13     ; General Protection Fault
    IDT_ENTRY isr14     ; Page Fault
    IDT_ENTRY isr15     ; *Reserved
    IDT_ENTRY isr16     ; x87 Floating Point Exception
    IDT_ENTRY isr17     ; Alignment Check
    IDT_ENTRY isr18     ; Machine Check
    IDT_ENTRY isr19     ; SIMD Floating-Point Exception
    IDT_ENTRY isr20     ; Virtualization Exception
    IDT_ENTRY isr21     ; Control Protection Exception (only available with CET) 
    IDT_ENTRY isr22     ; *****************************
    IDT_ENTRY isr23     ;
    IDT_ENTRY isr24     ;
    IDT_ENTRY isr25     ;
    IDT_ENTRY isr26     ;           RESERVED
    IDT_ENTRY isr27     ;
    IDT_ENTRY isr28     ;
    IDT_ENTRY isr29     ;
    IDT_ENTRY isr30     ;
    IDT_ENTRY isr31     ; *****************************
    IDT_ENTRY irq0      ; *****************************
    IDT_ENTRY irq1      ;
    IDT_ENTRY irq2      ;
    IDT_ENTRY irq3      ;            IRQ 0-7 
    IDT_ENTRY irq4      ;
    IDT_ENTRY irq5      ;
    IDT_ENTRY irq6      ;
    IDT_ENTRY irq7      ; *****************************
    IDT_ENTRY irq8      ; *****************************
    IDT_ENTRY irq9      ;
    IDT_ENTRY irq10     ;
    IDT_ENTRY irq11     ;            IRQ 8-15 
    IDT_ENTRY irq12     ;
    IDT_ENTRY irq13     ;
    IDT_ENTRY irq14     ;
    IDT_ENTRY irq15     ; *****************************
    times 256-48 EMPTY_IDT_ENTRY; Empty IDT entries
;
; IRQ General handler/s
;
irq_handlers:
    times 16 dd irq_basic_handler
 
irq_basic_handler:
    ret

;
; Handler functions
;
isr0:
 pusha
 push 0
 call isr_general
 
isr1:
 pusha
 push 1
 call isr_general
 
isr2:
 pusha
 push 2
 call isr_general
 
isr3:
 pusha
 push 3
 call isr_general
 
isr4:
 pusha
 push 4
 call isr_general
 
isr5:
 pusha
 push 5
 call isr_general
 
isr6:
 pusha
 push 6
 call isr_general
 
isr7:
 pusha
 push 7
 call isr_general
 
isr8:
 pusha
 push 8
 call isr_general
 
isr9:
 pusha
 push 9
 call isr_general
 
isr10:
 pusha
 push 10
 call isr_general
 
isr11:
 pusha
 push 11
 call isr_general
 
isr12:
 pusha
 push 12
 call isr_general
 
isr13:
 pusha
 push 13
 call isr_general
 
isr14:
 pusha
 push 14
 call isr_general
 
isr15:
 pusha
 push 15
 call isr_general
 
isr16:
 pusha
 push 16
 call isr_general
 
isr17:
 pusha
 push 17
 call isr_general
 
isr18:
 pusha
 push 18
 call isr_general
 
isr19:
 pusha
 push 19
 call isr_general
 
isr20:
 pusha
 push 20
 call isr_general
 
isr21:
 pusha
 push 21
 call isr_general
 
isr22:
 pusha
 push 22
 call isr_general
 
isr23:
 pusha
 push 23
 call isr_general
 
isr24:
 pusha
 push 24
 call isr_general
 
isr25:
 pusha
 push 25
 call isr_general
 
isr26:
 pusha
 push 26
 call isr_general
 
isr27:
 pusha
 push 27
 call isr_general
 
isr28:
 pusha
 push 28
 call isr_general
 
isr29:
 pusha
 push 29
 call isr_general
 
isr30:
 pusha
 push 30
 call isr_general
 
isr31:
 pusha
 push 31
 call isr_general
irq0:
    mov dword [stack_of_interrupt], esp

    pusha
    mov eax, dword [irq_handlers+(4*0)]
    call eax
    EOI_MASTER_PIC
    popa
    iret
irq1:
    pusha
    mov eax, dword [irq_handlers+(4*2)]
    call eax
    EOI_MASTER_PIC
    popa
    iret
irq2:
    pusha
    mov eax, dword [irq_handlers+(4*2)]
    call eax
    EOI_MASTER_PIC
    popa
    iret
irq3:
    pusha
    mov eax, dword [irq_handlers+(4*2)]
    call eax
    EOI_MASTER_PIC
    popa
    iret
irq4:
    pusha
    mov eax, dword [irq_handlers+(4*2)]
    call eax
    EOI_MASTER_PIC
    popa
    iret
irq5:
    pusha
    mov eax, dword [irq_handlers+(4*2)]
    call eax
    EOI_MASTER_PIC
    popa
    iret
irq6:
    pusha
    mov eax, dword [irq_handlers+(4*2)]
    call eax
    EOI_MASTER_PIC
    popa
    iret
irq7:
    pusha
    mov eax, dword [irq_handlers+(4*2)]
    call eax
    EOI_MASTER_PIC
    popa
    iret
irq8:
    pusha
    mov eax, dword [irq_handlers+(4*2)]
    call eax
    EOI_MASTER_PIC
    popa
    iret
irq9:
    pusha
    mov eax, dword [irq_handlers+(4*2)]
    call eax
    EOI_MASTER_PIC
    popa
    iret
irq10:
    pusha
    mov eax, dword [irq_handlers+(4*2)]
    call eax
    EOI_MASTER_PIC
    popa
    iret
irq11:
    pusha
    mov eax, dword [irq_handlers+(4*2)]
    call eax
    EOI_MASTER_PIC
    popa
    iret
irq12:
    pusha
    mov eax, dword [irq_handlers+(4*2)]
    call eax
    EOI_MASTER_PIC
    popa
    iret
irq13:
    pusha
    mov eax, dword [irq_handlers+(4*2)]
    call eax
    EOI_MASTER_PIC
    popa
    iret
irq14:
    pusha
    mov eax, dword [irq_handlers+(4*2)]
    call eax
    EOI_MASTER_PIC
    popa
    iret
irq15:
    pusha
    mov dx, 0xA0
    mov al, 0xB
    out dx, al
    in al, dx
    test al, 0x80
    jnz .irq15_not_spur
    EOI_MASTER_PIC
    popa
    iret

    .irq15_not_spur:
    mov eax, dword [irq_handlers+(4*15)]
    call eax
    EOI_SLAVE_PIC
    popa
    iret


IDT_META:
    dw 2047 ; IDT size
    dd idt  ; IDT address

load_idt:
    cli
    mov edx, IDT_META
    lidt [edx]
    sti
    ret
    
    