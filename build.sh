#!/bin/bash
cd "$(dirname "$0")"
mkdir -p build
rm build/*
set -o verbose

### Produce Idris libuv binding C header file, IUV.h.
idris IUV.idr --interface --codegenonly -o "build/IUV.c" --ibcsubdir "build"


#!/bin/bash
for i in `seq 1 3`;
do
  ### Compile Idris code to C. Both IUV and Main modules will be in build/example1.c
  idris example${i}.idr --interface --codegenonly -o build/example${i}.c  --ibcsubdir "build" --dumpdefuns build/example${i}.defuns --dumpcases build/example${i}.cases --noprelude

  ### Compile and link all C code, including Idris-compiled-to-C, to produce executable.
  gcc -g build/example${i}.c iuv_c.c -o example${i} -luv -I. `idris --include` `idris --link`
done

