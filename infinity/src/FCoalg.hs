-- F-Coalgebra examples

module FCoalgebra where

-- Stream is the fixed point of StreamF

data StreamF e a = StreamF e a deriving Show

data Stream e = Stream e (Stream e)

instance Functor (StreamF e) where
  fmap :: Functor f => (a -> b) -> f a -> f b
  fmap f (StreamF e a) = StreamF e (f a)

-- Fibonacci numbers

fib :: (Int, Int) -> StreamF Int (Int, Int)
fib (m, n) = StreamF m (n, m + n)

-- Anammorphism
-- For StreamF/Stream, not a generic one like:
--    ana :: Functor f => (a -> f a) -> (a -> Fix f)
--    ana coalg = Fix . fmap (ana coalg) . coalg
ana :: (a -> StreamF e a) -> (a -> Stream e)
ana f = fix . f where
  fix (StreamF e a) = Stream e (ana f a)

takeStream 0 _ = []
takeStream n (Stream e s) = e : takeStream (n - 1) s

fibs = ana fib (0, 1)

-- takeStream 10 fibs
