pipeline {
    agent any

    tools{
        maven 'maven3'
    }

    environment {
        SCANNER_HOME = tool 'sonarqube'
    }

    stages{
        stage('Git Checkout'){
            steps{
                git branch: 'main', url: 'https://github.com/sdadu2206/Multi-Tier-With-SSL-Cert.git'
            }
        }

        stage('Compile'){
            steps{
                sh "mvn compile"
            }
        }

        stage('Test'){
            steps{
                sh "mvn test -DskipTests=true"
            }
        }

        stage('Trivy FS scan'){
            steps{
                sh "trivy Fs --format table -o Fs-report.html ."
            }
        }

        stage('SonarQube Analysis'){
            steps{
                withSonarQubeEnv('sonar'){
                    sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Multitier -Dsonar.projectKey=Multitier -Dsonar.java.binaries=target"
                }
            }
        }

        stage('Build'){
            steps{
                sh "mvn package -DskipTests=true"
            }
        }

        stage('Publish to Nexus'){
            steps{
                withMaven(globalMavenSettingsConfig: 'Maven', jdk: '', maven: 'maven3', mavenSettingsConfig: '', traceability: true){
                    sh "mvn deploy -DskipTests=true"
                }
            }
        }

        stage('Docker Image Build'){
            steps{
                script{
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'Docker'){
                        sh "docker build -t sdadu2206/bankapp:latest ."
                    }
                }
            }
        }

        stage('Trivy Image Scan'){
            steps{
                sh "trivy image --format table -o Fs-report.html sdadu2206/bankapp:latest"
            }
        }

        stage('Docker Image Push'){
            steps{
                script{
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'Docker'){
                        sh "docker push sdadu2206/bankapp:latest"
                    }
                }
            }
        }

        stage('Deploy to k8s'){
            steps{
                writeKubeConfig(cacertificate: '', clusterName: 'devops-cluster', contextName: '', credentialsId: 'k8s-token', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: '<paste_EKS_URL>'){
                    sh "kubectl apply -f ds.yml -n webapps"
                    sleep 30
                }
            }
        }

        stage('Verify Deployment'){
            steps{
                writeKubeConfig(cacertificate: '', clusterName: 'devops-cluster', contextName: '', credentialsId: 'k8s-token', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: '<paste_EKS_URL>'){
                    sh "kubectl get pods -n webapps"
                    sh "kubectl get svc -n webapps"
                }
            }
        }
    }
}