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

  "cloud/fqdn.age".publicKeys = [
    bachSystem
    micheleAtBach
  ];

  "cloud/email.age".publicKeys = [
    bachSystem
    micheleAtBach
  ];

  "cloud/internal.age".publicKeys = [
    bachSystem
    micheleAtBach
  ];

  "cloud/nextcloud.age".publicKeys = [
    bachSystem
    micheleAtBach
  ];

  "cloud/immich.age".publicKeys = [
    bachSystem
    micheleAtBach
  ];

  "bach/ipv4.age".publicKeys = [
    bachSystem
    micheleAtBach
  ];

  "bach/ipv6.age".publicKeys = [
    bachSystem
    micheleAtBach
  ];

  "bach/gateway.age".publicKeys = [
    bachSystem
    micheleAtBach
  ];
}
