module Selector where
import System.Environment
import qualified Context00
main = do
    [n] <- getArgs
    case n of
        "Context00" -> Context00.main