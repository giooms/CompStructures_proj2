drawFractal:
    PUSH(LP) PUSH(BP)
    MOVE(SP, BP)
    PUSH(R1) PUSH(R2) PUSH(R3) PUSH(R4) PUSH(R5) PUSH(R6)

    LD(BP, -12, R1)       |; xTopLeft
    LD(BP, -16, R2)       |; yTopLeft
    LD(BP, -20, R3)       |; sideLength
    LD(BP, -24, R4)       |; maxDepth

    |; if (maxDepth == 0) return
    CMPEQC(R4, 0, R5)
    BT(R5, end_fractal)

    |; if sideLength is even, sideLength--
    ANDC(R3, 1, R5)       |; Using R5 for temporary calculations
    CMPEQC(R5, 0, R5)     |; if ((sideLength & 1) == 0)
    BT(R5, skip_decrement)
    SUBC(R3, 1, R3)
skip_decrement:

    |; Draw square
    PUSH(R3) PUSH(R2) PUSH(R1)  |; sideLength, yTopLeft, xTopLeft
    CALL(drawSquare, 3)

    |; Calculate circle parameters
    DIVC(R3, 2, R5)       |; R5 = radius = sideLength/2
    ADD(R1, R5, R6)       |; R6 = xc
    ADD(R2, R5, R0)       |; Use R0 temporarily for yc
    
    |; Draw circle and get intersection
    PUSH(R5) PUSH(R0) PUSH(R6) |; radius, yc, xc
    CALL(drawCircleBres, 3)
    
    |; Calculate shift using R6 for temporary storage
    MOVE(R0, R6)          |; Store drawCircleBres result
    SUB(R5, R6, R5)       |; shift = radius - lastPixelCircleX

    |; if (shift < 1) return
    CMPLTC(R5, 1, R6)
    BT(R6, end_fractal)

    |; Prepare recursive call parameters
    SUBC(R4, 1, R4)       |; maxDepth--
    PUSH(R4)
    SHLC(R5, 1, R6)       |; R6 = 2 * shift
    SUB(R3, R6, R6)       |; sideLength -= 2 * shift
    PUSH(R6)
    ADD(R2, R5, R0)       |; yTopLeft += shift
    PUSH(R0)
    ADD(R1, R5, R0)       |; xTopLeft += shift
    PUSH(R0)

    CALL(drawFractal, 4)

end_fractal:
    POP(R6) POP(R5) POP(R4) POP(R3) POP(R2) POP(R1)
    POP(BP) POP(LP)
    RTN()
