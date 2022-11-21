{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_first_servant_api (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath



bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/Users/smidlma/University/ing/pfp/first-servant-api/.stack-work/install/aarch64-osx/4c862f21ad967908ba1d81462e9e559b6eeb1477668a0bfda1466102756bd664/9.2.5/bin"
libdir     = "/Users/smidlma/University/ing/pfp/first-servant-api/.stack-work/install/aarch64-osx/4c862f21ad967908ba1d81462e9e559b6eeb1477668a0bfda1466102756bd664/9.2.5/lib/aarch64-osx-ghc-9.2.5/first-servant-api-0.1.0.0-213k49lrYTc6i0QW9rU5xw-first-servant-api-exe"
dynlibdir  = "/Users/smidlma/University/ing/pfp/first-servant-api/.stack-work/install/aarch64-osx/4c862f21ad967908ba1d81462e9e559b6eeb1477668a0bfda1466102756bd664/9.2.5/lib/aarch64-osx-ghc-9.2.5"
datadir    = "/Users/smidlma/University/ing/pfp/first-servant-api/.stack-work/install/aarch64-osx/4c862f21ad967908ba1d81462e9e559b6eeb1477668a0bfda1466102756bd664/9.2.5/share/aarch64-osx-ghc-9.2.5/first-servant-api-0.1.0.0"
libexecdir = "/Users/smidlma/University/ing/pfp/first-servant-api/.stack-work/install/aarch64-osx/4c862f21ad967908ba1d81462e9e559b6eeb1477668a0bfda1466102756bd664/9.2.5/libexec/aarch64-osx-ghc-9.2.5/first-servant-api-0.1.0.0"
sysconfdir = "/Users/smidlma/University/ing/pfp/first-servant-api/.stack-work/install/aarch64-osx/4c862f21ad967908ba1d81462e9e559b6eeb1477668a0bfda1466102756bd664/9.2.5/etc"

getBinDir     = catchIO (getEnv "first_servant_api_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "first_servant_api_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "first_servant_api_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "first_servant_api_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "first_servant_api_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "first_servant_api_sysconfdir") (\_ -> return sysconfdir)




joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
