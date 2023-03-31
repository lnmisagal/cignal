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

                    sh encoding: 'UTF-8', label: 'Check Downloaded Files', script: 'pwd && ls -lah'
                }
            }
        }
        stage('Build Image') {
            steps {
                script {
                    sh encoding: 'UTF-8', label: 'Initialize Dockerfile', script: 'echo "FROM lnmisagal/cignal" > Dockerfile'  
                    sh encoding: 'UTF-8', label: 'Initialize Dockerfile', script: 'echo "COPY . ." >> Dockerfile'
		    sh encoding: 'UTF-8', label: 'Initialize Dockerfile', script: 'echo "USER root" >> Dockerfile'
                    sh encoding: 'UTF-8', label: 'Initialize Dockerfile', script: 'echo "RUN chmod 777 *" >> Dockerfile' 
                    sh encoding: 'UTF-8', label: 'Initialize Dockerfile', script: 'echo "RUN composer update" >> Dockerfile'  
                    sh encoding: 'UTF-8', label: 'Initialize entrypoint', script: 'echo "#!/bin/bash" > entrypoint.sh'
                    sh encoding: 'UTF-8', label: 'Initialize entrypoint', script: 'echo "chmod 777 storage -R" > entrypoint.sh'
                    sh encoding: 'UTF-8', label: 'Initialize entrypoint', script: 'echo "php-fpm -D && httpd -D FOREGROUND" >> entrypoint.sh' 
                    sh encoding: 'UTF-8', label: 'Initialize entrypoint', script: 'echo "RUN chmod +x entrypoint.sh" >> Dockerfile' 
                    sh encoding: 'UTF-8', label: 'Initialize entrypoint', script: 'echo "ENTRYPOINT /opt/app-root/src/entrypoint.sh" >> Dockerfile'
                    sh encoding: 'UTF-8', label: 'Verify Files', script: 'cat Dockerfile && cat entrypoint.sh'

                    sh encoding: 'UTF-8', label: 'build Docker image', script: 'docker build -t j6wdev/j6w:test-api-'+env.jtag+' . --no-cache'

                    withCredentials([usernamePassword(credentialsId: 'DOCKER', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        sh label: 'Remote Login', script: 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                    }

                    sh encoding: 'UTF-8', label: 'Push Docker image', script: 'docker push -q j6wdev/j6w:test-api-'+env.jtag 
                }
            }
        }
    }
}
