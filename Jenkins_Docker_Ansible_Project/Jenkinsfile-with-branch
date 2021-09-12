pipeline {

   environment {
     DOCKER_REGISTRY='http://registry-1.docker.io'
     CONTAINER='apache'
     VERSION="latest"
   }

   parameters {
       choice(name: 'DEPLOY_TO', choices: ['devserver\nprodserver'], description: 'choose environment')
   }

   agent any
     
    stages {
     
     stage('build docker image') {
         steps {
           script {
                docker.build("${CONTAINER}:${VERSION}")
           }
         }
     }

     stage('Check the staus') {
         steps {
           sh 'ansible-playbook ${WORKSPACE}/image-status.yml'
         }
     }
    
     stage('Copy SSH key to dev server') {
         steps {
           sh 'ansible-playbook -i ${WORKSPACE}/jenkinsci --private-key /sites/privatekey.pem ${WORKSPACE}/push-ssh-key.yml'
         }
     } 
 
     stage('Deployment') {
      parallel {
       stage('Deploy to Dev Server'){
        when {
         expression { return env.GIT_BRANCH == "origin/release" }
        }
        steps {
         withCredentials([
             usernamePassword(
                credentialsId: 'docker-id',
                usernameVariable: 'DOCKER_USER',
                passwordVariable: 'DOCKER_PASSWORD'
             )
           ])
           {
            script {
             echo "deploying to dev server"
             sh 'ansible-playbook -i ${WORKSPACE}/jenkinsci ${WORKSPACE}/deploy-dev.yml -e "hub_user=${DOCKER_USER} hub_pass=${DOCKER_PASSWORD}"'
            }
           }
        }
       }
   
       stage('Deploy to Prod Server'){
        when {
         expression { return env.GIT_BRANCH == "origin/master" }
        } 
        steps {
         withCredentials([
             usernamePassword(
                credentialsId: 'docker-id',
                usernameVariable: 'DOCKER_USER',
                passwordVariable: 'DOCKER_PASSWORD'
             )
           ])
           {
            script {
             echo "deploying to prod server"
             sh 'ansible-playbook -i ${WORKSPACE}/jenkinsci ${WORKSPACE}/deploy-prod.yml -e "hub_user=${DOCKER_USER} hub_pass=${DOCKER_PASSWORD}"'
            }
           }
        }
       }
      }
     }
   }
}
