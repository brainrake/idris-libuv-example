module Example3

import IUV

import Control.Monad.Trans

class (Monad m) => MonadCont (m : Type -> Type) where
  callCC : ((a -> m b) -> m a) -> m a

data ContT : Type -> (Type -> Type) -> Type -> Type where
  MkContT : ((a -> m r) -> m r) -> ContT r m a

runContT : ContT r m a -> (a -> m r) -> m r
runContT (MkContT f) k = f k

instance (Monad m) => Functor (ContT r m) where
  map f m = MkContT (\k => runContT m (\a => k $ f a))

instance (Monad m) => Applicative (ContT r m) where
  f <*> v = MkContT (\k => runContT f $ (\g => runContT v (\a => (k $ g a))))
  pure a = MkContT (\k => k a)

instance (Monad m) => Monad (ContT r m) where
  m >>= k = MkContT (\k' => runContT m (\a => runContT (k a) k'))

instance (Monad m) => MonadCont (ContT r m) where
  callCC f = MkContT $ \k => runContT (f $ \a => MkContT $ \_ => k a) k

instance MonadTrans (ContT r) where
  lift m = MkContT (\k => m >>= k)

wait : Int -> ContT () IO ()
wait ms =
  MkContT $ \k =>
    setTimeout ms $ k ()


launch : ContT () IO () -> IO ()
launch cont = runContT cont return

implicit cont_io : IO a -> ContT () IO a
cont_io = lift


main : IO ()
main = do
  launch $ do
    putStrLn "A begin"
    wait 1000
    putStrLn "A end"
  launch $ do
    putStrLn $ "B begin"
    for_ [1, 2, 3] $ \n => do
      putStrLn $ "B wait " ++ show n ++ " begin"
      wait $ 1000 * n
      putStrLn $ "B wait " ++ show n ++ " end"
    putStrLn $ "B end"

h : FFI_Export FFI_C "../out/example3.h" []
h = Fun main "idris_main" $ End
