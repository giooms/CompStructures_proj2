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
    BT(R5, skip_decrement)
    SUBC(R3, 1, R3)         |; sideLength--
skip_decrement:

    PUSH(R3) PUSH(R2) PUSH(R1)
    CALL(drawSquare, 3)     |; Draw square first

    DIVC(R3, 2, R5)         |; radius = sideLength / 2
    ADD(R1, R5, R6)         |; xc = xTopLeft + radius
    ADD(R2, R5, R7)         |; yc = yTopLeft + radius

    PUSH(R5) PUSH(R7) PUSH(R6)
    CALL(drawCircleBres, 3) |; Draw circle and get lastPixelCircleX
    MOVE(R0, R6)            |; Save lastPixelCircleX in R6

    SUB(R5, R6, R7)         |; shift = radius - lastPixelCircleX

    CMPLTC(R7, 1, R0)       |; if (shift < 1)
    BT(R0, end_fractal)     |; return if shift too small

    |; Save original values before modifications
    PUSH(R1) PUSH(R2) PUSH(R3) PUSH(R4)

    |; Calculate new parameters
    ADD(R1, R7, R1)         |; new xTopLeft = xTopLeft + shift
    ADD(R2, R7, R2)         |; new yTopLeft = yTopLeft + shift
    SHLC(R7, 1, R0)         |; 2 * shift
    SUB(R3, R0, R3)         |; new sideLength = sideLength - (2 * shift)
    SUBC(R4, 1, R4)         |; new maxDepth = maxDepth - 1

    |; Make recursive call
    PUSH(R4) PUSH(R3) PUSH(R2) PUSH(R1)
    CALL(drawFractal, 4)

    |; Restore original values
    POP(R4) POP(R3) POP(R2) POP(R1)

end_fractal:
    POP(R7) POP(R6) POP(R5) POP(R4) POP(R3) POP(R2) POP(R1)
    POP(BP) POP(LP)
    RTN()

