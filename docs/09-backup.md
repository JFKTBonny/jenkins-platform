# 9. Backup, Restore and Maintenance

## Backup (encrypted)

```bash
make backup
```

Creates `backups/jenkins_YYYY-MM-DD_HHMM.tar.gz.gpg` (asks for a passphrase).

## Restore

```bash
make restore FILE=backups/jenkins_YYYY-MM-DD_HHMM.tar.gz.gpg
```

Stops Jenkins, replaces the `jenkins_home` volume content, starts Jenkins.

> `secrets/master.key` and `secrets/hudson.util.Secret` decrypt every stored credential. Protect backups like the server itself and never commit them.

## Logs

```bash
make logs                         # Docker
sudo journalctl -u jenkins -f     # package install
```

## Restart

```bash
make restart
./scripts/cli.sh safe-restart     # waits for running builds
```

## Upgrade Jenkins

```bash
make backup
docker compose build --pull
make up
```

Test upgrades on a staging instance first.
