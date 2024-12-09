|; drawSquare(xTopLeft, yTopLeft, sideLength)
|; Draw a square on the canvas.
|; @param xTopLeft    the x-coordinate of the top-left corner of the square.
|; @param yTopLeft    the y-coordinate of the top-left corner of the square.
|; @param sideLength  the length of the side of the square (in number of pixels).
drawSquare:
    PUSH(LP) PUSH(BP)
    MOVE(SP, BP)

    PUSH(R1) PUSH(R2) PUSH(R3) PUSH(R4) PUSH(R5) PUSH(R6) PUSH(R7) PUSH(R8)

    LD(BP, -12, R1)       |; xTopLeft
    LD(BP, -16, R2)       |; yTopLeft
    LD(BP, -20, R3)       |; sideLength

    ADDC(R1, -1, R4)      |; xBottomRight = xTopLeft + sideLength - 1
    ADD(R4, R3, R4)

    ADDC(R2, -1, R5)      |; yBottomRight = yTopLeft + sideLength - 1
    ADD(R5, R3, R5)

    MOVE(R2, R6)          |; y = yTopLeft
loop_y:
    CMPLE(R6, R5, R8)     |; while (y <= yBottomRight)
    BF(R8, end_y)

    MOVE(R1, R7)          |; x = xTopLeft
loop_x:
    CMPLE(R7, R4, R8)     |; while (x <= xBottomRight)
    BF(R8, end_x)

    |; Check if on border: if (x == xTopLeft || x == xBottomRight || y == yTopLeft || y == yBottomRight)
    CMPEQ(R7, R1, R8)     |; x == xTopLeft
    BT(R8, draw_pixel)
    CMPEQ(R7, R4, R8)     |; x == xBottomRight
    BT(R8, draw_pixel)
    CMPEQ(R6, R2, R8)     |; y == yTopLeft
    BT(R8, draw_pixel)
    CMPEQ(R6, R5, R8)     |; y == yBottomRight
    BF(R8, skip_pixel)

draw_pixel:
    PUSH(R6) PUSH(R7)     |; canvas_set_to_1 (x, y)
    CALL(canvas_set_to_1, 2)

skip_pixel:
    ADDC(R7, 1, R7)       |; x++
    BR(loop_x)
end_x:
    ADDC(R6, 1, R6)       |; y++
    BR(loop_y)
end_y:
    POP(R8) POP(R7) POP(R6) POP(R5) POP(R4) POP(R3) POP(R2) POP(R1)
    POP(BP) POP(LP)
    RTN()

