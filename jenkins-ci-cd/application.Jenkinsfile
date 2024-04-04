pipeline {
    agent any
    environment {
        GITHUB_CREDENTIALS = 'GITHUB_CREDENTIALS'
        ECR_FRONTEND_REPOSITORY = 'public.ecr.aws/z1i5q8e6/hitc-ecr-frontend'
        ECR_BACKEND_REPOSITORY = 'public.ecr.aws/z1i5q8e6/hitc-ecr-backend'
        }
    stages {
        stage('Prepare') {
            steps {
                deleteDir()
            }
        }
        stage('Clone') {
            steps {
                script {
                    dir('Head-In-The-Clouds-Cloud-Project') {
                        git credentialsId: "${env.GITHUB_CREDENTIALS}", url: 'https://github.com/jawadscloud/Head-In-The-Clouds-Cloud-Project.git', branch: 'main'
                    }
                    dir('ce-team-project-frontend') {
                        git credentialsId: "${env.GITHUB_CREDENTIALS}", url: 'https://github.com/northcoders/ce-team-project-frontend.git', branch: 'main'
                    }
                    dir('ce-team-project-backend') {
                        git credentialsId: "${env.GITHUB_CREDENTIALS}", url: 'https://github.com/northcoders/ce-team-project-backend.git', branch: 'main'
                    }
                }
                sh 'ls -l'
            }
        }
        stage('Build') {
            steps {
                script {
                    sh 'aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/z1i5q8e6'
                    dir('ce-team-project-frontend') {
                        sh "docker build --platform=linux/amd64 -t ${ECR_FRONTEND_REPOSITORY}:frontend-1 ."
                        sh "docker push ${ECR_FRONTEND_REPOSITORY}:frontend-1"
                    }
                    dir('ce-team-project-backend') {
                        sh "docker build --platform=linux/amd64 -t ${ECR_BACKEND_REPOSITORY}:backend-1 ."
                        sh "docker push ${ECR_BACKEND_REPOSITORY}:backend-1"
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh 'aws eks --region eu-west-2 update-kubeconfig --name hitc-eks-cluster'
                    def BACKEND_SERVICE = sh(script: "kubectl get svc backend-service -n hitc -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}'", returnStdout: true).trim()
                    def BACKEND_SERVICE_URL = BACKEND_SERVICE + ":8080"
                    dir('Head-In-The-Clouds-Cloud-Project') {
                        dir('helm') {
                            dir('hitc') {
                                dir('templates') {
                                    sh "sed -i 's|value: \"\"|value: \"${BACKEND_SERVICE_URL}\"|g' ./frontend-deployment.yaml"
                                }
                            }
                            sh 'helm upgrade --install hitc ./hitc --namespace hitc --create-namespace'
                        }
                    }
                    sh 'kubectl get pods -n hitc'
                    sh 'kubectl get nodes -n hitc'
                    sh 'kubectl get services -n hitc'
                    sh 'kubectl get deployments -n hitc'
                }
            }
        }
    }
    post {
        always {
            echo 'Cleaning Up...'
        }
        success {
            echo 'Build Succeeded!'
        }
        failure {
            echo 'Build Failed!'
        }
    }
}