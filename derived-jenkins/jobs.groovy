
pipelineJob('job1') {
    definition {
        triggers {
            cron('*/5 * * * *')
        }
        cps {
            concurrentBuild(false)
            sandbox()
            script("""
        node {
          stage('Run job1') {
                sh '''
                    echo hello
                    docker ps -a
                '''
          }
        }
      """.stripIndent())
        }
    }
}
