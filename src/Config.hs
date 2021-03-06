module Config(
    editCommand
)
where

import OS(defaultEditCommand, configPath)
import Data.List(isPrefixOf)
import System.IO
import System.Directory
import Text.Printf

-- I can't believe there's no string replace function in the Prelude!
replace target subst orig =
  replace' target subst [] orig
  where 
    replace' _ _ new [] = new
    replace' target subst new rem
      | target `isPrefixOf` rem = new ++ subst ++ drop (length target) rem
      | otherwise = replace' target subst (new ++ [head rem]) (tail rem)

expand command filename = replace "%1" filename command

editCommand :: String -> IO String
editCommand filename = do
  exists <- doesFileExist configPath 
  format <- if exists then readFile configPath else return defaultEditCommand
  return $ expand format filename
