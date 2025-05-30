defmodule BackendModule do






def getWeather do

  cast("network", "..")

end


def cast(bin, loc) do

  {output, 0} = System.cmd(Path.join(Path.expand(loc, __DIR__), bin), [])
  IO.write(output)

end






end
