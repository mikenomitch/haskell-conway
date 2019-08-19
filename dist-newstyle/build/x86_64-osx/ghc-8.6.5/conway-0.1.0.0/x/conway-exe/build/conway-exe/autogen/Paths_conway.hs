{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_conway (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
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
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/mike/.cabal/bin"
libdir     = "/Users/mike/.cabal/lib/x86_64-osx-ghc-8.6.5/conway-0.1.0.0-inplace-conway-exe"
dynlibdir  = "/Users/mike/.cabal/lib/x86_64-osx-ghc-8.6.5"
datadir    = "/Users/mike/.cabal/share/x86_64-osx-ghc-8.6.5/conway-0.1.0.0"
libexecdir = "/Users/mike/.cabal/libexec/x86_64-osx-ghc-8.6.5/conway-0.1.0.0"
sysconfdir = "/Users/mike/.cabal/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "conway_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "conway_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "conway_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "conway_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "conway_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "conway_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
