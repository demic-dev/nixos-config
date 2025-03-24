{ self, config, ... }:
let
  HOSTS = {
    MACBOOK = {
      USER = "micheledecillis";
      HOST = "air";
    };
  };
in 
{
  inherit HOSTS;
}
