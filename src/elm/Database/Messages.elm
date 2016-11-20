module Database.Messages exposing (..)

{-|
 Messages for using in this module
-}

-- DEFINITIONS


{-|
 Different messages for controls or other things
-}
type Msg
    = NewRepo
    | NewUrl String
    | NewUser String
    | NewPassword String
