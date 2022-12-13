.data
	chooseColumn: .word 0 0 0 0 0 0 0 
	row1: 	      .word 0 0 0 0 0 0 0 
	row2: 	      .word 0 0 0 0 0 0 0 
	row3: 	      .word 0 0 0 0 0 0 0 
	row4: 	      .word 0 0 0 0 0 0 0 
	row5: 	      .word 0 0 0 0 0 0 0 
	row6: 	      .word 0 0 0 0 0 0 0 
	base: .word 0x10040000
	again: .asciiz "Do you want to play again? \n Press y for Yes and n for No \n" 
	endl: .asciiz "\n"
	
.text

j main
Endgame: #announce that the game has end
	la $a0 again
	addi $v0, $0,4
	syscall
	addi $v0, $0, 12
	syscall
	addi $t0 , $0, 121
	beq $v0 $t0 main
	jr $ra
drawball:
	#272 + 512k
	#272 + 16k
	sw $a1 0($a0)
	sw $a1 4($a0)
	sw $a1 -4($a0)
	sw $a1 128($a0)
	sw $a1 -128($a0)
	sw $a1 124($a0)
	sw $a1 -124($a0)
	sw $a1 132($a0)
	sw $a1 -132($a0)
	jr $ra
background:
	li $t0, 0x10040000
	li $t1, 0x4B6043
	addi $t2, $0,512
	#end at 4092
	colorall:
		slti $1, $t2,4093
		beqz $1, endcolorall
		add $t3, $t0,$t2
		sw $t1 0($t3)
		addi $t2,$t2,4
		j colorall
	endcolorall:
	createhole:
	addi $a1 $0 -1
	addi $t1, $0, 784
		loop1:
			slti $1 $t1 3345
			beqz $1 endloop1
			addi $t2 $0 0
			loop2:
				slti $1 $t2 97
				beqz $1 endloop2
				add $a0 $t0 $t1
				add $a0 $a0 $t2
				addi $sp, $sp, -4
				sw $ra 0($sp)
				jal drawball
				lw $ra 0($sp)
				addi $sp $sp 4
				addi $t2, $t2,16
				j loop2
			endloop2:
			addi $t1 $t1 512
			j loop1
		endloop1:
	jr $ra
plotchoosecolumn:
	#272 + 512k
	#272 + 16k
	addi $t0 $0 272
	addi $t1 $0 0
	add $t3 $0 $s0
	colorchoosecolumn:
		slti $1 $t1 7
		addi $a1, $0, 0
		beqz $1 endcolorchoosecolumn
		lw $t4 0($t3)
		bne $t4 $0 blue
		add $a0 $t0 $0
		addi $a0 $a0 0x10040000
		addi $sp, $sp, -4
		sw $ra 0($sp)
		jal drawball
		lw $ra 0($sp)
		addi $sp $sp 4
		addi $t0 $t0 16
		addi $t3 $t3 4
		addi $t1 $t1 1
		j colorchoosecolumn
		blue:
		beq $t4 $s4 red
		addi $a1 $0 0x005b96
		add $a0 $t0 $0
		addi $a0 $a0 0x10040000
		addi $sp, $sp, -4
		sw $ra 0($sp)
		jal drawball
		lw $ra 0($sp)
		addi $sp $sp 4
		addi $t0 $t0 16
		addi $t3 $t3 4
		addi $t1 $t1 1
		j colorchoosecolumn
		red:
		addi $a1 $0 0xFF0000
		add $a0 $t0 $0
		addi $a0 $a0 0x10040000
		addi $sp, $sp, -4
		sw $ra 0($sp)
		jal drawball
		lw $ra 0($sp)
		addi $sp $sp 4
		addi $t0 $t0 16
		addi $t3 $t3 4
		addi $t1 $t1 1
		j colorchoosecolumn
	endcolorchoosecolumn:
	jr $ra
plothole:
	#272 + 512k
	#272 + 16k
	addi $t0 $0 0x10040000
	sub $t2 $a0 $s0
	addi $t3 $0 28
	div $t2 $t3
	mflo $t2 #row
	mfhi $t3 #column
	sra $t3 $t3 2
	addi $t0, $t0, 272
	findrow:
		slt $1 $0 $t2
		beqz $1 findcolumn
		addi $t0 $t0 512
		addi $t2 $t2 -1
		j findrow
	findcolumn:
		slt $1 $0 $t3
		beqz $1 endfind
		addi $t0 $t0 16
		addi $t3 $t3 -1
		j findcolumn
	endfind:
	lw $t1 0($a0)
	bne $s2 $s4 blueset
	add $a0 $0 $t0
	addi $a1 $0 0xFF0000
	addi $sp $sp -4
	sw $ra 0($sp)
	jal drawball
	lw $ra 0($sp)
	addi $sp $sp 4
	jr $ra 
	blueset:
	add $a0 $0 $t0
	addi $a1 $0 0x005b96
	addi $sp $sp -4
	sw $ra 0($sp)
	jal drawball
	lw $ra 0($sp)
	addi $sp $sp 4
	jr $ra

checkEnd: #check if the game has had a winner or draw yet
	sub $t1, $a0, $s1
	addi $a1 $0 28
	div $t1 $a1
	mflo $t0
	mfhi $t1
	addi $t0 $t0 1
	sra $t1 $t1 2
	addi $t2, $0, 1 #4 is win
	slti $1, $t0, 4
	beq $1 $0 horizontalCheck
	addi $t3, $t0, 1
	addi $t4, $a0, 28
	verticalCheck:
		slti $1, $t3, 6
		beq $1, $0, endverticalCheck
		lw $t5, 0($t4)
		bne $t5, $s2, endverticalCheck
		addi $t2, $t2,1
		addi $t4, $t4, 28
		addi $t3, $t3, 1
		j verticalCheck
	endverticalCheck:
		lw $t5, 0($t4)
		seq $t7, $t5, $s2
		add $t2, $t2, $t7
		slti $1, $t2,4
		bne $1, $0, horizontalCheck
		addi $v0, $0, 1
		jr $ra
	horizontalCheck:
		addi $t2, $0, 1 #4 is win
		addi $t3, $a0, -4
		addi $t4, $a0,4
		addi $t5, $t1 , -1
		addi $t6, $t1 , 1
		addi $a2, $0, -1
		addi $a3, $0, 7
		left:
			slt $1, $a2,$t5
			beq $1, $0, right
			lw $a1, 0($t3)
			bne $a1, $s2, right
			addi $t2 $t2 1
			addi $t5, $t5, -1
			addi $t3, $t3, -4
			j left  
		right:
			slt $1, $t6, $a3
			beq $1 , $0 , endhorizontalCheck
			lw $a1,0($t4)
			bne $a1, $s2, endhorizontalCheck
			addi $t2, $t2, 1
			addi $t6, $t6,1
			addi $t4, $t4,4
			j right
		endhorizontalCheck:
			slti $1, $t2,4
			bne $1, $0, diagonal1Check
			addi $v0, $0, 1
			jr $ra
		diagonal1Check:
			addi $t2, $0, 1 #4 is win
			addi $t3, $a0, -4
			addi $t3, $t3, -28
			addi $t4, $a0,4
			addi $t4, $t4, 28
			addi $t5, $t1 , -1
			addi $t6, $t1 , 1
			addi $t7, $t0, -1
			addi $t8, $t0, 1
			addi $a2, $0, -1
			addi $a3, $0, 7
		leftup:
			slt $s6, $a2,$t5
			slt $s7, $0, $t7
			and $1, $s7, $s6 
			beq $1, $0, rightdown
			lw $a1, 0($t3)
			bne $a1, $s2, rightdown
			addi $t2 $t2 1
			addi $t5, $t5, -1
			addi $t7, $t7, -1
			addi $t3, $t3, -4
			addi $t3, $t3, -28
			j leftup
		rightdown:
			slt $s6,$t6,$a3
			slt $s7, $t8, $a3
			and $1, $s7, $s6 
			beq $1, $0, enddiagonal1Check
			lw $a1, 0($t4)
			bne $a1, $s2, enddiagonal1Check
			addi $t2 $t2 1
			addi $t6, $t6, 1
			addi $t8, $t8, 1
			addi $t4, $t4, 4
			addi $t4, $t4, 28
			j rightdown
		enddiagonal1Check:
			slti $1, $t2,4
			bne $1, $0, diagonal2Check
			addi $v0, $0, 1
			jr $ra
		diagonal2Check:
			addi $t2, $0, 1 #4 is win
			addi $t3, $a0, -4
			addi $t3, $t3, 28
			addi $t4, $a0,4
			addi $t4, $t4, -28
			addi $t5, $t1 , -1
			addi $t6, $t1 , 1
			addi $t7, $t0, 1
			addi $t8, $t0, -1
			addi $a2, $0, -1
			addi $a3, $0, 7
		leftdown:
			slt $s6, $a2,$t5
			slt $s7, $t7, $a3
			and $1, $s7, $s6 
			beq $1, $0, rightup
			lw $a1, 0($t3)
			bne $a1, $s2, rightup
			addi $t2 $t2 1
			addi $t5, $t5, -1
			addi $t7, $t7, 1
			addi $t3, $t3, -4
			addi $t3, $t3, 28
			j leftdown
		rightup:
			slt $s6,$t6,$a3
			slt $s7, $0, $t8
			and $1, $s7, $s6 
			beq $1, $0, enddiagonal2Check
			lw $a1, 0($t4)
			bne $a1, $s2, enddiagonal2Check
			addi $t2 $t2 1
			addi $t6, $t6, 1
			addi $t8, $t8, -1
			addi $t4, $t4, 4
			addi $t4, $t4, -28
			j rightup
		enddiagonal2Check:
			slti $1, $t2,4
			bne $1, $0, drawCheck
			addi $v0, $0, 1
			jr $ra
		drawCheck:
			addi $t1,$0,42
			beq $s3, $t1, draw
			addi $v0, $0, 0
			jr $ra
		draw:
			addi $v0,$0,2
			jr $ra
fall:  #the ball fall down
	addi $s3,$s3,1
	add $t0, $a0, $0
	sll $t0, $t0, 2
	add $t1, $t0, $s1
	addi $t2, $0, 1
	falling:
		slti $1, $t2, 6
		beq $1, $0, endfalling
		addi $t3, $t1, 28
		lw $t3, 0($t3)
		bne $t3, $0, endfalling
		addi $t1, $t1, 28
		addi $t2, $t2, 1
		j falling
	endfalling:
	sw $s2, 0($t1)
	add $v1 $0 $t1
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	add $a0 $0 $t1
	jal plothole
	lw $ra, 0($sp)
	addi $sp, $sp,4
	lw $v0, 0($sp) 
	jr $ra
setDefault: #set the game start
	add $t0, $0, $s0
	addi $t1, $s0, 196
	setDefaultLoop:
		sw $0 0($t0)
		addi $t0 $t0 4
		slt $1 $t0 $t1
		bnez $1 setDefaultLoop
	jr $ra
choose:
	sw $s2 0($s0)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal plotchoosecolumn
	lw $ra, 0($sp)
	addi $sp, $sp,4
	add $t0, $0, $s0
	moveBall:
	li $v0 12
	syscall
	addi $t1, $0, 97
	addi $t2, $0, 100
	sw $0 0($t0)
	beq $v0 $t1 moveleft
	beq $v0 $t2 moveright
	lw $t3 28($t0)
	bne $t3 $0 invalidmove
	sub $v0 $t0 $s0
	sra $v0 $v0 2
	jr $ra
	invalidmove:
	addi $v0 $0 -1
	jr $ra
	moveleft:
	beq $t0 $s0 totheend
	addi $t0 $t0 -4
	sw $s2 0($t0)
	addi $sp $sp -4
	sw $t0 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal plotchoosecolumn
	lw $ra, 0($sp)
	addi $sp, $sp,4
	lw $t0 0($sp)
	addi $sp, $sp,4
	j moveBall
	totheend:
	addi $t0, $s0, 24
	sw $s2 0($t0)
	addi $sp $sp -4
	sw $t0 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal plotchoosecolumn
	lw $ra, 0($sp)
	addi $sp, $sp,4
	lw $t0 0($sp)
	addi $sp, $sp,4
	j moveBall
	moveright:
	addi $t0 $t0 4
	bne $t0 $s1 nottobegin
	add $t0 $0 $s0
	nottobegin:
	sw $s2 0($t0)
	addi $sp $sp -4
	sw $t0 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal plotchoosecolumn
	lw $ra, 0($sp)
	addi $sp, $sp,4
	lw $t0 0($sp)
	addi $sp, $sp,4
	j moveBall
main:
	la $a0 endl
	addi $v0 $0 4
	syscall
	la $s0 chooseColumn #the array chooseColumn in $s0
	la $s1 row1 #the first row in $s1
	addi $s2,$0,1 #$s2 save which player is in turn
	addi $s3,$0,0 #$s3 save the total ball in board
	addi $s4,$0,1 #$s4 just to save the number 1 :))))
	jal setDefault
	jal background
	gameloop:
		jal choose
		slti $1 $v0 0
		bnez $1 gameloop
		add $a0,$0,$v0
		jal fall
		add $a0,$0,$v0
		jal checkEnd
		bne $v0,$0,endgameloop
		beq $s2,$s4,player2
		addi $s2,$0,1
		j gameloop
		player2:
		addi $s2,$0,2
		j gameloop
	endgameloop:
	jal Endgame
end:

