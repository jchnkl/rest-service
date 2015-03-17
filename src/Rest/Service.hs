{-# LANGUAGE OverloadedStrings #-}

module Rest.Service
    ( module Web.Scotty
    , module Web.Scotty.Trans
    , runService
    ) where

import Data.Text.Internal.Lazy (Text)
import Network.Wai.Handler.Warp (Port)
import Network.Wai.Middleware.Cors
import Web.Scotty
import Web.Scotty.Trans (ActionT)
import Rest.Types

runService :: Parsable a => Port -> (a -> ActionT Text IO ()) -> IO ()
runService port f = scotty port $ do
    middleware simpleCors
    get (capture "/:resource") $ param "resource" >>= f
    notFound                   $ json $ Error 400 "Service Not Found" Nothing
