In order to add a new sensitive variable (so, just hidden in the configuration, but not hidden into the system) to the configuration:

- Add rules to `git-agecrypt.toml`:
```bash
git-agecrypt config add -r "$(cat ~/.ssh/id_ed25519.pub)" -p path/to/secret.1 path/to/secret.2
```

- In case `git add` doesn't work:
```bash
git-agecrypt config add -i ~/.ssh/id_ed25520
```


Reference: [repository](https://github.com/vlaci/git-agecrypt)

