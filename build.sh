#!/bin/bash
cd "$(dirname "$0")"
mkdir build
rm build/*
set -o verbose

### Produce Idris libuv binding C header file, IUV.h.
idris IUV.idr --interface --codegenonly -o "build/IUV.c" --ibcsubdir "build"

### Compile Idris code to C. Both IUV and Main modules will be in build/example1.c
idris example1.idr --interface --codegenonly -o build/example1.c  --ibcsubdir "build"

### Compile and link all C code, including Idris-compiled-to-C, to produce executable.
gcc -g build/example1.c iuv_c.c -o example1 -luv -I. `idris --include` `idris --link`
