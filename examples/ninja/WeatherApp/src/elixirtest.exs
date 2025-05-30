#!/usr/bin/env elixir

Code.prepend_path(Path.join(__DIR__, ".modules"))

BackendModule.getWeather()
