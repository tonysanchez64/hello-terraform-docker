pipeline {
    agent any

    stages {
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
                    sshagent(['ssh-amazon']) {
                         sh 'ansible-playbook -i aws_ec2.yml ec2.yml
                    }
                }
             }
        }
   
    }
}
