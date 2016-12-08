PROGRAM eight
      IMPLICIT NONE
      LOGICAL, DIMENSION(6, 50) :: screen
      LOGICAL, DIMENSION(50) :: row
      LOGICAL, DIMENSION(6) :: column
      CHARACTER(LEN=100) :: line, command, direction
      INTEGER :: index, width, height, coord, amount

      screen = SPREAD(SPREAD(.FALSE., 1, 6), 2, 50)
      DO
        READ(*, '(a)', END=100) line
        index = SCAN(line, ' ')
        command = line(1:index - 1)
        line = line(index + 1:)
        IF (command .EQ. 'rect') THEN
          index = SCAN(line, 'x')
          line(index:index) = ','
          READ(line, *) width, height
          screen(1:height, 1:width) = .TRUE.
        ELSE
          index = SCAN(line, ' ')
          direction = line(1:index - 1)
          line = line(index + 3:)
          index = SCAN(line, ' ')
          line(index:index + 3) = ',   '
          READ(line, *) coord, amount
          coord = coord + 1
          IF (direction .EQ. 'row') THEN
            row = screen(coord, :)
            screen(coord, 1:amount) = row(50 + 1 - amount:)
            screen(coord, amount + 1:) = row(:50 - amount)
          ELSE
            column = screen(:, coord)
            screen(1:amount, coord) = column(6 + 1 - amount:)
            screen(amount + 1:, coord) = column(:6 - amount)
          END IF
        END IF
        ! CALL print_screen(screen)
      END DO
100   WRITE(*, *) COUNT(screen)
END PROGRAM

SUBROUTINE print_screen(screen)
      LOGICAL, DIMENSION(6, 50) :: screen
      INTEGER :: row
      DO, row=1,6
        WRITE(*, *) screen(row, :)
      END DO
      WRITE(*, *)
END SUBROUTINE
