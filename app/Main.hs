{-# OPTIONS_GHC -fno-warn-missing-signatures #-}

module Main where

import Data.Map (Map)
import qualified Data.Map as Map
import qualified Data.Text as Text
import qualified Data.Text.IO as Text
import Options.Applicative hiding (Failure, Success)

import qualified ScriptQueries
import QueryStage
import Grammar.Pretty
import Grammar.Serialize
import qualified Primary

resultsParser :: Parser Int
resultsParser = option auto
  ( long "results"
  <> short 'r'
  <> value 10
  <> metavar "R"
  <> help "Output the first R results or 0 for all"
  )

matchParser :: Parser String
matchParser = strOption
  ( long "match"
  <> short 'm'
  <> value ""
  <> metavar "M"
  <> help "Show output whose value matches M"
  )

queryOptionsParser :: Parser QueryOptions
queryOptionsParser = QueryOptions <$> resultsParser <*> matchParser

data Query = Query
  { queryName :: String
  , queryOptions :: QueryOptions
  }

queryParser :: Parser Query
queryParser = Query <$> name <*> queryOptionsParser
  where
  name = strArgument
    ( metavar "N"
    <> help "Query name"
    )

data Command
  = CommandSources
  | CommandScriptQuery Query
  | CommandList String

options :: Parser Command
options = subparser
  ( command "sources"
    ( info
      (pure CommandSources)
      (progDesc "Show info for primary sources" )
    )
  <> command "script"
    ( info
      (CommandScriptQuery <$> queryParser)
      (progDesc "Query for script properties" )
    )
  <> command "list"
    ( info
      (CommandList <$> (strArgument (value "" <> metavar "C" <> help "Property category")))
      (progDesc "List available queries" )
    )
  )

showWordCounts :: [Primary.Group] -> IO ()
showWordCounts x = mapM_ showGroup x
  where
  showGroup g = mapM_ (showSource (Primary.groupId g)) (Primary.groupSources g)
  showSource g s = Text.putStrLn $ Text.intercalate " "
    [ g
    , Primary.sourceId s
    , "—"
    , textShow . length . filter filterWords $ Primary.sourceContents s
    , "words"
    ]
  filterWords (Primary.ContentWord _) = True
  filterWords _ = False

handleGroups :: ([Primary.Group] -> IO ()) -> IO ()
handleGroups f = do
  result <- readGroups
  case result of
    Left x -> putStrLn x
    Right x -> f x

queryCategories :: Map String (Map String (QueryOptions -> [Primary.Group] -> IO ()))
queryCategories = Map.fromList
  [ ("script", ScriptQueries.queries)
  ]

showCategory :: String -> IO ()
showCategory c = do
  case Map.lookup c queryCategories of
    Just m -> do
      _ <- putStrLn $ c ++ " queries:"
      mapM_ (\x -> putStrLn $ "  " ++ x) $ Map.keys m
    Nothing -> putStrLn $ "Invalid query category: " ++ c

runCommand :: Command -> IO ()
runCommand (CommandSources) = handleGroups showWordCounts
runCommand (CommandScriptQuery (Query n opt)) = case Map.lookup n ScriptQueries.queries of
  Just f -> handleGroups (f opt)
  Nothing -> putStrLn $ "Invalid query name: " ++ n
runCommand (CommandList "") = mapM_ showCategory $ Map.keys queryCategories
runCommand (CommandList c) = showCategory c

main :: IO ()
main = execParser opts >>= runCommand
  where
  opts = info (helper <*> options)
    ( fullDesc
    <> progDesc "Query ancient language texts"
    <> header "query" )
