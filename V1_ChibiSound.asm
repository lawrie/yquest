SoundPort	equ	$600005
ChibiSound:					;NVTTTTTT	Noise Volume Tone 
	and.l #$000000FF,d0
	tst.b d0				;See if d0=0
	beq silent
	
	move.b d0,d3		  		;1CCTLLLL	(Latch - Channel Type DataL
	move.b #%11001111,SoundPort

	and.b  #%00111111,d0			;Get Tone H
	move.b d0,SoundPort

	move.b d3,d0
	and.b #%01000000,d0			;Volume bit
	ror.b #4,d0
	move.b d0,d2				;backup for noise
	eor.b #%11010100,d0 
	move.b d0,SoundPort			;Set Volume

						;1CCTVVVV	(Latch - Channel Type Volume)	
	move.b #%11111111,SoundPort

	btst #7,d3			
	beq ChibiSoundNoNoise	
	
	move.b d3,d0				;Noise Generator seems to be different on Genesis compared to others!
	and.b #%00000111,d0			;Slowest noise is too slow!
	rol #1,d0
	or.b  #%11000001,d0			;Low Noise Freq
	move.b d0,SoundPort
	
	move.b d3,d0
	and.b #%00111000,d0
	ror #3,d0
	move.b d0,SoundPort			;High Noise Freq
	
						;1CCTVVVV	(Latch - Channel Type Volume)	
	move.b #%11011111,SoundPort		;Mute Tone
	move.b #%11100111,SoundPort		;Enable Noise (White - linked to channel 2)
	
	move.b d2,d0				;Noise volume
	eor.b #%11110100,d0 
	move.b d0,SoundPort			;Set Volume
ChibiSoundNoNoise:
	rts

silent:						;Mute Nosie and Tone (Vol 15=mute)
						;1CCTVVVV
	move.b #%11111111,SoundPort		;(Latch - Channel Type Volume)	
	move.b #%11011111,SoundPort		;(Latch - Channel Type Volume)	
	rts
	
