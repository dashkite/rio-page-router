import { generic } from "@dashkite/joy/generic"
import * as Type from "@dashkite/joy/type"
import * as Fn from "@dashkite/joy/function"
import * as K from "@dashkite/katana/async"
import Registry from "@dashkite/helium"

map = ( name ) ->

  # this is what we want to be able to do
  _f = ( specifier ) ->
    router = await Registry.get "router"
    router[ name ] specifier

  f = generic name: "Router.#{ name }"

  # if we get an object, pass it in directly
  generic f,
    Type.isObject,
    ( specifier ) ->
      K.peek -> _f specifier

  # if we get a function, 
  # use it to generate the specifier
  # based on the value on the stack
  generic f,
    Type.isFunction,
    ( specifier ) ->
      K.peek Fn.pipe [
        specifier
        _f
      ]

  f

Router =

  browse: map "browse"

  link: map "link"

  back: -> history.back()

export default Router