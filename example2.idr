module Example2

import IUV

main : IO ()
main = do
  putStrLn "begin"
  for_ [1..3] $ \n => do
    setTimeout 1000 $ do
      putStrLn $ "delayed " ++ show n
  putStrLn "end"

h : FFI_Export FFI_C "build/example2.h" []
h = Fun main "idris_main" $
    End
