module IUV

%access export

%include C "iuv_c.h"

uptime : IO Double
uptime = foreign FFI_C "c_uptime" (IO Double)

c_setTimeout : Int -> Raw (IO ()) -> IO ()
c_setTimeout = foreign FFI_C "c_setTimeout" (Int -> Raw (IO ()) -> IO ())

setTimeout : Int -> IO () -> IO ()
setTimeout ms cb = c_setTimeout ms $ MkRaw cb

idris_setTimeout_cb : Raw (IO ()) -> IO ()
idris_setTimeout_cb (MkRaw cb) = cb

h : FFI_Export FFI_C "build/IUV.h" []
h = Fun idris_setTimeout_cb "idris_setTimeout_cb" $
    End
