
pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = credentials('dockerhub')
        DOCKERHUB_USERNAME_PSW = credentials('dockerhub')
    }

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

        stage('Download Packer') {
            steps {
                git branch: 'master', url: 'https://github.com/julianooen/tema-final-01.git'
            }
        }

        stage('Packer') {
            steps {
                sh 'packer init config.pkr.hcl'
                sh 'packer build -var "login_username=$DOCKERHUB_USERNAME" -var "login_password=$DOCKERHUB_USERNAME_PSW" config.pkr.hcl'
            }
        }
    }
}
