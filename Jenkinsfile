
pipeline {
    agent any
    stages {
        stage('from JFrog') {
            steps {
                rtDownload(
                    serverId:'financial-app',
                    spec: '''{
                        "files": [
                            {
                                "pattern": "financial-app/financial.jar",
                                "target": "build/libs/financial.jar"
                            }
                        ]
                    }''',
                )
            }
        }

        stage('Downloading Packer and Ansible Config Files') {
            steps {
                git url: 'https://github.com/julianooen/tema-final-01.git'
            }
        }

        stage('Packer execution') {
            environment {
                DOCKERHUB_USERNAME = credentials('dockerHub_username')
                DOCKERHUB_PASSWORD = credentials('dockerHub_password')
            }
            steps {
                sh 'packer init config.pkr.hcl'
                sh 'packer build -var "username=$DOCKERHUB_USERNAME" -var "password=$DOCKERHUB_PASSWORD" config.pkr.hcl'
            }
        }
    }
}
