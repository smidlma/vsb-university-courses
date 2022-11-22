{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators #-}

module Main where

import Control.Monad (when)
import Control.Monad.IO.Class (MonadIO (liftIO))
import Data.Aeson
import GHC.Generics
import Network.Wai
import Network.Wai.Handler.Warp
import Servant

data User = User
  { userId :: Int,
    name :: String,
    age :: Int,
    email :: String
  }
  deriving (Eq, Show, Generic)

-- Define how to parse User to json
instance ToJSON User

-- Define how to parse json to User
instance FromJSON User

-- GET /users
-- GET /users/:id
-- POST /users
-- PUT /users/:id
-- DELETE /users/:id
type UsersAPI =
  "users" :> Get '[JSON] [User]
    :<|> "users" :> Capture "id" Int :> Get '[JSON] User
    :<|> "users" :> ReqBody '[JSON] User :> Post '[JSON] User
    :<|> "users" :> Capture "id" Int :> ReqBody '[JSON] User :> Put '[JSON] User
    :<|> "users" :> Capture "id" Int :> Delete '[JSON] User

-- ":<|>" => Its just a pattern matching for different routes
-- ":>"   => We can imagine it as "/" in the url

usersServer :: Server UsersAPI
usersServer = findAllHandler :<|> findByIdHandler :<|> createHandler :<|> updateByIdHandler :<|> deleteByIdHandler
  where
    findAllHandler = return users
    findByIdHandler id =
      let result = filter (\x -> id == userId x) users
       in if not (null result) then return (head result) else throwError err404
    createHandler user = liftIO $ do
      putStrLn "Incoming Post on UserAPI ReqBody:"
      print user
      return user
    updateByIdHandler id user = liftIO $ do
      putStrLn $ "Incoming Put on UserAPI userId: " ++ show id ++ " ReqBody:"
      print user
      return user
    deleteByIdHandler id = do
      liftIO $ putStrLn $ "Trying to delete user with userId: " ++ show id ++ "..."
      let deletedUser = filter (\x -> id == userId x) users
      if not (null deletedUser)
        then do
          let u = head deletedUser
          liftIO $ print u
          return u
        else throwError err404

users :: [User]
users =
  [ User 1 "Isaac Newton" 372 "isaac@newton.co.uk",
    User 2 "Albert Einstein" 136 "ae@mc2.org",
    User 3 "John Doe" 39 "doe@mc2.org"
  ]

data Cart = Cart
  { owner :: User,
    content :: String
  }
  deriving (Eq, Show, Generic)

instance ToJSON Cart

instance FromJSON Cart

type CartsAPI = "carts" :> Get '[JSON] [Cart]

type API = UsersAPI :<|> CartsAPI

userApi :: Proxy UsersAPI
userApi = Proxy

app :: Application
app = serve userApi usersServer

main :: IO ()
main = do
  let port = 8080
  putStrLn $ "Running server on port: " ++ show port ++ "..."
  run port app
