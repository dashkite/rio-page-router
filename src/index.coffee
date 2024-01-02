import { generic } from "@dashkite/joy/generic"
import * as Type from "@dashkite/joy/type"
import * as Fn from "@dashkite/joy/function"
import * as K from "@dashkite/katana/async"
import Registry from "@dashkite/helium"

# this is what we want to be able to do
_browse = ( specifier ) ->
  router = await Registry.get "router"
  router.browse specifier

browse = generic name: "Router.browse"

# if we get an object, pass it in directly
generic browse,
  Type.isObject,
  ( specifier ) ->
    K.peek -> _browse specifier

# if we get a function, 
# use it to generate the specifier
# based on the value on the stack
generic browse,
  Type.isFunction,
  ( specifier ) ->
    K.peek Fn.pipe [
      specifier
      _browse
    ]

Router =

  browse: browse

export default Router