{ conf, ... }:
{
  security.sudo = {
    enable = true;
    execWheelOnly = true;
  };
}
