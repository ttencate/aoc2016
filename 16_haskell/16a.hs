#!/usr/bin/runghc

flipBit '0' = '1'
flipBit '1' = '0'
dragonStep bits = bits ++ ['0'] ++ map flipBit (reverse bits)
fillDisk size seed = take size $ until ((>= size) . length) dragonStep seed
checksum bits = if odd (length bits)
    then bits
    else checksum $ map checksumBit (pairs bits) where
  checksumBit (a, b) = if a == b then '1' else '0'
  pairs [] = []
  pairs (a:b:bits) = (a, b):(pairs bits)

main = do
  input <- getLine
  putStrLn $ checksum $ fillDisk 272 input
