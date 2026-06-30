let
  micheleAtNixAir = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKUnGzmayiQ8SazjVxi8KPAmgJQQssVbSCpAerMn0Eve";
  users = [ micheleAtNixAir ];

  nixAir = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjIqDJcBd5/kw+kA8DNdM1KB2IZivH17GrIN+wEiTp5";
  systems = [ nixAir ];
in
{
  # "eduroam-conf.age".publicKeys = [];
  # "hotspot-conf.age".publicKeys = [];
  "git-email.age".publicKeys = users ++ systems;
  "noreply-github-email.age".publicKeys = users ++ systems;
  "michele-password.age".publicKeys = users ++ systems;
  "michele-at-nixAir.age".publicKeys = users ++ systems;
}