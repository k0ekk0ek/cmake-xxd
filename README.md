# CMake script to create hex dump file in C include file style

CMake script that is equivalent to `xxd -i input.file > output.file`, useful
for embedding sources when building on operating systems that do not have xxd.

Include the `xxd.cmake` script in your project, the other files are merely for
demonstrating usage.

```
$ cd cmake-xxd
$ mkdir build
$ cmake -G "<generator supported by your platform>" ..
$ cmake --build .
$ ./unhex
$ diff ../hello.c hello.unhex.c
```

There should be no difference between both files.
