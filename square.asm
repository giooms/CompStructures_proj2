|; drawSquare(xTopLeft, yTopLeft, sideLength)
|; Draw a square on the canvas.
|; @param xTopLeft    the x-coordinate of the top-left corner of the square.
|; @param yTopLeft    the y-coordinate of the top-left corner of the square.
|; @param sideLength  the length of the side of the square (in number of pixels).
drawSquare:
    PUSH(LP) PUSH(BP)
    MOVE(SP, BP)
    PUSH(R1) PUSH(R2) PUSH(R3) PUSH(R4) PUSH(R5) PUSH(R6)

    LD(BP, -12, R1)       |; xTopLeft
    LD(BP, -16, R2)       |; yTopLeft
    LD(BP, -20, R3)       |; sideLength

    |; Calculate boundaries and store in R4/R5
    ADDC(R1, -1, R4)      |; R4 = xTopLeft + sideLength - 1 (xBottomRight)
    ADD(R4, R3, R4)
    ADDC(R2, -1, R5)      |; R5 = yTopLeft + sideLength - 1 (yBottomRight) 
    ADD(R5, R3, R5)

    MOVE(R2, R3)          |; R3 = yTopLeft (reusing R3 since sideLength no longer needed)
loop_y:
    CMPLE(R3, R5, R6)     |; while (y <= yBottomRight)
    BF(R6, end_y)

    MOVE(R1, R6)          |; R6 = xTopLeft (reusing R6)
loop_x:
    CMPLE(R6, R4, R0)     |; while (x <= xBottomRight), using R0 temporarily
    BF(R0, end_x)

    |; Border check using R0 for temporary comparisons
    CMPEQ(R6, R1, R0)     |; x == xTopLeft
    BT(R0, draw_pixel)
    CMPEQ(R6, R4, R0)     |; x == xBottomRight
    BT(R0, draw_pixel)
    CMPEQ(R3, R2, R0)     |; y == yTopLeft
    BT(R0, draw_pixel)
    CMPEQ(R3, R5, R0)     |; y == yBottomRight
    BF(R0, skip_pixel)

draw_pixel:
    PUSH(R3) PUSH(R6)     |; canvas_set_to_1(x, y)
    CALL(canvas_set_to_1, 2)

skip_pixel:
    ADDC(R6, 1, R6)       |; x++
    BR(loop_x)
end_x:
    ADDC(R3, 1, R3)       |; y++
    BR(loop_y)
end_y:
    POP(R6) POP(R5) POP(R4) POP(R3) POP(R2) POP(R1)
    POP(BP) POP(LP)
    RTN()
