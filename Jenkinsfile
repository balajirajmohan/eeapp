#!groovy

pipeline {
    agent any

    stages {
        stage ('Code checkout from scm') {
            steps {
                script {
                    echo "NODE_NAME = $NODE_NAME"
                    git 'https://github.com/balajirajmohan/eeapp.git'
                }
            }
        }

        stage ('Building the app') {
            steps {
                script {
                    echo "NODE_NAME = $NODE_NAME"
                    sh """
                        ${mvnHome}/bin/mvn package -f eeapp/pom.xml
                    """
                }
            }
        }

        // stage ('Docker image build and push') {
        //     steps {
        //         withDockerServer([uri: "tcp://localhost:4243"]) {
        //             withDockerRegistry([credentialsId: "dockerhub", url: "https://index.docker.io/v1/"]) {
        //                 script {
        //                     image = docker.build("balajirajmohanbr/spring", "eeapp")
        //                     image.push()
        //                 }
        //             }
        //         }
        //     }
        // }

        stage ('Docker image build and push') {
            environment {
                DOCKER_CREDS = credentials('dockerhub')
            }
            steps {
                script {
                    echo "NODE_NAME = $NODE_NAME"
                    sh """
                        cd eeapp/ 
                        docker login -u "$DOCKER_CREDS_USR" -p "$DOCKER_CREDS_PSW"
                        docker build -t balajirajmohanbr/spring .
                        docker push balajirajmohanbr/spring
                    """
                }
            }
        }

        stage ('Deploy application') {
            steps {
                withCredentials([
			        usernamePassword(credentialsId: "AWS_CREDENTIALS", usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')
		        ]) {
                    script {
                        echo "NODE_NAME = $NODE_NAME"
			            sh """
				            export AWS_DEFAULT_REGION=eu-west-1
                            aws ssm send-command --targets \"Key=tag:Name,Values=\"application-server\"\" \
                            --document-name AWS-RunShellScript \
                            --parameters commands=\"docker run -d -p 8080:8080 balajirajmohanbr/spring\"
			            """
                    }
                }
            }
        }
    }
}











// pipeline {

//     stages {

//    stage('Cloning our Git') {
// steps {
// git 'https://github.com/balajirajmohan/eeapp.git'
// }
// }

//     stage ('build')  {
//         sh "${mvnHome}/bin/mvn package -f eeapp/pom.xml"
//     }

//     stage ('Docker Build') {
//      // Build and push image with Jenkins' docker-plugin
//     withDockerServer([uri: "tcp://localhost:4243"]) {
//         withDockerRegistry([credentialsId: "dockerhub", url: "https://index.docker.io/v1/"]) {
//         image = docker.build("balajirajmohanbr/spring", "eeapp")
//         image.push()
//         }
//       }
//     }
	
// 	stage ('Deploy application') {
// 		withCredentials([
// 			usernamePassword(credentialsId: AWS_CREDENTIALS, usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')
// 		]) {
// 			echo "NODE_NAME = $NODE_NAME"
// 			sh """
// 				export AWS_DEFAULT_REGION=eu-west-1
//                 aws ssm send-command --targets \"Key=tag:Name,Values=\"application-server\"\" \
//                 --document-name AWS-RunShellScript \
//                 --parameters commands=\"docker run -d -p 8080:8080 balajirajmohanbr/spring\"
// 			"""
// 		}
// 		}
// 	}
// }
