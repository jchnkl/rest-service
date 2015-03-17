{-# LANGUAGE OverloadedStrings #-}

module Rest.Service (Name, runService) where

import Data.Text.Internal.Lazy (Text)
import Network.Wai.Handler.Warp (Port)
import Network.Wai.Middleware.Cors
import Web.Scotty
import Web.Scotty.Trans (ActionT)
import Rest.Types

type Name = String

runService :: Parsable a => Port -> Name -> (a -> ActionT Text IO ()) -> IO ()
runService port name f = scotty port $ do
    middleware simpleCors
    get (capture resource) $ param "resource" >>= f
    notFound               $ json $ Error 400 "Service Not Found" Nothing
    where resource = "/" ++ name ++ "/:resource"
