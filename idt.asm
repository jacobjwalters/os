; File containing IDT. Make sure to write routines for the useful interrupts!
; For simplicity, all IDT entries are assumed to be below 64k.

; This table takes up 4096 bytes (0x1000)

idt:
        ; Entry 0 - Divide by 0 - Fault
	dw isr_00
	dw 0x0008  ; Code segment
	db 0  ; IST - 0 as currently unused
       	db 10001110b
	dw 0
	dq 0

	; Entry 1
	dw isr_01
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 2
	dw isr_20
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 3
	dw isr_03
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 4
	dw isr_04
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 5
	dw isr_05
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 6
	dw isr_06
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 7
	dw isr_07
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 8
	dw isr_08
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 9
	dw isr_09
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry a
	dw isr_0a
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry b
	dw isr_0b
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry c
	dw isr_0c
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry d
	dw isr_0d
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry e
	dw isr_0e
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry f
	dw isr_0f
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 10
	dw isr_10
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 11
	dw isr_11
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 12
	dw isr_12
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 13
	dw isr_13
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 14
	dw isr_14
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 15
	dw isr_15
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 16
	dw isr_16
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 17
	dw isr_17
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 18
	dw isr_18
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 19
	dw isr_19
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 1a
	dw isr_1a
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 1b
	dw isr_1b
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 1c
	dw isr_1c
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 1d
	dw isr_1d
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 1e
	dw isr_1e
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 1f
	dw isr_1f
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 20
	dw isr_20
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 21
	dw isr_21
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 22
	dw isr_22
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 23
	dw isr_23
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 24
	dw isr_24
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 25
	dw isr_25
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 26
	dw isr_26
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 27
	dw isr_27
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 28
	dw isr_28
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 29
	dw isr_29
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 2a
	dw isr_2a
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 2b
	dw isr_2b
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 2c
	dw isr_2c
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 2d
	dw isr_2d
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 2e
	dw isr_2e
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 2f
	dw isr_2f
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 30
	dw isr_30
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 31
	dw isr_31
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 32
	dw isr_32
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 33
	dw isr_33
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 34
	dw isr_34
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 35
	dw isr_35
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 36
	dw isr_36
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 37
	dw isr_37
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 38
	dw isr_38
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 39
	dw isr_39
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 3a
	dw isr_3a
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 3b
	dw isr_3b
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 3c
	dw isr_3c
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 3d
	dw isr_3d
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 3e
	dw isr_3e
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 3f
	dw isr_3f
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 40
	dw isr_40
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 41
	dw isr_41
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 42
	dw isr_42
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 43
	dw isr_43
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 44
	dw isr_44
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 45
	dw isr_45
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 46
	dw isr_46
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 47
	dw isr_47
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 48
	dw isr_48
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 49
	dw isr_49
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 4a
	dw isr_4a
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 4b
	dw isr_4b
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 4c
	dw isr_4c
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 4d
	dw isr_4d
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 4e
	dw isr_4e
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 4f
	dw isr_4f
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 50
	dw isr_50
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 51
	dw isr_51
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 52
	dw isr_52
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 53
	dw isr_53
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 54
	dw isr_54
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 55
	dw isr_55
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 56
	dw isr_56
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 57
	dw isr_57
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 58
	dw isr_58
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 59
	dw isr_59
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 5a
	dw isr_5a
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 5b
	dw isr_5b
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 5c
	dw isr_5c
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 5d
	dw isr_5d
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 5e
	dw isr_5e
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 5f
	dw isr_5f
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 60
	dw isr_60
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 61
	dw isr_61
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 62
	dw isr_62
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 63
	dw isr_63
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 64
	dw isr_64
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 65
	dw isr_65
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 66
	dw isr_66
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 67
	dw isr_67
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 68
	dw isr_68
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 69
	dw isr_69
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 6a
	dw isr_6a
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 6b
	dw isr_6b
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 6c
	dw isr_6c
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 6d
	dw isr_6d
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 6e
	dw isr_6e
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 6f
	dw isr_6f
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 70
	dw isr_70
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 71
	dw isr_71
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 72
	dw isr_72
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 73
	dw isr_73
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 74
	dw isr_74
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 75
	dw isr_75
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 76
	dw isr_76
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 77
	dw isr_77
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 78
	dw isr_78
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 79
	dw isr_79
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 7a
	dw isr_7a
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 7b
	dw isr_7b
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 7c
	dw isr_7c
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 7d
	dw isr_7d
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 7e
	dw isr_7e
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 7f
	dw isr_7f
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 80
	dw isr_80
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 81
	dw isr_81
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 82
	dw isr_82
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 83
	dw isr_83
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 84
	dw isr_84
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 85
	dw isr_85
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 86
	dw isr_86
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 87
	dw isr_87
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 88
	dw isr_88
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 89
	dw isr_89
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 8a
	dw isr_8a
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 8b
	dw isr_8b
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 8c
	dw isr_8c
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 8d
	dw isr_8d
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 8e
	dw isr_8e
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 8f
	dw isr_8f
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 90
	dw isr_90
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 91
	dw isr_91
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 92
	dw isr_92
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 93
	dw isr_93
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 94
	dw isr_94
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 95
	dw isr_95
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 96
	dw isr_96
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 97
	dw isr_97
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 98
	dw isr_98
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 99
	dw isr_99
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 9a
	dw isr_9a
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 9b
	dw isr_9b
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 9c
	dw isr_9c
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 9d
	dw isr_9d
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 9e
	dw isr_9e
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry 9f
	dw isr_9f
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry a0
	dw isr_a0
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry a1
	dw isr_a1
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry a2
	dw isr_a2
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry a3
	dw isr_a3
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry a4
	dw isr_a4
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry a5
	dw isr_a5
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry a6
	dw isr_a6
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry a7
	dw isr_a7
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry a8
	dw isr_a8
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry a9
	dw isr_a9
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry aa
	dw isr_aa
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry ab
	dw isr_ab
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry ac
	dw isr_ac
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry ad
	dw isr_ad
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry ae
	dw isr_ae
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry af
	dw isr_af
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry b0
	dw isr_b0
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry b1
	dw isr_b1
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry b2
	dw isr_b2
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry b3
	dw isr_b3
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry b4
	dw isr_b4
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry b5
	dw isr_b5
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry b6
	dw isr_b6
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry b7
	dw isr_b7
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry b8
	dw isr_b8
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry b9
	dw isr_b9
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry ba
	dw isr_ba
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry bb
	dw isr_bb
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry bc
	dw isr_bc
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry bd
	dw isr_bd
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry be
	dw isr_be
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry bf
	dw isr_bf
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry c0
	dw isr_c0
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry c1
	dw isr_c1
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry c2
	dw isr_c2
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry c3
	dw isr_c3
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry c4
	dw isr_c4
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry c5
	dw isr_c5
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry c6
	dw isr_c6
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry c7
	dw isr_c7
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry c8
	dw isr_c8
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry c9
	dw isr_c9
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry ca
	dw isr_ca
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry cb
	dw isr_cb
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry cc
	dw isr_cc
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry cd
	dw isr_cd
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry ce
	dw isr_ce
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry cf
	dw isr_cf
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry d0
	dw isr_d0
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry d1
	dw isr_d1
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry d2
	dw isr_d2
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry d3
	dw isr_d3
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry d4
	dw isr_d4
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry d5
	dw isr_d5
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry d6
	dw isr_d6
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry d7
	dw isr_d7
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry d8
	dw isr_d8
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry d9
	dw isr_d9
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry da
	dw isr_da
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry db
	dw isr_db
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry dc
	dw isr_dc
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry dd
	dw isr_dd
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry de
	dw isr_de
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry df
	dw isr_df
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry e0
	dw isr_e0
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry e1
	dw isr_e1
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry e2
	dw isr_e2
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry e3
	dw isr_e3
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry e4
	dw isr_e4
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry e5
	dw isr_e5
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry e6
	dw isr_e6
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry e7
	dw isr_e7
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry e8
	dw isr_e8
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry e9
	dw isr_e9
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry ea
	dw isr_ea
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry eb
	dw isr_eb
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry ec
	dw isr_ec
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry ed
	dw isr_ed
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry ee
	dw isr_ee
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry ef
	dw isr_ef
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry f0
	dw isr_f0
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry f1
	dw isr_f1
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry f2
	dw isr_f2
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry f3
	dw isr_f3
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry f4
	dw isr_f4
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry f5
	dw isr_f5
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry f6
	dw isr_f6
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry f7
	dw isr_f7
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry f8
	dw isr_f8
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry f9
	dw isr_f9
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry fa
	dw isr_fa
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry fb
	dw isr_fb
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry fc
	dw isr_fc
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry fd
	dw isr_fd
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry fe
	dw isr_fe
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0

	; Entry ff
	dw isr_ff
	dw 0x0008
	db 0
	db 10001110b
	dw 0
	dq 0
