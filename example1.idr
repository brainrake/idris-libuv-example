module Example1

import IUV

idris_main : IO ()
idris_main = do
  putStrLn "begin"
  setTimeout 1000 $ do
    putStrLn $ "delayed"
  putStrLn "end"

h : FFI_Export FFI_C "build/example1.h" []
h = Fun idris_main "idris_main" $ End
