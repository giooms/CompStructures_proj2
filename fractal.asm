|; drawFractal(xTopLeft, yTopLeft, sideLength, maxDepth)
|; Draw a fractal using squares and circles.
|; @param xTopLeft    the x-coordinate of the top-left corner of the current square.
|; @param yTopLeft    the y-coordinate of the top-left corner of the current square.
|; @param sideLength  the length of the side of the current square.
|; @param maxDepth    the maximum depth of the fractal.
drawFractal:
    	PUSH(LP) PUSH(BP)
    	MOVE(SP, BP)

    	PUSH(R1) PUSH(R2) PUSH(R3) PUSH(R4) PUSH(R5) PUSH(R6) PUSH(R7)

    	LD(BP, -12, R1)         |; xTopLeft
    	LD(BP, -16, R2)         |; yTopLeft
    	LD(BP, -20, R3)         |; sideLength
    	LD(BP, -24, R4)         |; maxDepth

    	CMPEQ(R4, 0, R5)        |; if (maxDepth == 0)
    	BT(R5, end_fractal)

    	ANDC(R3, 1, R5)         |; if ((sideLength & 1) == 0)
    	BNE(R5, skip_decrement)
    	SUBC(R3, 1, R3)         |; sideLength--
skip_decrement:

    	PUSH(R3) PUSH(R2) PUSH(R1)
    	CALL(drawSquare, 3)

    	DIVC(R3, 2, R5)         |; radius = sideLength / 2
    	ADD(R1, R5, R6)         |; xc = xTopLeft + radius
    	ADD(R2, R5, R7)         |; yc = yTopLeft + radius

    	PUSH(R5) PUSH(R7) PUSH(R6)
    	CALL(drawCircleBres, 3) |; lastPixelCircleX
    	MOVE(R0, R6)

    	SUB(R5, R6, R5)         |; shift = radius - lastPixelCircleX
    	CMPLT(R5, 1, R6)
    	BT(R6, end_fractal)

    	PUSH(R4)
    	SUBC(R3, R5, R3)
    	SUBC(R3, R5, R3)        |; sideLength -= 2 * shift
    	PUSH(R3)

    	ADD(R1, R5, R1)         |; xTopLeft += shift
    	PUSH(R1)

    	ADD(R2, R5, R2)         |; yTopLeft += shift
    	PUSH(R2)

    	SUBC(R4, 1, R4)         |; maxDepth--
    	CALL(drawFractal, 4)

end_fractal:
    	POP(R7) POP(R6) POP(R5) POP(R4) POP(R3) POP(R2) POP(R1)

    	POP(BP) POP(LP)
    	RTN()

