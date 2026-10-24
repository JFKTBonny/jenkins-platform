# 3. Pipelines

Put a `Jenkinsfile` at the root of your application repo. Ready-made examples are in `examples/`:

| File | Shows |
|---|---|
| `Jenkinsfile.minimal` | Smallest useful declarative pipeline |
| `Jenkinsfile.full` | options, parameters, environment, triggers, when, input, post |
| `Jenkinsfile.credentials` | Username/password, secret text, SSH key, secret file |
| `Jenkinsfile.parallel` | Parallel stages |
| `Jenkinsfile.docker-agent` | Whole pipeline in a Docker image |
| `Jenkinsfile.multi-agent` | Different agent per stage |
| `Jenkinsfile.error-handling` | retry, timeout, catchError |
| `Jenkinsfile.script-block` | Groovy logic, capturing command output |
| `Jenkinsfile.triggers` | cron and upstream triggers |
| `Jenkinsfile.downstream` | Triggering another job with parameters |
| `Jenkinsfile.env-vars` | Built-in environment variables |
| `Jenkinsfile.scripted` | Scripted (non-declarative) pipeline |
| `Jenkinsfile.multibranch` | Branch, PR and tag conditions |
| `Jenkinsfile.secure-pr` | Keeping secrets away from PR builds |
| `Jenkinsfile.secrets-quiet` | Correct quoting and hiding commands |
| `Jenkinsfile.k8s-agent` | Restricted Kubernetes build pod |
| `Jenkinsfile.shared-lib` | Using the trusted shared library |

## Declarative skeleton

```groovy
pipeline {
    agent any            // or: none, label 'x', docker {...}, kubernetes {...}
    options { }          // timeout, buildDiscarder, timestamps, disableConcurrentBuilds
    parameters { }       // string, choice, booleanParam
    environment { }      // KEY = 'value' or credentials('id')
    triggers { }         // cron, pollSCM, upstream
    stages {
        stage('Name') {
            when { }     // branch, changeRequest, buildingTag, expression, allOf, not
            steps { }    // sh, echo, script { }, withCredentials, retry, timeout
            post { }     // stage-level always/success/failure
        }
    }
    post { }             // always, success, failure, unstable, cleanup
}
```

## Common `when` conditions

```groovy
when { branch 'main' }
when { changeRequest() }
when { buildingTag() }
when { expression { params.ENV == 'prod' } }
when { allOf { branch 'main'; not { changeRequest() } } }
when { anyOf { branch 'main'; branch 'release/*' } }
```

## Windows agents

Use `bat 'command'` (or `powershell 'command'`) instead of `sh`.
