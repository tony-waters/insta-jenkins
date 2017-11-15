pipelineJob('clone1') {
    logRotator{
        numToKeep 10
    }
    definition {
        environmentVariables {
            env('VERSION', "1.0")
        }
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/tony-waters/clone1.git')
                    }
                    branch("master")
                }
            }
            triggers {
                scm('* * * * *')
            }
            scriptPath('Jenkinsfile')
        }
    }
}