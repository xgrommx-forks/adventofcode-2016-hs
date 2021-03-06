module Explode where
import Data.Char
import Data.Maybe
import Data.List

splitEq delim l = case span (/= delim) l of
  (l, []) -> (l, Nothing)
  (l, _:r) -> (l, Just r)

mapFst f (l, r) = (f l, r)
mapSnd f (l, r) = (l, f r)
fmapSnd = mapSnd . fmap
-- fmap instantiated at tuples is mapSnd, but I don't hate whoever's
-- reading this code enough to do that.

splitParens = fmapSnd (mapSnd fromJust . splitEq ')') . splitEq '('

xthing :: String -> (Integer, Integer)
xthing s = case splitEq 'x' s of
  (l, Just r) -> (read l, read r)
  _ -> error ("no x in " ++ show s)

markerize ((len, reps), rest) =
  ((reps, genericTake len rest), genericDrop len rest)
run_marker = markerize . mapFst xthing
unroll_marker = fmapSnd run_marker . splitParens

data Thing = Literal String
           | Repeat Integer String

parse_markers s = case unroll_marker s of
  (lit, Nothing) -> [Literal lit]
  (lit, Just (reptd, rest)) ->
    (Literal lit):(uncurry Repeat reptd):(parse_markers rest)

parse_file = fmap (parse_markers . filter (not . isSpace)) . readFile

thinglen (Literal s) = genericLength s
thinglen (Repeat n s) = n * genericLength s

solve = sum . map thinglen

altlen (Literal s) = genericLength s
altlen (Repeat n s) = n * altsolve (parse_markers s)

altsolve = sum . map altlen
