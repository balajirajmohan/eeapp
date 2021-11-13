pipeline {

    stages {

   stage('Cloning our Git') {
steps {
git 'https://github.com/balajirajmohan/eeapp.git'
}
}

    stage ('build')  {
        sh "${mvnHome}/bin/mvn package -f eeapp/pom.xml"
    }

    stage ('Docker Build') {
     // Build and push image with Jenkins' docker-plugin
    withDockerServer([uri: "tcp://localhost:4243"]) {
        withDockerRegistry([credentialsId: "dockerhub", url: "https://index.docker.io/v1/"]) {
        image = docker.build("balajirajmohanbr/spring", "eeapp")
        image.push()
        }
      }
    }
	
	stage ('Deploy application') {
		withCredentials([
			usernamePassword(credentialsId: AWS_CREDENTIALS, usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')
		]) {
			echo "NODE_NAME = $NODE_NAME
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
