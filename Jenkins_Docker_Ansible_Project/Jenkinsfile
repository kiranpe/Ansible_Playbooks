pipeline {

   environment {
     DOCKER_REGISTRY='http://registry-1.docker.io'
     CONTAINER='apache'
     VERSION="1.${BUILD_NUMBER}"
     PROD_VERSION="latest"
   }

   parameters {
       choice(name: 'DEPLOY_TO', choices: ['devserver', 'prodserver'], description: 'choose environment')
   }

   agent any
     
    stages {

     stage('Clean old images') {
         steps {
          sh "docker system prune -a -f"
         }
     }
     
     stage('build docker image') {
         steps {
           script {
              if (env.GIT_BRANCH == "origin/master") { 
                docker.build("${CONTAINER}:${PROD_VERSION}")
              } else {
                docker.build("${CONTAINER}:${VERSION}")
              }
           }
         }
     }
 
     stage('checking old container') {
        steps {
           sh 'sh check-image.sh'
        }
     }

     stage('Run the container and check the url staus') {
         steps {
          script {
            if (env.GIT_BRANCH == "origin/master") { 
              sh """ansible-playbook ${WORKSPACE}/image-status.yml -e image_version='${env.PROD_VERSION}'"""
            } else {
              sh """ansible-playbook ${WORKSPACE}/image-status.yml -e image_version='${env.VERSION}'"""
            }
          }
         }
     }
    
     stage('Copy SSH key') {
         steps {
           sh 'ansible-playbook -i ${WORKSPACE}/jenkinsci --private-key /sites/privatekey.pem ${WORKSPACE}/push-ssh-key.yml'
         }
     } 
 
     stage('Deployment') {
      parallel {
       stage('Deploy to Dev Server'){
        when {
          expression { return env.GIT_BRANCH == "origin/release" }
          allOf{
             environment ignoreCase: true, name: "DEPLOY_TO", value: "devserver";
          }
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
             sh """ansible-playbook -i ${WORKSPACE}/jenkinsci ${WORKSPACE}/deploy-dev.yml -e 'hub_user=${DOCKER_USER} hub_pass=${DOCKER_PASSWORD} image_version=${env.VERSION}'"""
            }
           }
        }
       }
   
       stage('Deploy to Prod Server'){
        when {
          expression { return env.GIT_BRANCH == "origin/master" }
          allOf{
             environment ignoreCase: true, name: "DEPLOY_TO", value: "prodserver";
          }
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
             sh """ansible-playbook -i ${WORKSPACE}/jenkinsci ${WORKSPACE}/deploy-prod.yml -e 'hub_user=${DOCKER_USER} hub_pass=${DOCKER_PASSWORD} image_version=${env.PROD_VERSION}'"""
            }
           }
        }
       }
      }
     }
   }
}
