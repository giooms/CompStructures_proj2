drawFractal:
    PUSH(LP) PUSH(BP)
    MOVE(SP, BP)
    PUSH(R1) PUSH(R2) PUSH(R3) PUSH(R4) PUSH(R5) PUSH(R6) PUSH(R7) PUSH(R8) PUSH(R9)

    LD(BP, -12, R1)       |; xTopLeft
    LD(BP, -16, R2)       |; yTopLeft
    LD(BP, -20, R3)       |; sideLength
    LD(BP, -24, R4)       |; maxDepth

    |; if (maxDepth == 0) return
    CMPEQC(R4, 0, R6)
    BT(R6, end_fractal)

    |; if sideLength is even, sideLength--
    ANDC(R3, 1, R6) |; sideLength & 1
    CMPEQC(R6, 0, R6) |; if ((sideLength & 1) == 0)
    BT(R6, skip_decrement)
    SUBC(R3, 1, R3)
skip_decrement:

    |; Draw square
    PUSH(R3) PUSH(R2) PUSH(R1)    |; sideLength, yTopLeft, xTopLeft
    CALL(drawSquare, 3)

    |; radius = sideLength / 2
    DIVC(R3, 2, R6)
    ADD(R1, R6, R8)        |; xc = xTopLeft + radius
    ADD(R2, R6, R7)        |; yc = yTopLeft + radius
    MOVE(R6, R5)           |; radius = sideLength/2

    |; lastPixelCircleX = drawCircleBres(xc, yc, radius)
    PUSH(R5) PUSH(R7) PUSH(R8)    |; radius, yc, xc
    CALL(drawCircleBres, 3)
    MOVE(R0, R6)

    SUB(R5, R6, R9) |; shift = radius - lastPixelCircleX

    |; if (shift < 1) return
    CMPLTC(R9, 1, R6)
    BT(R6, end_fractal)

    |; New parameters for recursive fractal
    SUBC(R4, 1, R6)         |; maxDepth--
    PUSH(R6)
    SHLC(R9, 1, R6)         |; 2 * shift
    SUB(R3, R6, R6)         |; sideLength -= 2 * shift
    PUSH(R6)
    ADD(R2, R9, R6)         |; yTopLeft += shift
    PUSH(R6)
    ADD(R1, R9, R6)         |; xTopLeft += shift
    PUSH(R6)

    |; Recursive call: maxDepth, sideLength, yTopLeft, xTopLeft
    CALL(drawFractal,4)

end_fractal:
    POP(R9) POP(R8) POP(R7) POP(R6) POP(R5) POP(R4) POP(R3) POP(R2) POP(R1)
    POP(BP) POP(LP)
    RTN()
