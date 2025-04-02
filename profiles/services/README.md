# Stateful actions

In order to recreate the system state, after the pull and the rebuild, these actions are mandatory:

## NextCloud
Maybe, this could be avoided by restoring a database backup.

1.
```bash
nextcloud-occ maintenance:repair --include-expensive
```

2. Administration -> Basic settings -> Files compatibility -> Enable "Enforce Windows Compatibility" 

3. Security -> Password policy -> 12 Minimum password length

4. Apps -> Disable Photos

## Immich
In case of reinstalling/removing the module, keep in mind that tne postgres database has to be deleted too!

```bash
sudo -u postgres psql
```

```sql
DROP DATABASE immich;
DROP USER immich;
```

