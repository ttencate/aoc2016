       identification division.
       program-id. 01a.

       environment division.
       input-output section.
       file-control.
           select inputfile assign to keyboard
           organization is line sequential.

       data division.
       file section.
       fd inputfile is external
           record is varying in size
           data record is input-line.
           01 input-line pic A(999).
       working-storage section.
           01 idx pic 999 value 001.
           01 len pic 9.
           01 lr pic A.
           01 distance pic 999.
           01 done pic 9 value 0.

           01 x pic S999 value +000.
           01 y pic S999 value +000.
           01 total-distance pic 999.
           01 direction pic 9 value 1.

       procedure division.
       main.
           open input inputfile.
           read inputfile.
           close inputfile.

           perform until done = 1
             perform read-command
             perform apply-command
           end-perform

           move function abs(x) to x.
           move function abs(y) to y.
           add x to y giving total-distance. 
           display total-distance.

           stop run.

       read-command.
           move input-line(idx:1) to lr.
           if lr <> "R" and lr <> "L" then
             move 1 to done
           end-if.
           add 1 to idx.
           move 0 to len.
           perform until input-line(idx + len:1) = "," or
                         input-line(idx + len:1) = " "
             add 1 to len
           end-perform.
           move '   ' to distance.
           move input-line(idx:len) to distance.
           add len to idx.
           add 2 to idx.

       apply-command.
           if lr = "R" then
             add 1 to direction
           else
             subtract 1 from direction
           end-if.
           if direction = 5 then
             move 1 to direction
           end-if.
           if direction = 0 then
             move 4 to direction
           end-if.

           perform distance times
             if direction = 1 then
               add 1 to y
             end-if
             if direction = 2 then
               add 1 to x
             end-if
             if direction = 3 then
               subtract 1 from y
             end-if
             if direction = 4 then
               subtract 1 from x
             end-if
           end-perform.
