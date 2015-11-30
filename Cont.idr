module Cont

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
  callCC f = MkContT (\k => runContT (f (\a => MkContT (\_ => k a))) k)

instance MonadTrans (ContT r) where
  lift m = MkContT (\k => m >>= k)
