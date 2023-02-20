pipeline {
    agent any
    options{
    ansiColor('xterm')
    }
    stages {
        stage('build'){
            steps{
                dir('./docker') {
                         sh 'docker-compose build'
                         sh 'docker tag ghcr.io/tonysanchez64/hello-terraform-docker/hello-terraform-docker:latest ghcr.io/tonysanchez64/hello-terraform-docker/hello-terraform-docker:1.0.${BUILD_NUMBER}'
                }
                sh 'git tag 1.0.${BUILD_NUMBER}'
                sshagent(['ssh-github']) {
                        sh "git push --tags"
                }
           }
        }
        stage('pacakge'){
            steps {
                withCredentials([string(credentialsId: 'Token_Github', variable:'CR_PAT')]) {
                    sh 'echo $CR_PAT | docker login ghcr.io -u tonysanchez64 --password-stdin'
                }
                sh 'docker push ghcr.io/tonysanchez64/hello-terraform-docker/hello-terraform-docker:1.0.${BUILD_NUMBER}'
                sh 'docker push ghcr.io/tonysanchez64/hello-terraform-docker/hello-terraform-docker:latest'
            }
        }
        

        stage('terraform') {
              steps{
                 withAWS(credentials: 'credenciales-aws', region: 'eu-west-1') {
                    sh 'terraform -chdir=./terraform init'
                    sshagent(['ssh-amazon']) {
                        sh 'terraform -chdir=./terraform apply -auto-approve'
                    }    
                 }
              }
        }
        stage('ansible') {
              steps{
                    withAWS(credentials: 'credenciales-aws', region: 'eu-west-1') {
                             dir('./ansible') {
                                      ansiblePlaybook(credentialsId: 'ssh-amazon', inventory: 'aws_ec2.yml', playbook: 'ec2.yml')
                               
                             }
                    }

                }
             }
        }
   
}
