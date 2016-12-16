module React.Combinators where

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import DOM (DOM())
import Data.Array as A
import Data.Maybe (Maybe)
import Data.Nullable (Nullable,toMaybe)
import Prelude (Unit, map, (>>=), (<>), (==))
import React (ReactElement)
import React as React
import React.DOM as D
import React.DOM.Props (Props, unsafeFromPropsArray, unsafeMkProps)
import React.DOM.Props as P

--------------------------------------------------------------------------------
-- React combinators

p_ :: Array Props -> Array ReactElement -> ReactElement
p_ = D.p
tbody_ :: Array Props -> Array ReactElement -> ReactElement
tbody_ = D.tbody
thead_ :: Array Props -> Array ReactElement -> ReactElement
thead_ = D.thead
table_ :: Array Props -> Array ReactElement -> ReactElement
table_ = D.table
tr_ :: Array Props -> Array ReactElement -> ReactElement
tr_ = D.tr
th_ :: Array Props -> Array ReactElement -> ReactElement
th_ = D.th
td_ :: Array Props -> Array ReactElement -> ReactElement
td_ = D.td
h1_ :: Array Props -> Array ReactElement -> ReactElement
h1_ = D.h1
h2_ :: Array Props -> Array ReactElement -> ReactElement
h2_ = D.h2
h3_ :: Array Props -> Array ReactElement -> ReactElement
h3_ = D.h3
h4_ :: Array Props -> Array ReactElement -> ReactElement
h4_ = D.h4
a_ :: Array Props -> Array ReactElement -> ReactElement
a_ = D.a
div_ :: Array Props -> Array ReactElement -> ReactElement
div_ = D.div
span_ :: Array Props -> Array ReactElement -> ReactElement
span_ = D.span
code_ :: Array Props -> Array ReactElement -> ReactElement
code_ = D.code
pre_ :: Array Props -> Array ReactElement -> ReactElement
pre_ = D.pre
select_ :: Array Props -> Array ReactElement -> ReactElement
select_ = D.select
option_ :: Array Props -> Array ReactElement -> ReactElement
option_ = D.option
input_ :: Array Props -> ReactElement
input_ props = createElementNoChildren "input" (unsafeFromPropsArray props)
form_ :: Array Props -> Array ReactElement -> ReactElement
form_ = D.form
label_ :: Array Props -> Array ReactElement -> ReactElement
label_ = D.label
button_ :: Array Props -> Array ReactElement -> ReactElement
button_ = D.button
ul_ :: Array Props -> Array ReactElement -> ReactElement
ul_ = D.ul
li_ :: Array Props -> Array ReactElement -> ReactElement
li_ = D.li
strong_ :: Array Props -> Array ReactElement -> ReactElement
strong_ = D.strong
textarea_ :: Array Props -> Array ReactElement -> ReactElement
textarea_ = D.textarea
class_ :: String -> Props
class_ = P.className
text_ :: String -> ReactElement
text_ = D.text
type_ :: String -> Props
type_ = P._type
title_ :: String -> Props
title_ = P.title
href_ :: String -> Props
href_ = P.href
colspan_ :: String -> Props
colspan_ = unsafeMkProps "colSpan"
selected_ :: String -> Props
selected_ = P.selected
disabled_ :: Boolean -> Props
disabled_ = P.disabled

-- | Missing from purescript-react
-- Needed for <input> for which there's no way to express (no
-- children) in purescript-react.
foreign import createElementNoChildren :: forall props.
  React.TagName -> props -> ReactElement

-- | JS function copied from stackoverflow, binding to it here.
foreign import getParameterByName_ ::
  forall eff. String -> Eff (dom :: DOM | eff) (Nullable String)
getParameterByName :: forall eff. String -> Eff (dom :: DOM | eff) (Maybe String)
getParameterByName name = map toMaybe (getParameterByName_ name)

-- Concept borrowed from yesod.
foreign import getPathPieces ::
  forall eff. Eff (dom :: DOM | eff) (Array String)
foreign import setPathPieces ::
  forall eff. String -> Array String -> Eff (dom :: DOM | eff) Unit

-- | May be defined elsewhere.
foreign import onPopState ::
  forall eff a. Eff eff a -> Eff eff Unit

-- | Don't know if missing, can't be bothered looking it up!
dataAttr :: String -> String -> Props
dataAttr suffix = unsafeMkProps ("data-" <> suffix)

-- | Missing from purescript-react
defaultValue :: String -> Props
defaultValue = unsafeMkProps "defaultValue"

-- Missing from purescript-dom
onChange_ :: forall eff props state result.
  (ChangeEvent -> React.EventHandlerContext eff props state result) -> Props
onChange_ f = unsafeMkProps "onChange" (React.handle f)
-- | A change event. We're going to treat it as a pure value.
type ChangeEvent =
  { target :: { value :: String } }

-- onClick which yields the target's value
onCheck_ :: forall eff props state result.
  (CheckEvent -> React.EventHandlerContext eff props state result) -> Props
onCheck_ f = unsafeMkProps "onClick" (React.handle f)
type CheckEvent =
  { target :: { checked :: Boolean } }

foreign import logAnything ::
  forall a eff. a -> Eff (console :: CONSOLE | eff) Unit

foreign import setTimeout ::
  forall eff a. Eff eff a -> Int -> Eff eff Unit

find :: forall a. (a -> Boolean) -> Array a -> Maybe a
find pred arr = A.findIndex pred arr >>= A.index arr

findWithIndex :: forall a. ({index :: Int, value :: a } -> Boolean) -> Array a -> Maybe a
findWithIndex pred arr =
  A.findIndex pred (A.zipWith (\i x -> {index: i, value: x}) (A.range 0 (A.length arr)) arr)
  >>= A.index arr
