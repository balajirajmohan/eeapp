node {
    
    def mvnHome = tool 'Maven3'
    
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
    
    stage ('Kubernetes Deploy') {
        kubernetesDeploy(
            configs: 'MyAwesomeApp/springBootDeploy.yml',
            kubeconfigId: 'K8S',
            enableConfigSubstitution: true
            )
    }
    /*
        stage ('Kubernetes Deploy using Kubectl') {
          sh "kubectl apply -f MyAwesomeApp/springBootDeploy.yml"
    }*/
}

