with import <nixpkgs> {}; {
   idris_libuv_example_env = stdenv.mkDerivation rec {
     name = "idris_libuv_example_env";
     buildInputs = [ stdenv haskellPackages.idris gmp libuv ];
   };
 }
