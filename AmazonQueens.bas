handle& = _NEWIMAGE(600, 600, 32)
SCREEN handle&

TYPE boardTile
  image AS _FLOAT
  tileColor AS _BYTE
  canMove AS _BYTE
  thingHere AS _BYTE
  needToBeYellow AS _BYTE
END TYPE

boardWidth = 6
boardHeight = 6

DIM rawBoardData(1 TO boardWidth, 1 TO boardHeight)

DIM tiles&(1 TO 4)

tiles&(1) = _LOADIMAGE(_CWD$ + "\Dependencies\Images\WhiteBoardTile.png")
tiles&(2) = _LOADIMAGE(_CWD$ + "\Dependencies\Images\BlackBoardTile.png")
tiles&(3) = _LOADIMAGE(_CWD$ + "\Dependencies\Images\PossibleBoardTile.png")
tiles&(4) = _LOADIMAGE(_CWD$ + "\Dependencies\Images\ShootBoardTile.png")


DIM tilePieces&(1 TO 5)
tilePieces&(1) = _LOADIMAGE(_CWD$ + "\Dependencies\Images\WhiteQueen.png")
tilePieces&(2) = _LOADIMAGE(_CWD$ + "\Dependencies\Images\BlackQueen.png")
tilePieces&(3) = _LOADIMAGE(_CWD$ + "\Dependencies\Images\FireBoardTile.png")
tilePieces&(4) = _LOADIMAGE(_CWD$ + "\Dependencies\Images\DeadWhiteQueen.png")
tilePieces&(5) = _LOADIMAGE(_CWD$ + "\Dependencies\Images\DeadBlackQueen.png")


DIM boardData(1 TO boardWidth, 1 TO boardHeight) AS boardTile

FOR x = 1 TO boardHeight
  READ rawBoardData(1, x)
  boardData(1, x).tileColor = rawBoardData(1, x)
  FOR y = 2 TO boardWidth
    READ rawBoardData(y, x)
    boardData(y, x).tileColor = rawBoardData(y, x)
  NEXT
NEXT

FOR x = 1 TO boardHeight
  READ rawBoardData(1, x)
  boardData(1, x).thingHere = rawBoardData(1, x)
  FOR y = 2 TO boardWidth
    READ rawBoardData(y, x)
    boardData(y, x).thingHere = rawBoardData(y, x)
  NEXT
NEXT

turn = 1
turnPart = 1

selectedX = 0
selectedY = 0

GOSUB drawBoard
DO
  _LIMIT 30
  LOCATE 1, 1
  PRINT TIME$
  DO WHILE _MOUSEINPUT
    _LIMIT 100
    mouse_X = _MOUSEX
    mouse_Y = _MOUSEY
    IF _MOUSEBUTTON(1) THEN
      clickedX = INT(mouse_X / 32)
      clickedY = INT(mouse_Y / 32)
      SELECT CASE turnPart
        CASE 1
          IF turn = boardData(clickedX, clickedY).thingHere AND boardData(clickedX, clickedY).canMove = 0 THEN
            IF clickedX >= 1 AND clickedX <= boardWidth THEN
              IF clickedY >= 1 AND clickedY <= boardHeight THEN
                selectedX = clickedX
                selectedY = clickedY
                IF clickedX > 1 AND clickedY > 1 THEN
                  U_L = 1
                ELSE U_L = 0
                END IF

                IF clickedY > 1 THEN
                  U_U = 1
                ELSE U_U = 0
                END IF

                IF clickedX < boardWidth AND clickedY > 1 THEN
                  U_R = 1
                ELSE U_R = 0
                END IF

                IF clickedX < boardWidth THEN
                  H_R = 1
                ELSE H_R = 0
                END IF

                IF clickedX < boardWidth AND clickedY < boardHeight THEN
                  D_R = 1
                ELSE D_R = 0
                END IF

                IF clickedY < boardHeight THEN
                  D_D = 1
                ELSE D_D = 0
                END IF

                IF clickedX > 1 AND clickedY < boardHeight THEN
                  D_L = 1
                ELSE D_L = 0
                END IF

                IF clickedX > 1 THEN
                  H_L = 1
                ELSE H_L = 0
                END IF

                FOR yCheckerForGoable = 1 TO boardWidth
                  IF U_U AND -yCheckerForGoable + clickedY >= 1 THEN
                    IF boardData(clickedX, -yCheckerForGoable + clickedY).thingHere = 0 THEN
                      boardData(clickedX, -yCheckerForGoable + clickedY).needToBeYellow = 1
                    ELSE U_U = 0
                    END IF
                  END IF
                  IF D_D AND yCheckerForGoable + clickedY <= boardHeight THEN
                    IF boardData(clickedX, yCheckerForGoable + clickedY).thingHere = 0 THEN
                      boardData(clickedX, yCheckerForGoable + clickedY).needToBeYellow = 1
                    ELSE D_D = 0
                    END IF
                  END IF
                NEXT

                FOR xCheckerForGoable = 1 TO boardWidth
                  IF H_R AND clickedX + xCheckerForGoable < boardWidth THEN
                    IF boardData(clickedX + xCheckerForGoable, clickedY).thingHere = 0 THEN
                      boardData(clickedX + xCheckerForGoable, clickedY).needToBeYellow = 1
                    ELSE H_R = 0
                    END IF
                  END IF
                  IF H_L AND clickedX - xCheckerForGoable >= 1 THEN
                    IF boardData(clickedX - xCheckerForGoable, clickedY).thingHere = 0 THEN
                      boardData(clickedX - xCheckerForGoable, clickedY).needToBeYellow = 1
                    ELSE H_L = 0
                    END IF
                  END IF
                NEXT

                FOR diagCheckerForGoable = 1 TO boardWidth
                  IF D_R AND clickedX + diagCheckerForGoable <= boardWidth AND clickedY + diagCheckerForGoable <= boardHeight THEN
                    IF boardData(clickedX + diagCheckerForGoable, clickedY + diagCheckerForGoable).thingHere = 0 THEN
                      boardData(clickedX + diagCheckerForGoable, clickedY + diagCheckerForGoable).needToBeYellow = 1
                    ELSE D_R = 0
                    END IF
                  END IF
                  IF D_L AND clickedX - diagCheckerForGoable >= 1 AND clickedY + diagCheckerForGoable <= boardHeight THEN
                    IF boardData(clickedX - diagCheckerForGoable, clickedY + diagCheckerForGoable).thingHere = 0 THEN
                      boardData(clickedX - diagCheckerForGoable, clickedY + diagCheckerForGoable).needToBeYellow = 1
                    ELSE D_L = 0
                    END IF
                  END IF
                  IF U_R AND clickedX + diagCheckerForGoable <= boardWidth AND clickedY - diagCheckerForGoable >= 1 THEN
                    IF boardData(clickedX + diagCheckerForGoable, clickedY - diagCheckerForGoable).thingHere = 0 THEN
                      boardData(clickedX + diagCheckerForGoable, clickedY - diagCheckerForGoable).needToBeYellow = 1
                    ELSE U_R = 0
                    END IF
                  END IF
                  IF U_L AND clickedX - diagCheckerForGoable >= 1 AND clickedY - diagCheckerForGoable >= 1 THEN
                    IF boardData(clickedX - diagCheckerForGoable, clickedY - diagCheckerForGoable).thingHere = 0 THEN
                      boardData(clickedX - diagCheckerForGoable, clickedY - diagCheckerForGoable).needToBeYellow = 1
                    ELSE U_L = 0
                    END IF
                  END IF
                NEXT
                turnPart = 2
                GOSUB drawBoard
              END IF
            END IF
          END IF
        CASE 2
          IF clickedX >= 1 AND clickedX <= boardWidth THEN
            IF clickedY >= 1 AND clickedY <= boardHeight THEN
              IF boardData(clickedX, clickedY).needToBeYellow = 1 THEN
                SWAP boardData(clickedX, clickedY).thingHere, boardData(selectedX, selectedY).thingHere
                FOR xClearer = 1 TO boardWidth
                  FOR yClearer = 1 TO boardHeight
                    boardData(xClearer, yClearer).needToBeYellow = 0
                  NEXT
                NEXT
                IF clickedX > 1 AND clickedY > 1 THEN
                  U_L = 1
                ELSE U_L = 0
                END IF

                IF clickedY > 1 THEN
                  U_U = 1
                ELSE U_U = 0
                END IF

                IF clickedX < boardWidth AND clickedY > 1 THEN
                  U_R = 1
                ELSE U_R = 0
                END IF

                IF clickedX < boardWidth THEN
                  H_R = 1
                ELSE H_R = 0
                END IF

                IF clickedX < boardWidth AND clickedY < boardHeight THEN
                  D_R = 1
                ELSE D_R = 0
                END IF

                IF clickedY < boardHeight THEN
                  D_D = 1
                ELSE D_D = 0
                END IF

                IF clickedX > 1 AND clickedY < boardHeight THEN
                  D_L = 1
                ELSE D_L = 0
                END IF

                IF clickedX > 1 THEN
                  H_L = 1
                ELSE H_L = 0
                END IF

                FOR yCheckerForGoable = 1 TO boardWidth
                  IF U_U AND -yCheckerForGoable + clickedY >= 1 THEN
                    IF boardData(clickedX, -yCheckerForGoable + clickedY).thingHere = 0 THEN
                      boardData(clickedX, -yCheckerForGoable + clickedY).needToBeYellow = 1
                    ELSE U_U = 0
                    END IF
                  END IF
                  IF D_D AND yCheckerForGoable + clickedY <= boardHeight THEN
                    IF boardData(clickedX, yCheckerForGoable + clickedY).thingHere = 0 THEN
                      boardData(clickedX, yCheckerForGoable + clickedY).needToBeYellow = 1
                    ELSE D_D = 0
                    END IF
                  END IF
                NEXT

                FOR xCheckerForGoable = 1 TO boardWidth
                  IF H_R AND clickedX + xCheckerForGoable < boardWidth THEN
                    IF boardData(clickedX + xCheckerForGoable, clickedY).thingHere = 0 THEN
                      boardData(clickedX + xCheckerForGoable, clickedY).needToBeYellow = 1
                    ELSE H_R = 0
                    END IF
                  END IF
                  IF H_L AND clickedX - xCheckerForGoable >= 1 THEN
                    IF boardData(clickedX - xCheckerForGoable, clickedY).thingHere = 0 THEN
                      boardData(clickedX - xCheckerForGoable, clickedY).needToBeYellow = 1
                    ELSE H_L = 0
                    END IF
                  END IF
                NEXT
                FOR diagCheckerForGoable = 1 TO boardWidth
                  IF D_R AND clickedX + diagCheckerForGoable <= boardWidth AND clickedY + diagCheckerForGoable <= boardHeight THEN
                    IF boardData(clickedX + diagCheckerForGoable, clickedY + diagCheckerForGoable).thingHere = 0 THEN
                      boardData(clickedX + diagCheckerForGoable, clickedY + diagCheckerForGoable).needToBeYellow = 1
                    ELSE D_R = 0
                    END IF
                  END IF
                  IF D_L AND clickedX - diagCheckerForGoable >= 1 AND clickedY + diagCheckerForGoable <= boardHeight THEN
                    IF boardData(clickedX - diagCheckerForGoable, clickedY + diagCheckerForGoable).thingHere = 0 THEN
                      boardData(clickedX - diagCheckerForGoable, clickedY + diagCheckerForGoable).needToBeYellow = 1
                    ELSE D_L = 0
                    END IF
                  END IF
                  IF U_R AND clickedX + diagCheckerForGoable <= boardWidth AND clickedY - diagCheckerForGoable >= 1 THEN
                    IF boardData(clickedX + diagCheckerForGoable, clickedY - diagCheckerForGoable).thingHere = 0 THEN
                      boardData(clickedX + diagCheckerForGoable, clickedY - diagCheckerForGoable).needToBeYellow = 1
                    ELSE U_R = 0
                    END IF
                  END IF
                  IF U_L AND clickedX - diagCheckerForGoable >= 1 AND clickedY - diagCheckerForGoable >= 1 THEN
                    IF boardData(clickedX - diagCheckerForGoable, clickedY - diagCheckerForGoable).thingHere = 0 THEN
                      boardData(clickedX - diagCheckerForGoable, clickedY - diagCheckerForGoable).needToBeYellow = 1
                    ELSE U_L = 0
                    END IF
                  END IF
                NEXT
                turnPart = 3
                GOSUB drawBoard
              END IF
            END IF
          END IF
        CASE 3
          IF clickedX >= 1 AND clickedX <= boardWidth THEN
            IF clickedY >= 1 AND clickedY <= boardHeight THEN
              IF boardData(clickedX, clickedY).needToBeYellow = 1 THEN
                FOR xClearer = 1 TO boardWidth
                  FOR yClearer = 1 TO boardHeight
                    boardData(xClearer, yClearer).needToBeYellow = 0
                  NEXT
                NEXT
                boardData(clickedX, clickedY).thingHere = 3
                FOR deathCheckX = 1 TO boardWidth
                  FOR deathChecky = 1 TO boardHeight
                    IF boardData(deathCheckX, deathChecky).thingHere = 1 OR boardData(deathCheckX, deathChecky).thingHere = 2 THEN
                      living = 0
                      IF deathCheckX > 1 AND deathChecky > 1 THEN
                        U_L = 1
                      ELSE U_L = 0
                      END IF

                      IF deathChecky > 1 THEN
                        U_U = 1
                      ELSE U_U = 0
                      END IF

                      IF deathCheckX < boardWidth AND deathChecky > 1 THEN
                        U_R = 1
                      ELSE U_R = 0
                      END IF

                      IF deathCheckX < boardWidth THEN
                        H_R = 1
                      ELSE H_R = 0
                      END IF

                      IF deathCheckX < boardWidth AND deathChecky < boardHeight THEN
                        D_R = 1
                      ELSE D_R = 0
                      END IF

                      IF deathChecky < boardHeight THEN
                        D_D = 1
                      ELSE D_D = 0
                      END IF

                      IF deathCheckX > 1 AND deathChecky < boardHeight THEN
                        D_L = 1
                      ELSE D_L = 0
                      END IF

                      IF deathCheckX > 1 THEN
                        H_L = 1
                      ELSE H_L = 0
                      END IF


                      IF U_U AND -1 + deathChecky >= 1 THEN
                        IF boardData(deathCheckX, -1 + deathChecky).thingHere < 3 THEN
                          living = 1
                        ELSE U_U = 0
                        END IF
                      END IF
                      IF D_D AND 1 + deathChecky <= boardHeight THEN
                        IF boardData(deathCheckX, 1 + deathChecky).thingHere < 3 THEN
                          living = 1
                        ELSE D_D = 0
                        END IF
                      END IF



                      IF H_R AND deathCheckX + 1 < boardWidth THEN
                        IF boardData(deathCheckX + 1, deathChecky).thingHere < 3 THEN
                          living = 1
                        ELSE H_R = 0
                        END IF
                      END IF
                      IF H_L AND deathCheckX - 1 >= 1 THEN
                        IF boardData(deathCheckX - 1, deathChecky).thingHere < 3 THEN
                          living = 1
                        ELSE H_L = 0
                        END IF
                      END IF


                      IF D_R AND deathCheckX + 1 <= boardWidth AND deathChecky + 1 <= boardHeight THEN
                        IF boardData(deathCheckX + 1, deathChecky + 1).thingHere < 3 THEN
                          living = 1
                        ELSE D_R = 0
                        END IF
                      END IF
                      IF D_L AND deathCheckX - 1 >= 1 AND deathChecky + 1 <= boardHeight THEN
                        IF boardData(deathCheckX - 1, deathChecky + 1).thingHere < 3 THEN
                          living = 1
                        ELSE D_L = 0
                        END IF
                      END IF
                      IF U_R AND deathCheckX + 1 <= boardWidth AND deathChecky - 1 >= 1 THEN
                        IF boardData(deathCheckX + 1, deathChecky - 1).thingHere < 3 THEN
                          living = 1
                        ELSE U_R = 0
                        END IF
                      END IF
                      IF U_L AND deathCheckX - 1 >= 1 AND deathChecky - 1 >= 1 THEN
                        IF boardData(deathCheckX - 1, deathChecky - 1).thingHere < 3 THEN
                          living = 1
                        ELSE U_L = 0
                        END IF
                      END IF
                      IF living = 0 THEN
                        boardData(deathCheckX, deathChecky).thingHere = boardData(deathCheckX, deathChecky).thingHere + 3
                      ELSEIF boardData(deathCheckX, deathChecky).canMove = 0 THEN
                        living = 0
                        IF deathCheckX > 1 AND deathChecky > 1 THEN
                          U_L = 1
                        ELSE U_L = 0
                        END IF

                        IF deathChecky > 1 THEN
                          U_U = 1
                        ELSE U_U = 0
                        END IF

                        IF deathCheckX < boardWidth AND deathChecky > 1 THEN
                          U_R = 1
                        ELSE U_R = 0
                        END IF

                        IF deathCheckX < boardWidth THEN
                          H_R = 1
                        ELSE H_R = 0
                        END IF

                        IF deathCheckX < boardWidth AND deathChecky < boardHeight THEN
                          D_R = 1
                        ELSE D_R = 0
                        END IF

                        IF deathChecky < boardHeight THEN
                          D_D = 1
                        ELSE D_D = 0
                        END IF

                        IF deathCheckX > 1 AND deathChecky < boardHeight THEN
                          D_L = 1
                        ELSE D_L = 0
                        END IF

                        IF deathCheckX > 1 THEN
                          H_L = 1
                        ELSE H_L = 0
                        END IF


                        IF U_U AND -1 + deathChecky >= 1 THEN
                          IF boardData(deathCheckX, -1 + deathChecky).thingHere < 1 THEN
                            living = 1
                          ELSE U_U = 0
                          END IF
                        END IF
                        IF D_D AND 1 + deathChecky <= boardHeight THEN
                          IF boardData(deathCheckX, 1 + deathChecky).thingHere < 1 THEN
                            living = 1
                          ELSE D_D = 0
                          END IF
                        END IF



                        IF H_R AND deathCheckX + 1 < boardWidth THEN
                          IF boardData(deathCheckX + 1, deathChecky).thingHere < 1 THEN
                            living = 1
                          ELSE H_R = 0
                          END IF
                        END IF
                        IF H_L AND deathCheckX - 1 >= 1 THEN
                          IF boardData(deathCheckX - 1, deathChecky).thingHere < 1 THEN
                            living = 1
                          ELSE H_L = 0
                          END IF
                        END IF


                        IF D_R AND deathCheckX + 1 <= boardWidth AND deathChecky + 1 <= boardHeight THEN
                          IF boardData(deathCheckX + 1, deathChecky + 1).thingHere < 1 THEN
                            living = 1
                          ELSE D_R = 0
                          END IF
                        END IF
                        IF D_L AND deathCheckX - 1 >= 1 AND deathChecky + 1 <= boardHeight THEN
                          IF boardData(deathCheckX - 1, deathChecky + 1).thingHere < 1 THEN
                            living = 1
                          ELSE D_L = 0
                          END IF
                        END IF
                        IF U_R AND deathCheckX + 1 <= boardWidth AND deathChecky - 1 >= 1 THEN
                          IF boardData(deathCheckX + 1, deathChecky - 1).thingHere < 1 THEN
                            living = 1
                          ELSE U_R = 0
                          END IF
                        END IF
                        IF U_L AND deathCheckX - 1 >= 1 AND deathChecky - 1 >= 1 THEN
                          IF boardData(deathCheckX - 1, deathChecky - 1).thingHere < 1 THEN
                            living = 1
                          ELSE U_L = 0
                          END IF
                        END IF
                        IF living = 0 THEN
                          boardData(deathCheckX, deathChecky).canMove = 1
                        ELSE
                          boardData(deathCheckX, deathChecky).canMove = 0
                        END IF
                      END IF
                    END IF
                  NEXT
                NEXT
                GOSUB drawBoard
                IF turn = 2 THEN
                  turn = 1
                ELSE
                  turn = 2
                END IF
                notGG = 0
                FOR ggCheckX = 1 TO boardWidth
                  FOR ggChecky = 1 TO boardHeight
                    IF boardData(ggCheckX, ggChecky).thingHere = turn AND boardData(ggCheckX, ggChecky).canMove = 0 THEN
                      notGG = 1
                    END IF
                  NEXT
                NEXT
                IF notGG = 0 THEN
                  GOSUB GG
                END IF
                turnPart = 1
              END IF
            END IF
          END IF
      END SELECT
    END IF
    DO UNTIL NOT _MOUSEINPUT
      i = _MOUSEINPUT
    LOOP
  LOOP
LOOP

drawBoard:
LINE (32 - 1, 32 - 1)-(32 + 32 * boardWidth + 1, 32 + 32 * boardHeight + 1), , B
FOR x = 1 TO boardHeight
  FOR y = 1 TO boardWidth
    IF boardData(y, x).needToBeYellow THEN
      _PUTIMAGE (32 * y, 32 * x), tiles&(turnPart + 1)
    ELSE
      boardData(y, x).image = tiles&(boardData(y, x).tileColor)
      _PUTIMAGE (32 * y, 32 * x), boardData(y, x).image
    END IF
  NEXT
NEXT

FOR x = 1 TO boardHeight
  FOR y = 1 TO boardWidth
    IF boardData(y, x).thingHere <> 0 THEN
      _PUTIMAGE (32 * y, 32 * x), tilePieces&(boardData(y, x).thingHere)
    END IF
  NEXT
NEXT
RETURN

GG:
PRINT "Game Over!"
PRINT "Player "; turn; " cannot move and thereore loses!"
END

DATA 1,2,1,2,1,2 'Board tiles
DATA 2,1,2,1,2,1
DATA 1,2,1,2,1,2
DATA 2,1,2,1,2,1
DATA 1,2,1,2,1,2
DATA 2,1,2,1,2,1

DATA 0,0,0,1,0,0  'Queens
DATA 0,0,0,0,0,0
DATA 2,0,0,0,0,0
DATA 0,0,0,0,0,2
DATA 0,0,0,0,0,0
DATA 0,0,1,0,0,0

