# 2. Installation

## Option A: this repo (recommended)

```bash
cp .env.example .env      # fill in real values
make build
make up
make logs
```

Log in as `admin` with `ADMIN_PASSWORD` from `.env`. The setup wizard is skipped because JCasC configures everything.

## Option B: plain Docker (quick test)

```bash
docker volume create jenkins_home

docker run -d \
  --name jenkins \
  --restart unless-stopped \
  -p 127.0.0.1:8080:8080 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts-jdk21

docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Open `http://localhost:8080`, paste the password, choose **Install suggested plugins**.

## Option C: Ubuntu / Debian package

```bash
./scripts/install-ubuntu.sh
```

The script installs Java 21 and Jenkins LTS, binds Jenkins to `127.0.0.1`, and prints the initial admin password.

> The apt signing key changes occasionally. If `apt update` reports a key error, get the current key URL from jenkins.io/doc/book/installing/linux.
