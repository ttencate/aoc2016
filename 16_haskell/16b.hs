#!/usr/bin/runghc

import qualified Data.ByteString.Char8 as B

flipBit '0' = '1'
flipBit '1' = '0'
dragonStep bits = B.concat [bits, B.pack "0", B.map flipBit (B.reverse bits)]
fillDisk size seed = B.take size $ until ((>= size) . B.length) dragonStep seed
checksum bits = if odd (B.length bits)
    then bits
    else checksum $ B.reverse $ B.pack $ checksumStep (B.unpack bits) [] where
  checksumStep [] acc = acc
  checksumStep (a:b:bits) acc =
    let bit = if a == b then '1' else '0'
    in checksumStep bits (bit:acc)

main = do
  input <- B.getLine
  B.putStrLn $ checksum $ fillDisk 35651584 input
