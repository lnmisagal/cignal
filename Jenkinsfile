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
    }
}
