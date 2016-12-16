-- | Main entry point.

module Main where

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import DOM (DOM())
import DOM.HTML (window)
import DOM.HTML.Types (htmlDocumentToDocument)
import DOM.HTML.Window (document)
import DOM.Node.NonElementParentNode (getElementById)
import DOM.Node.Types (ElementId(..), documentToNonElementParentNode)
import Data.Maybe (Maybe(..))
import Data.Nullable (toMaybe)
import Prelude (Unit, void, pure, bind, unit, (>>=), (<>), (==))
import React (ReactClass)
import React as React
import React.Combinators
import ReactDOM as ReactDOM

--------------------------------------------------------------------------------
-- Types

--------------------------------------------------------------------------------
-- Main entry point

main :: Eff (dom :: DOM, console :: CONSOLE) Unit
main = do
  let app = React.createElement metroClass unit []
  doc <- window >>= document
  mroot <-
    getElementById
      (ElementId "root")
      (documentToNonElementParentNode (htmlDocumentToDocument doc))
  case toMaybe mroot of
    Nothing -> pure unit
    Just root -> void (ReactDOM.render app root)

--------------------------------------------------------------------------------
-- Metro main window

metroClass :: forall props. ReactClass props
metroClass = React.createClass (React.spec [] render)
  where
    render this = do
      props <- React.getProps this
      state <- React.readState this
      pure (text_ "Applications")
