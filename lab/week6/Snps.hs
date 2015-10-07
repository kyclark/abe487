import System.Environment
import Data.List (nub)
import Control.Monad (when)
import Text.Printf (printf)

-- # --------------------------------------------------
main :: IO ()
main = do
  args <- getArgs
  case (length args) of
    2 -> callSnps args
    _ -> putStrLn "Please provide two sequences."

-- # --------------------------------------------------
callSnps :: [String] -> IO ()
callSnps [s1, s2] = do
  when ((length $ nub $ map length [s1, s2]) > 1) 
    (error "Sequences are not the same length")

  let snps = filter (\(n, x, y) -> x /= y) (zip3 [1..] s1 s2)
  mapM_ descChange snps

  let n = length snps
  printf "Found %s SNP%s\n" (show n) (if n == 1 then "" else "s")

-- # --------------------------------------------------
descChange :: (Int, Char, Char) -> IO ()
descChange (pos, a, b) = printf "Pos %d: %c => %c\n" pos a b
