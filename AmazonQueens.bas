TYPE boardTile
  image AS _FLOAT
  tileColor AS _BYTE
  canMove AS _BYTE
  thingHere AS _BYTE
  needToBeYellow AS _BYTE
END TYPE

_TITLE "Amazon queens: White's turn"

OPEN _CWD$ + "\Dependencies\BoardData\BoardTiling.txt" FOR INPUT AS #1
DO
  lines = lines + 1
  LINE INPUT #1, burn$
LOOP UNTIL EOF(1)
boardHeight = lines
CLOSE #1

OPEN _CWD$ + "\Dependencies\BoardData\BoardTiling.txt" FOR INPUT AS #1
DO
  columns = columns + 1
  INPUT #1, burn$
LOOP UNTIL EOF(1)
boardWidth = columns / lines
CLOSE #1

DIM rawBoardData(1 TO boardWidth, 1 TO boardHeight)

inGame& = _NEWIMAGE(64 + boardWidth * 32, 64 + boardHeight * 32, 32)
SCREEN inGame&
icon& = _LOADIMAGE(_CWD$ + "\Dependencies\Images\FireBoardTile.png")
_ICON icon&
mainMenu& = _LOADIMAGE(_CWD$ + "\Dependencies\Images\game_of_amazons_title.png", 32)
mmPic& = _LOADIMAGE(_CWD$ + "\Dependencies\Images\game_of_amazons_title.png")

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

pieces = 7
DIM borderPieces&(1 TO pieces)
FOR i = 1 TO pieces
  borderPieces&(i) = _LOADIMAGE(_CWD$ + "\Dependencies\Images\Tessalation" + LTRIM$(RTRIM$(STR$(i))) + ".png")
NEXT

DIM boardData(1 TO boardWidth, 1 TO boardHeight) AS boardTile


OPEN _CWD$ + "\Dependencies\BoardData\BoardTiling.txt" FOR INPUT AS #1
FOR x = 1 TO boardHeight
  FOR y = 1 TO boardWidth
    IF EOF(1) THEN
      PRINT "An error has occured parsing:"
      PRINT _CWD$ + "\Dependencies\BoardData\BoardTiling.txt"
      END
    END IF
    INPUT #1, boardData(y, x).tileColor
  NEXT
NEXT
CLOSE #1

OPEN _CWD$ + "\Dependencies\BoardData\PieceLayout.txt" FOR INPUT AS #1
FOR x = 1 TO boardHeight
  FOR y = 1 TO boardWidth
    IF EOF(1) THEN
      PRINT "An error has occured parsing:"
      PRINT _CWD$ + "\Dependencies\BoardData\PieceLayout.txt"
      PRINT "Please make sure that the dimensions match BoardTiling.txt"
      END
    END IF
    INPUT #1, rawBoardData(y, x)
  NEXT
NEXT
CLOSE #1

DO
  turn = 1
  turnPart = 1

  selectedX = 0
  selectedY = 0

  fires = 0

  FOR x = 1 TO boardHeight
    FOR y = 1 TO boardWidth
      boardData(y, x).thingHere = rawBoardData(y, x)
    NEXT
  NEXT

  SCREEN mainMenu&
  leave = 0
  DO
    DO WHILE _MOUSEINPUT
      _LIMIT 100
      mouse_X = _MOUSEX
      mouse_Y = _MOUSEY
      i = _MOUSEINPUT
      IF _MOUSEBUTTON(1) THEN
        IF mouse_X < 250 AND mouse_X > 175 THEN
          IF mouse_Y > 175 AND mouse_Y < 250 THEN
            leave = 1
          END IF
        END IF
        IF mouse_X < 280 AND mouse_X > 140 THEN
          IF mouse_Y > 240 AND mouse_Y < 280 THEN
            REM customize
          END IF
        END IF
        IF mouse_X < 260 AND mouse_X > 165 THEN
          IF mouse_Y > 285 AND mouse_Y < 320 THEN
            LINE (0, 0)-(600, 600), _RGB(0, 0, 0), BF
            DO
              q$ = INKEY$
            LOOP UNTIL INKEY$ = ""
            PRINT "Coded by jojo2357 in qb64"
            PRINT "github: https://github.com/jojo2357"
            PRINT
            PRINT "Game board by jojo"
            PRINT
            PRINT "Home screen and idea thanks to mew_the_pinkmin"
            PRINT
            PRINT "Im sure that xf8b did some lovely work tidying up the"
            PRINT "github, thanks as always for making sure my repos look"
            PRINT "as clean as the programs ;)"
            PRINT
            PRINT "wikipedia: https://en.wikipedia.org/wiki/Game_of_the_Amazons"
            PRINT
            PRINT "Credited gihubs:"
            PRINT "    mew: https://github.com/MewThePinkmin"
            PRINT "     xf: https://github.com/xf8b"
            PRINT
            PRINT "Click on any github and the link will be copied"
            PRINT "to the clipboard"
            PRINT
            PRINT "Press any key to return to main menu"
            DO
              _LIMIT 30
              mouse_X = _MOUSEX
              mouse_Y = _MOUSEY
              i = _MOUSEINPUT
              IF _MOUSEBUTTON(1) THEN
                IF mouse_Y <= 32 AND mouse_Y >= 16 THEN
                  _CLIPBOARD$ = "https://github.com/jojo2357"
                END IF
                IF mouse_Y <= 16 * 16 AND mouse_Y >= 16 * 15 THEN
                  _CLIPBOARD$ = "https://github.com/MewThePinkmin"
                END IF
                IF mouse_Y <= 16 * 17 AND mouse_Y >= 16 * 16 THEN
                  _CLIPBOARD$ = "https://github.com/xf8b"
                END IF
              END IF
            LOOP UNTIL INKEY$ <> ""
            _PUTIMAGE (0, 0), mmPic&
          END IF
        END IF
        IF mouse_X < 250 AND mouse_X > 170 THEN
          IF mouse_Y > 330 AND mouse_Y < 360 THEN
            REM rulez
          END IF
        END IF
        IF mouse_X < 240 AND mouse_X > 180 THEN
          IF mouse_Y > 370 AND mouse_Y < 400 THEN
            SYSTEM
          END IF
        END IF
      END IF
    LOOP
  LOOP UNTIL leave = 1
  SCREEN inGame&
  GOSUB drawBoard
  DO
    _LIMIT 30
    DO WHILE _MOUSEINPUT
      _LIMIT 100
      mouse_X = _MOUSEX
      mouse_Y = _MOUSEY
      IF _MOUSEBUTTON(2) THEN
        IF turnPart = 2 THEN
          FOR xClearer = 1 TO boardWidth
            FOR yClearer = 1 TO boardHeight
              boardData(xClearer, yClearer).needToBeYellow = 0
            NEXT
          NEXT
          turnPart = 1
          GOSUB drawBoard
        END IF
      END IF
      IF _MOUSEBUTTON(1) THEN
        DO
          _LIMIT 50
          i = _MOUSEINPUT
        LOOP UNTIL NOT _MOUSEBUTTON(1)
        clickedX = INT(mouse_X / 32)
        clickedY = INT(mouse_Y / 32)
        SELECT CASE turnPart
          CASE 1
            IF clickedX >= 1 AND clickedX <= boardWidth THEN
              IF clickedY >= 1 AND clickedY <= boardHeight THEN
                IF turn = boardData(clickedX, clickedY).thingHere AND boardData(clickedX, clickedY).canMove = 0 THEN
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
                    IF H_R AND clickedX + xCheckerForGoable <= boardWidth THEN
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
                IF selectedX = clickedX AND clickedY = selectedY THEN
                  FOR xClearer = 1 TO boardWidth
                    FOR yClearer = 1 TO boardHeight
                      boardData(xClearer, yClearer).needToBeYellow = 0
                    NEXT
                  NEXT
                  turnPart = 1
                  GOSUB drawBoard
                ELSEIF boardData(clickedX, clickedY).needToBeYellow = 1 THEN
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
                    IF H_R AND clickedX + xCheckerForGoable <= boardWidth THEN
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



                        IF H_R AND deathCheckX + 1 <= boardWidth THEN
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



                          IF H_R AND deathCheckX + 1 <= boardWidth THEN
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
                    _TITLE "Amazon queens: White's turn"
                  ELSE
                    turn = 2
                    _TITLE "Amazon queens: Black's turn"
                  END IF
                  fires = fires + 1
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
                    gameover = 1
                    SLEEP 60
                    LINE (0, 0)-(_WIDTH, _HEIGHT)
                    CLS
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
  LOOP UNTIL gameover
  gameover = 0
LOOP

drawBoard:
SELECT CASE fires
  CASE IS < 2
    borderToUse& = borderPieces&(1)
  CASE IS < 6
    borderToUse& = borderPieces&(2)
  CASE IS < 10
    borderToUse& = borderPieces&(3)
  CASE IS < 14
    borderToUse& = borderPieces&(4)
  CASE IS < 18
    borderToUse& = borderPieces&(5)
  CASE IS < 22
    borderToUse& = borderPieces&(6)
  CASE ELSE
    borderToUse& = borderPieces&(7)
END SELECT

FOR xDrawer = 0 TO boardWidth + 1
  _PUTIMAGE (xDrawer * 32, 0), borderToUse&
  _PUTIMAGE (xDrawer * 32, 32 + boardHeight * 32), borderToUse&
NEXT
FOR yDrawer = 1 TO boardHeight
  _PUTIMAGE (0, 32 * yDrawer), borderToUse&
  _PUTIMAGE (32 + boardWidth * 32, yDrawer * 32), borderToUse&
NEXT

LINE (32 - 1, 32 - 1)-(32 + 32 * boardWidth, 32 + 32 * boardHeight), , B
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
RETURN

END
