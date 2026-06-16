let
  bachSystem = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK7rFUiGulUCjRKMua3OXkAyfnvkZLHwBud4kb37gT83";

  micheleAtBach = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjDuFgmRgyjZ/Ye/QiFetZ6r+W9SGB4ufJcxzCF0ALP";

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

  # Backups
  "backup_passphrase.age".publicKeys = [
    bachSystem
    micheleAtBach
  ];

  "immich-backup_passphrase.age".publicKeys = [
    bachSystem
    micheleAtBach
  ];

  # Ghost's Secrets
  "ghost-storiedisilicio-env.age".publicKeys = [
    micheleAtBach
    bachSystem
  ];
  "ghost-storiedisilicio-db-env.age".publicKeys = [
    micheleAtBach
    bachSystem
  ];
}
