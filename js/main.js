import './polyfill/origin'
import Elm from '../elm/Main'

Elm.Main.embed(document.getElementById('elm'), __CONFIG__)