module Lib
    ( someFunc
    ) where

import Text.Pandoc
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

someFunc :: IO ()
someFunc = do
    result <- runIO $ do
        doc <- readMarkdown def (T.pack "[google](https://www.google.com/)")
        writeRST def doc
    rst <- handleError result
    TIO.putStrLn rst
