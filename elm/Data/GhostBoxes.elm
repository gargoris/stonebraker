module Data.GhostBoxes exposing (..)

import Data.MainData exposing (GhostBox, SortedEntry)


{-
   Get one ghost box and return another one with the elements correctly sorted
-}


resortGhostBox : GhostBox m n -> GhostBox m n
resortGhostBox gb =
    gb
