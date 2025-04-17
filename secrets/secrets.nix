let
  bachSystem = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK7rFUiGulUCjRKMua3OXkAyfnvkZLHwBud4kb37gT83 root@bach";

  micheleAtBach = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjDuFgmRgyjZ/Ye/QiFetZ6r+W9SGB4ufJcxzCF0ALP decillismicheledeveloper@gmail.com";

in
{
  "nextcloud_root_pass.age".publicKeys = [
    bachSystem
    micheleAtBach
  ];

  "cloudflare_dns_challenge.age".publicKeys = [
    bachSystem
    micheleAtBach
  ];

  "miniflux_admin_pass.age".publicKeys = [
    bachSystem
    micheleAtBach
  ];
}
