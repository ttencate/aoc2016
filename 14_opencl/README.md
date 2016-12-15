# [Day 14](http://adventofcode.com/2016/day/14) in OpenCL

This looks similar to Day 5, and the only way to solve it (as far as I can
think of) is by brute force. Initially, I wanted to do this hashing in OpenCL.
But looking at the example, we only need to compute a few tens of thousands of
MD5 sums, so I planned to port Day 5 to OpenCL instead.

Thus, I adapted my Python solution of Day 5 to this one. We can easily keep the
hashes in memory, and scan through the subsequent 1000 every time we find a
triplet. We could cache the existence of quintuplets, but it's fast enough as
is.

Then part two came along, and everything became 2016 times as slow. It would
take _minutes_ to run. I should have seen this coming. I can afford to wait,
but that's no fun, so OpenCL it is after all. Of course, the program is not
_technically_ written in OpenCL; rather, it's C code using an OpenCL kernel to
do the dirty work. But that's as close as you can get.

I don't have all day to spend on this puzzle, so it's going to be a bit of a
Frankenstein program. I cribbed an MD5 implementation from somewhere, an OpenCL
error string printer from somewhere else, and the basic chain of OpenCL
initialization commands from yet elsewhere.

Then I struggled for hours trying to get the OpenCL program to compile, without
getting sensible errors from `clGetProgramBuildInfo` (thanks NVIDIA!). By
commenting out bits of code, I discovered it had something to do with
double-slash comments, and maybe with preprocessor macros. It took a long while
to find out that _even_ if you pass a "list of lines" to
`clCreateProgramWithSource` (which I did, because I thought it would give me
sensible line numbers), you _still_ need newline characters attached to them.
OpenCL simply concatenates the strings you pass it, without inserting line
endings again.

Another problem for me was understanding how exactly data passing works. Once I
understood that you need to pass a `cl_mem` object, and that this becomes a
pointer argument in OpenCL land, things went smoothly. I did have to write some
library functions like `strcpy` inline because I couldn't figure out quickly
enough how to pass `__constant` and `__global` pointers to them (apart from,
perhaps, declaring the function to take these types of pointers too). Note:
being able to call `printf` from your OpenCL code is a godsend.

At last, the program worked and gave me the right solution in about a second,
about a thousand times faster than the CPU-based Python solution would have
been. Behold the power of the GPU! Seriously, it feels really awesome to be able
to tap into this power so relatively easily. I'll probably be using it at some
future point in my career.
