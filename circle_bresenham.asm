|; drawCircleBres(xc, yc, radius)
|; Draw a circle using Bresenham's algorithm.
|;  @param xc      the x-coordinate of the center of the circle.
|;  @param yc      the y-coordinate of the center of the circle.
|;  @param radius  the radius of the circle.
|;  @return        the x coordinate, using the center of the circle as origin,
|;                 of the last pixel placed (on one of the top right "octant"),
|;                 i.e. the top right pixel of the circle.
drawCircleBres:
    |; Set up stack frame
    PUSH(LP) PUSH(BP)
    MOVE(SP, BP)

    PUSH(R1) PUSH(R2) PUSH(R3) PUSH(R4)
    PUSH(R5) PUSH(R6) PUSH(R7)

    |; Load arguments
    LD(BP, -12, R1)         |; xc
    LD(BP, -16, R2)         |; yc
    LD(BP, -20, R3)         |; radius

    |; Initialize variables
    ADDC(R31, 3, R5)        |; 3
    SHLC(R3, 1, R4)         |; 2 * radius
    SUB(R5, R4, R6)         |; decisionVar = 3 - 2 * radius
    CMOVE(0, R4)            |; circleX = 0
    MOVE(R3, R5)            |; circleY = radius

loop_circle:
    |; Check loop condition: while (circleX <= circleY)
    CMPLE(R4, R5, R7)
    BF(R7, end_circle)

    |; Place pixels for this step
    PUSH(R5) PUSH(R4) PUSH(R2) PUSH(R1)
    CALL(placeCirclePixels, 4)

    |; Update decision variable
    CMPLT(R31, R6, R7)        |; Changed: if (decisionVar > 0)
    BF(R7, update_decision_low)

    |; DecisionVar > 0 case
    SUB(R4, R5, R7)         |; circleX - circleY
    SHLC(R7, 2, R7)         |; 4 * (circleX - circleY)
    ADDC(R7, 10, R7)        |; +10 (constant in Bresenham's algorithm)
    ADD(R6, R7, R6)         |; decisionVar += ...
    SUBC(R5, 1, R5)         |; circleY--
    BR(update_decision_done)

update_decision_low:
    |; DecisionVar <= 0 case
    SHLC(R4, 2, R7)         |; 4 * circleX
    ADDC(R7, 6, R7)         |; +6
    ADD(R6, R7, R6)         |; decisionVar += ...

update_decision_done:
    ADDC(R4, 1, R4)         |; circleX++
    BR(loop_circle)

end_circle:
    |; Return circleX - 1 in R0
    SUBC(R4, 1, R0)

    POP(R7) POP(R6) POP(R5)
    POP(R4) POP(R3) POP(R2) POP(R1)

    POP(BP) POP(LP)
    RTN()

|; placeCirclePixels(xc, yc, circleX, circleY)
|; Place the current pixels of the circle using symmetry.
|; @param xc       the x-coordinate of the center of the circle.
|; @param yc       the y-coordinate of the center of the circle.
|; @param circleX  the x-coordinate of the current pixel to place, using the center of the circle as origin.
|; @param circleY  the y-coordinate of the current pixel to place, using the center of the circle as origin.
placeCirclePixels:

    PUSH(LP) PUSH(BP)
    MOVE(SP, BP)

    PUSH(R1) PUSH(R2) PUSH(R3) PUSH(R4) PUSH(R5)

    LD(BP, -12, R1) |; xc
    LD(BP, -16, R2) |; yc
    LD(BP, -20, R3) |; circleX
    LD(BP, -24, R4) |; circleY

    ADD(R1, R3, R5) |; xc + circleX
    ADD(R2, R4, R0) |; yc + circleY
    PUSH(R0) PUSH(R5)
    CALL(canvas_set_to_1, 2)

    SUB(R1, R3, R5) |; xc - circleX
    ADD(R2, R4, R0) |; yc + circleY
    PUSH(R0) PUSH(R5)
    CALL(canvas_set_to_1, 2)

    ADD(R1, R3, R5) |; xc + circleX
    SUB(R2, R4, R0) |; yc - circleY
    PUSH(R0) PUSH(R5)
    CALL(canvas_set_to_1, 2)

    SUB(R1, R3, R5) |; xc - circleX
    SUB(R2, R4, R0) |; yc + circleY
    PUSH(R0) PUSH(R5)
    CALL(canvas_set_to_1, 2)

    ADD(R1, R4, R5) |; xc + circleY
    ADD(R2, R3, R0) |; yc + circleX
    PUSH(R0) PUSH(R5)
    CALL(canvas_set_to_1, 2)

    SUB(R1, R4, R5) |; xc - circleY
    ADD(R2, R3, R0) |; yc + circleX
    PUSH(R0) PUSH(R5)
    CALL(canvas_set_to_1, 2)

    ADD(R1, R4, R5) |; xc + circleY
    SUB(R2, R3, R0) |; yc - circleX
    PUSH(R0) PUSH(R5)
    CALL(canvas_set_to_1, 2)

    SUB(R1, R4, R5) |; xc - circleY
    SUB(R2, R3, R0) |; yc - circleX
    PUSH(R0) PUSH(R5)
    CALL(canvas_set_to_1, 2)

    POP(R5) POP(R4) POP(R3) POP(R2) POP(R1)

    POP(BP) POP(LP)

    RTN()

