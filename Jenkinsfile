def info(str) {
    echo "\033[1;33m[Info]  "+str+"\033[0m"
}

def error(str) {
    echo "\033[1;31m[Error]  "+str+"\033[0m"
}

def success(str) {
    echo "\033[1;32m[Success]  "+str+"\033[0m"
}


pipeline {
    agent any
    options {
        ansiColor('xterm')
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    BUILD_TRIGGER_BY = "${currentBuild.getBuildCauses()[0].shortDescription}"
                    echo "BUILD_TRIGGER_BY: ${BUILD_TRIGGER_BY}"
                    if  (env.gitlabBranch.equals(null)) {
                        env.gitlabBranch = "demo"
                        env.jtag="demo"
                        info "Setting Branch to "+env.gitlabBranch
                    }else{
                        env.jtag=env.gitlabBranch
                    }
                    checkout changelog: false, scm: [
                        $class: 'GitSCM', branches: [[name: "*/$env.gitlabBranch" ]], 
                        extensions: [], userRemoteConfigs: [[credentialsId: 'GITLAB_TOKEN', 
                        url: 'https://giteam.ap-gw.net/root/cignal-storefront-api.git']]]

                    //sh encoding: 'UTF-8', label: 'Check Downloaded Files', script: 'pwd && ls -lah && curl ipinfo.io/ip && hostname -l'    
                }
            }
        }

        /*stage('BlackDuck Scan') {
            steps {
                script {
                    def scanDirDIND="/var/jenkins_home/tmp/$env.JOB_NAME"
                    def scanDirHOST="/home/ec2-user/jenkins/tmp/$env.JOB_NAME"
                    def composerDIR="/var/jenkins_home/tmp/composer-php8"
                    sh label: 'Prepare for Scan', script: "rm package.json -fr && rm -fr $scanDirDIND || true && cp -r ../$env.JOB_NAME $scanDirDIND"
                    sh label: 'Fix Permission DIND', script: "docker run --rm -v $scanDirHOST:/var/www/html j6wdev/builder:8.1 chmod 777 vendor -R || true"
                    sh label: 'Composer Install', script: "docker run --rm -v $composerDIR:/root/.composer -v $scanDirHOST:/var/www/html j6wdev/builder:8.1 composer update" //
                    sh label: 'Fix Permission DIND', script: "docker run --rm -v $scanDirHOST:/var/www/html j6wdev/builder:8.1 chmod 777 vendor -R || true"
                    // 
                    withCredentials([string(credentialsId: 'BLACKDUCK-TOKEN', variable: 'TOKEN')]) {
                        sh label: 'Start BlackDuck Scan', script: "curl -s -L https://detect.synopsys.com/detect7.sh | bash -s -- --blackduck.url=https://j6winc.app.blackduck.com --blackduck.api.token="+"$TOKEN"+" --detect.project.name=CIGNAL-API --detect.project.version.name=1.0 --detect.code.location.name=CIGNAL-API_1.0 --detect.detector.search.depth=10 --detect.project.version.distribution=INTERNAL --detect.excluded.detector.types=NPM --detect.source.path=$scanDirDIND"
                    }
                }
            }
        }*/
        /* stage('Build Image') {
            steps {
                script {
                    sh encoding: 'UTF-8', label: 'Initialize Dockerfile', script: 'echo "FROM j6wdev/rel:cignal-api" > Dockerfile'  
                    sh encoding: 'UTF-8', label: 'Initialize Dockerfile', script: 'echo "COPY . ." >> Dockerfile' 
                    
                    sh encoding: 'UTF-8', label: 'Initialize Dockerfile', script: 'echo "RUN composer update" >> Dockerfile'  
                    sh encoding: 'UTF-8', label: 'Initialize entrypoint', script: 'echo "#!/bin/bash" > entrypoint.sh'
                    sh encoding: 'UTF-8', label: 'Initialize entrypoint', script: 'echo "chmod 777 storage -R" > entrypoint.sh'
                    sh encoding: 'UTF-8', label: 'Initialize entrypoint', script: 'echo "php-fpm -D && httpd -D FOREGROUND" >> entrypoint.sh' 
                    sh encoding: 'UTF-8', label: 'Initialize entrypoint', script: 'echo "RUN chmod +x entrypoint.sh" >> Dockerfile' 
                    sh encoding: 'UTF-8', label: 'Initialize entrypoint', script: 'echo "ENTRYPOINT /opt/app-root/src/entrypoint.sh" >> Dockerfile'
                    sh encoding: 'UTF-8', label: 'Verify Files', script: 'cat Dockerfile && cat entrypoint.sh'

                    sh encoding: 'UTF-8', label: 'build Docker image', script: 'docker build -t j6wdev/j6w:cignal-api-'+env.jtag+' . --no-cache'

                    withCredentials([usernamePassword(credentialsId: 'DOCKER', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        sh label: 'Remote Login', script: 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                    }

                    sh encoding: 'UTF-8', label: 'Push Docker image', script: 'docker push -q j6wdev/j6w:cignal-api-'+env.jtag
                }
            }
        } *\

        \* stage('Deploy Image') {
            steps {
                withCredentials([string(credentialsId: 'DEPLOY_TOKEN', variable: 'JTLS'), usernamePassword(credentialsId: 'DOCKER', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    sh label: 'Remote Login', script: 'docker $JTLS login -u $DOCKER_USER -p $DOCKER_PASS'
                    sh label: 'Deploy Image', script: 'docker $JTLS service update -q --force --update-parallelism 1 --update-delay 10s cignal-api-'+env.jtag
                }
            }
        } *\
    }

    \* post {
        success {
            sh label: 'success Message', script: '/var/jenkins_home/telegram.sh "CIGNAL-API PROJECT HAVE BEEN DEPLOYED. :-) https://cignal-api.dev.j6w.work/"'
        }
        failure {
            sh label: 'failure Message', script: '/var/jenkins_home/telegram.sh "Failure to deploy PROJECT CIGNAL-API. :-("'

        }
        unstable {
            sh label: 'unstable Message', script: '/var/jenkins_home/telegram.sh "Unstable build for CIGNAL-API."'
        }
        cleanup {
            deleteDir()
        }
    } *\
}
