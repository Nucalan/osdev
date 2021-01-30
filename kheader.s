.section .mbt2std
tag_start:
.long 0xE85250D6
.long 0
.long tag_end-tag_start
.long -1*(tag_end-tag_start + 0 +  0xE85250D6)

.vbe:
.short 5
.short 0
.long 20
.long 1024
.long 768
.long 32
.vbe_e:
.long 0
#.efi:
#.short 9
#.short 0
#.long 12
#.long 0x1000000
#.efi_e:
#.long 0
#.short 0
#.short 0
#.long 8
tag_end:
.long 0xffffffffffffffff
.section .text
_kstart:
    movl %ebx,%eax
    .lopsvge:
        addl $1,%ebx
        cmpl $0x7,(%ebx)
        jne .lopsvge
        cmpl $0x310,4(%ebx)
        jne .lopsvge
        addl $0x238,%ebx
    movl (%ebx),%edx
    movl %edx,(fb_addr)
    pushl %edx
   /* movl %eax,%ebx
    .lopsvge1:
        addl $1,%ebx
        cmpl $0x2,(%ebx)
        jne .lopsvge1
        cmpl $16,4(%ebx)
        jne .lopsvge1
    movl (%ebx),%edx
    movl %edx,(mem_info)*/
movl $0x80000002,%eax
cpuid
movl %eax,(logo_cpu)
movl %ebx,(4+logo_cpu)
movl %ecx,(8+logo_cpu)
movl %edx,(16+logo_cpu)
movl $0x80000003,%eax
cpuid
movl %eax,(20+logo_cpu)
movl %ebx,(24+logo_cpu)
movl %ecx,(28+logo_cpu)
movl %edx,(32+logo_cpu)
movl $0x80000004,%eax
cpuid
movl %eax,(36+logo_cpu)
movl %ebx,(40+logo_cpu)
movl %ecx,(44+logo_cpu)
movl %edx,(48+logo_cpu)

    /*
    .lop:
        movl $0x00ff0000,(%edx) #Red
        addl $0x4,%edx
        subl $1,%ecx
        cmp $1,%ecx
        jnz .lop
        movl $0x5000,%ecx
        jmp .lop1
    .lop1:
        movl $0x0000ff00,(%edx)#Green
        addl $0x4,%edx
        subl $1,%ecx
        cmp $1,%ecx
        jnz .lop1
        movl $0x5000,%ecx
        jmp .lop2
    .lop2:
        movl $0x000000ff,(%edx)#Blue
        addl $0x4,%edx
        subl $1,%ecx
        cmp $1,%ecx
        jnz .lop2
        movl $0x5000,%ecx
        jmp .lop3
    .lop3:
        movl $0x00ffff00,(%edx)#Yellow
        addl $0x4,%edx
        subl $1,%ecx
        cmp $1,%ecx
        jnz .lop3
        movl $0x5000,%ecx
        jmp .lop4
    .lop4:
        movl $0x0000ffff,(%edx)#Cyan
        addl $0x4,%edx
        subl $1,%ecx
        cmp $1,%ecx
        jnz .lop4
        movl $0x5000,%ecx
        jmp .lop5
    .lop5:
        movl $0x00ff00ff,(%edx)#Pink
        addl $0x4,%edx
        subl $1,%ecx
        cmp $1,%ecx
        jnz .lop5
        movl $0x5000,%ecx    
        
        

*/

lidt (idtrp)
jmp kmain
jmp kmain
jmp kmain
jmp kmain
jmp kmain
jmp kmain
jmp kmain
nop
nop
nop
hlt
idt_s:
sys_idt: .fill 512,8,0 
idt_e:
idtrp:
    .word idt_e - idt_s - 1
    .long sys_idt
.globl logo_cpu
.globl _kstart
.globl sys_idt
.globl fb_addr
.globl mem_info
logo_cpu:.fill 53,8,0 
fb_addr: .fill 4,8,0
mem_info: .fill 4,8,0
