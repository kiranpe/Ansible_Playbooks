#Simple web app project
-------------------------

------------------------------------------------------------------------------
|Tools:
|-------
|AWS + Terraform + Docker + Ansible + Jenkins + Git + ShellScripting + HTML
-------------------------------------------------------------------------------

#Once instances creation is done login in to jenkins and do below

#Create credentials in jenkins to login in to docker

#Path: Manage Jenkins > Manage Credentials > Click on Jenkins > Global Credentials > Add Credentials

#username:"your-docker-login" password:"your-docker-pass" ID:"docker-id"

#Install docker plugins 

#Path: Manage Jenkins > Manage Plugins > Avaialble > Search for Docker

#Update the ips in jenkinsci file in release branch and commit to release

#Once it's done set up build with release branch

#Path: New Item > Project Name > Pipeline > Pipeline Script from SCM > Git > Repo URL > release branch > Save

#In first build you will not get deployment options but from second build it will ask for deployment options

#Once dev build is success with release branch the commit the code to master and set up prod build with master branch 

#Path: Same As Dev Build.. use master branch

#V.IMP NOTE: After merging check hosts details in yml files and correct the prodserver if they pointed to devserver

#Don't mess with Jenkinsfile and ymls#
