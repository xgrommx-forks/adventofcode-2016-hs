module Shell where
import Insn
import Exec
import Parse
import qualified Data.Vector.Unboxed as VU
import qualified Data.Vector.Unboxed.Mutable as VUM

day12 c0 prog =
  launch $ do
    regWrite (Reg 2) c0
    res <- whileOk $ step prog
    case res of
     Halt -> regRead (Reg 0)
     _ -> do
       pc <- getPC
       error $ "Bunny Fault: " ++ show res ++ " at PC " ++ show pc

day23 a0 prog0 =
  launch $ do
    regWrite (Reg 0) a0
    prog <- VU.thaw prog0
    res <- whileOk $ stepMut prog
    case res of
     Halt -> regRead (Reg 0)
     _ -> do
       pc <- getPC
       error $ "Bunny Fault: " ++ show res ++ " at PC " ++ show pc
