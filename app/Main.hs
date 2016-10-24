module Main where

import Data.Text (Text)
import qualified Data.Text as Text
import qualified Data.Text.IO as Text
import Options.Applicative
import Grammar.Serialize
import Primary

data Command
  = Words
  | Elision

data Options = Options
  { optCommand :: Command
  }

sourcesOptions :: Parser Options
sourcesOptions = pure $ Options Words

elisionOptions :: Parser Options
elisionOptions = pure $ Options Elision

options :: Parser Options
options = subparser
  ( command "sources" (info sourcesOptions
    ( progDesc "Show info for primary sources" ))
  <> command "elision" (info elisionOptions
    ( progDesc "Show words with elision" ))
  )

textShow :: Show a => a -> Text
textShow = Text.pack . show

showWordCounts :: [Group] -> IO ()
showWordCounts x = mapM_ showGroup x
  where
  showGroup g = mapM_ (showSource (groupId g)) (groupSources g) 
  showSource g s = Text.putStrLn $ Text.intercalate " "
    [ g
    , sourceId s
    , "—"
    , textShow . length . filter filterWords $ sourceContents s
    , "words"
    ]
  filterWords (ContentWord w) = True
  filterWords _ = False

showElision :: [Group] -> IO ()
showElision _ = putStrLn "elision"

handleGroups :: ([Group] -> IO ()) -> IO ()
handleGroups f = do
  result <- readGroups
  case result of
    Left x -> putStrLn x
    Right x -> f x

runCommand :: Options -> IO ()
runCommand (Options Words) = handleGroups showWordCounts
runCommand (Options Elision) = handleGroups showElision

main :: IO ()
main = execParser opts >>= runCommand
  where
  opts = info (helper <*> options)
    ( fullDesc
    <> progDesc "Query ancient language texts"
    <> header "query" )
