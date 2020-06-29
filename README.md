Mod free_lj_mem

free lua / luaJIT used memory by repeating in x minutes collectgarbage()

As it is also possible to just run a lua command with
* /lua collectgarbage()
* //lua collectgarbage() -- (when WorldEdit true)
sure admin is not on all time, so mod will helpo in beginning with shorter breaks to find out where the used memory is most time, so later can be adjusted to longer breaks unteil new cleanup.

The result of collectgarbage() can be set
* on or off
to bee reportet in
* log, terminal
for starting learn about own server, and set "easier" later

A Warning can be set
* on / off
to a specific amount of
* luamaxmem (should be set then to maybe 10% under lowest OOM accured)
into
* log / terminal or player (to set name)
to notify about possible OOM

the loading message can also be set
* on / off



Idea from stop_lt_OOM
but as it is very laggy, every second scan for mem bigger then x, this version safe cpu time and can maybe get more functions later. So this mod uses less cpu time

a settings.lua will follow in further step,
also choose how to notice it, if yes / no


Thomas Wiegand (minetest.one)
my first mod
so shure a lot things missing

License: LGPL v3.0
