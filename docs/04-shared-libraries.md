# 4. Shared Libraries

Reusable pipeline code lives in the separate **jenkins-shared-lib** repo. It is a *trusted* library: its code runs outside the Groovy sandbox, so only admins may push to it.

## Layout

```text
jenkins-shared-lib/
├── vars/          # global steps, called like buildApp(...)
├── src/           # Groovy classes, imported like org.example.Utils
└── resources/     # files loaded with libraryResource
```

## Registration

Already done by JCasC in `controller/casc/unclassified.yaml` (library name `my-shared-lib`). Update the `remote:` URL to your repo.

Manual alternative: **Manage Jenkins → System → Global Trusted Pipeline Libraries**.

## Usage

```groovy
@Library('my-shared-lib') _

pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                buildApp(name: 'frontend', lang: 'node')
            }
        }
    }
}
```

Pin a version (tag or branch) for stability:

```groovy
@Library('my-shared-lib@v1.0.0') _
```

> `allowVersionOverride` is `false` in JCasC, so only the default version is allowed. Set it to `true` if you want projects to pin tags.

Full example: `examples/Jenkinsfile.shared-lib`.
