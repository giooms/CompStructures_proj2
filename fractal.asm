|; drawFractal(xTopLeft, yTopLeft, sideLength, maxDepth)
|; Draw a fractal using squares and circles.
|; @param xTopLeft    the x-coordinate of the top-left corner of the current square.
|; @param yTopLeft    the y-coordinate of the top-left corner of the current square.
|; @param sideLength  the length of the side of the current square.
|; @param maxDepth    the maximum depth of the fractal.
drawFractal:
    PUSH(LP) PUSH(BP)
    MOVE(SP, BP)
    PUSH(R1) PUSH(R2) PUSH(R3) PUSH(R4)

    |; Load parameters
    LD(BP, -12, R1)         |; xTopLeft
    LD(BP, -16, R2)         |; yTopLeft
    LD(BP, -20, R3)         |; sideLength
    LD(BP, -24, R4)         |; maxDepth

    |; Base case check
    CMPEQ(R4, 0, R0)
    BT(R0, end_fractal)

    |; Handle even sideLength
    ANDC(R3, 1, R0)
    BT(R0, skip_decrement)
    SUBC(R3, 1, R3)
skip_decrement:

    |; 1. Draw square first
    PUSH(R3) PUSH(R2) PUSH(R1)
    CALL(drawSquare, 3)

    |; 2. Draw circle inside square
    |; Save ALL values including maxDepth
    PUSH(R1) PUSH(R2) PUSH(R3) PUSH(R4)  |; Save ALL values including maxDepth
    
    |; Calculate circle parameters
    DIVC(R3, 2, R0)         |; radius = sideLength/2
    ADD(R1, R0, R1)         |; xc = xTopLeft + radius
    ADD(R2, R0, R2)         |; yc = yTopLeft + radius
    MOVE(R0, R3)            |; R3 = radius
    
    |; Draw circle
    PUSH(R3) PUSH(R2) PUSH(R1)
    CALL(drawCircleBres, 3)
    MOVE(R0, R5)            |; Save lastPixelCircleX in R5
    
    |; 3. Calculate new square parameters
    |; Restore ALL values
    POP(R4) POP(R3) POP(R2) POP(R1)      |; Restore ALL values
    DIVC(R3, 2, R0)          |; radius = sideLength/2
    SUB(R0, R5, R0)          |; shift = radius - lastPixelCircleX

    |; Check if should continue
    CMPLTC(R0, 1, R5)
    BT(R5, end_fractal)

    |; 4. Make recursive call with new parameters
    PUSH(R0)                |; Save shift
    ADD(R1, R0, R1)         |; new xTopLeft = xTopLeft + shift
    ADD(R2, R0, R2)         |; new yTopLeft = yTopLeft + shift
    POP(R0)                 |; Restore shift
    SHLC(R0, 1, R0)         |; R0 = 2 * shift
    SUB(R3, R0, R3)         |; new sideLength = sideLength - (2 * shift)

    |; After shift calculation
    SUBC(R4, 1, R4)         |; Decrement maxDepth
    |; Don't restore R4 from earlier save, since we want to keep the decremented value

    |; Make recursive call with decremented maxDepth
    PUSH(R4) PUSH(R3) PUSH(R2) PUSH(R1)
    CALL(drawFractal, 4)

end_fractal:
    POP(R4) POP(R3) POP(R2) POP(R1)
    POP(BP) POP(LP)
    RTN()

