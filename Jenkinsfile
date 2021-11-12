node {
    
    def mvnHome = tool 'Maven3'
    
    stage ('Checkout') {    
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'e2f1b466-b418-42ac-84a8-b6d6a5857928', url: 'https://github.com/balajirajmohan/eeapp.git']]])   
    
    }
    
    stage ('build')  {
        sh "${mvnHome}/bin/mvn package -f springapp/pom.xml"
    } 
    
    stage ('Docker Build') {
     // Build and push image with Jenkins' docker-plugin
    withDockerServer([uri: "tcp://localhost:4243"]) {
        withDockerRegistry([credentialsId: "dockerhub", url: "https://index.docker.io/v1/"]) {
        image = docker.build("balajirajmohanbr/myspringbootapp", "springapp")
        image.push()    
        }
      }
    }
    
    stage ('Kubernetes Deploy') {
        kubernetesDeploy(
            configs: 'spring/springBootDeploy.yml',
            kubeconfigId: 'K8S',
            enableConfigSubstitution: true
            )
    }
    /*
        stage ('Kubernetes Deploy using Kubectl') {
          sh "kubectl apply -f springapp/springBootDeploy.yml"
    }*/
}
