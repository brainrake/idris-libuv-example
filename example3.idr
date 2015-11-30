module Example3

import IUV

import Control.Monad.Trans
import Cont

delay : Int -> ContT () IO ()
delay n = callCC $ \cont =>
  lift $ setTimeout n (runContT (the (ContT () IO ()) (cont ())) (\_ => return ()))

launch : ContT () IO () -> IO ()
launch cont = runContT cont $ \_=> pure ()

main : IO ()
main = launch $ do
  lift $ putStrLn "begin"
  delay 1000
  lift $ putStrLn "delayed"
  lift $ putStrLn "end"

-- This doesn't work yet.
-- OUTPUT:
-- begin
-- delayed
-- end
-- delayed
-- end

h : FFI_Export FFI_C "../out/example3.h" []
h = Fun main "idris_main" $ End
