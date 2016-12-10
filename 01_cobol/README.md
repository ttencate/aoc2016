# [Day 1](http://adventofcode.com/2016/day/1) in COBOL

IN THE SPIRIT OF COBOL, THIS README IS BROUGHT TO YOU BY THE CAPS LOCK KEY.
WELL, NOT REALLY, BECAUSE I'M USING VIM AND CAPS LOCK WOULD MESS UP ALL
COMMANDS, SO I'M JUST HOLDING SHIFT INSTEAD.

SO, DAY ONE, IN THE COBOL LANGUAGE. THIS IS SO OLD THAT IT WAS PRETTY MUCH DEAD
BEFORE I WAS BORN. I HAVE NO IDEA WHAT I'M DOING SO I INSTALLED GNUCOBOL. I
FEEL LIKE A MASOCHIST ALREADY. TIMES WILL BE INTERESTING.

Huh, okay. Actually GnuCOBOL is not case sensitive. I will try to enjoy this
little bit of good fortune while it lasts.

I'm using [this COBOL tutorial](https://www.tutorialspoint.com/cobol) to get a
grip on this strange language. The [GNU Cobol Programmer's
Guide](http://open-cobol.sourceforge.net/guides/GNU%20COBOL%202.0%20Programmers%20Guide.pdf)
is also useful. In COBOL, indentation matters, but not in the way you might
think: each column in the program plays a particular role. Vim's built-in COBOL
mode (!) really helps here, by understanding what I'm typing and indenting it
correctly.

Simply want to declare an integer variable? Looks like this: `01 x pic S999.
value +000.`. The `S999` bit means "a sign, followed by three digits"; this
specifies how the variable will be laid out in memory. As a string, unless you
write `usage is computational`, but why should I? This format, sadly, makes
reading the variable-length integers in the input difficult, but I'm not going
to cheat by formatting the input better.
