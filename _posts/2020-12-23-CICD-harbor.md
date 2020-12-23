---
layout: post
title: "[DevOps] - Harbor 저장소 사용"
author: Lee Wonseok
categories: DevOps
date: 2020-12-23 12:36
comments: true
cover: "/assets/kubernets.jpg"
tags: DevOps
---



#  [DevOps] - Harbor 저장소 사용
**머리말**  

**그동안 빌드된 이미지를 관리하거나 정적분석 할 때 Docker hub를 기반으로 구성했으나**  
**이번 프로젝트에서는 어떻게 하면 보안에 조금 더 중점을 둘 수 있을까를 생각하다**  
**Harbor를 사용하여 독립적인 저장소로 이미지를 관리하기로 결정하였습니다.**


---

**전체적인 프로젝트 글들은 아래를 참고 해주시면 됩니다.**

### [1. Jenkins를 이용한 CI 구축기](https://nasa1515.github.io/devops/2020/09/22/CICD.html)
### [2. Rancher를 사용한 k8s 클러스터 구축기 - on-pre 환경](https://nasa1515.github.io/devops/2020/10/13/CICD.html)
### [3. Rancher를 사용한 k8s 클러스터 구축기 GKE](https://nasa1515.github.io/devops/2020/10/13/CICD2.html)
### [4. Argo-CD를 이용한 배포 자동화](https://nasa1515.github.io/devops/2020/10/14/CICD3.html)
### [5. 보안 취약점 검사를 위한 Dvmn 앱 배포하기!](https://nasa1515.github.io/devops/2020/10/21/CICD4.html)
### [6. GCP의 FileStore (NFS) 사용해 DB 데이터 백업](https://nasa1515.github.io/devops/2020/10/21/CICD5.html)
### [7. Jenkins로 Dvmn 앱 이미지 빌드 및 푸시하기](https://nasa1515.github.io/devops/2020/10/21/CICD6.html)

---


* **사용 할 툴을 다음과 같습니다.**  

    - **Jenkins**
    * **OWASP ZAP**

---


**목차**

- [Harbor 설치](#a1)
- [HTTP 연결 방법](#a2)
- [클러스터 연결](#a3)
- [쿠버네티스 시크릿 생성](#a4)

---


<br/>

### **Harbor 설치 (Docker)** <a name="a1"></a>

* **Harbor 설치의 경우 이미 많은 분들이 더 쉽게 설명해놓으셔서 간단히 넘어가겠습니다.**  

    ![img](https://user-images.githubusercontent.com/51220344/102866432-99163380-447a-11eb-8d9f-ded27807e327.jpg)

* **우선 Harbor는 특정 OS에 맞는 docker, docker-compose가 요구됩니다**  
    **본 프로젝트는 Centos 7을 기반으로 진행하였습니다.**

<br/>

* ### **docker-compose**

    ```
    sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose -v
    ```

* ### **Harbor [관련 링크](https://github.com/goharbor/harbor/releases)**

    ```
    wget https://github.com/goharbor/harbor/releases/download/v1.9.4/harbor-online-installer-v1.9.4.tgz
    tar xvfz harbor-online-installer-v1.9.4.tgz
    cd harbor
    vi harbor.yml // port 변경가능
    ./install.sh
    ```

* ### **위의 간단한 명령어로 설치가 완료되면 설정한 Public IP로 접근됩니다.**  

    ![img1](https://user-images.githubusercontent.com/51220344/102866526-c19e2d80-447a-11eb-9e5c-ded42c1df7fc.png)

    > ID : admin / Pass : Harbor12345


<br/>


* **사용 및 수정한 Harvor.xml은 다음과 같습니다.**


* ### **Harbor conf**
    ```
    vi harbor.xml
    # hostname
    # https 주석(미사용시)
    ./prepare
    #docker-compose reset
    docker-compose down -v
    docker-compose up -d
    ```

---

### **그러나 Harbor는 HTTPS가 기본입니다.**  <a name="a2"></a>

<br/>

* **저희는 SSL 인증서에 많은 시간을 쓰고 싶지 않아 아래와 같은 방법으로 HTTP로 Harbor를 사용했습니다.**

    * **Harbor를 설치한 서버와 연결할 node들에 해당 명령어를 일일히 기입해야합니다.**

    ```
    ke-c-dcn6h-default-0-41c99d2b-zkp7 ~ # vim /etc/default/docker 
    gke-c-dcn6h-default-0-41c99d2b-zkp7 ~ # 
    gke-c-dcn6h-default-0-41c99d2b-zkp7 ~ # systemctl restart docker
    gke-c-dcn6h-default-0-41c99d2b-zkp7 ~ # 
    gke-c-dcn6h-default-0-41c99d2b-zkp7 ~ # 
    gke-c-dcn6h-default-0-41c99d2b-zkp7 ~ # cat /etc/default/docker 
    DOCKER_OPTS="-p /var/run/docker.pid --iptables=false --ip-masq=false --log-level=warn --bip=
    169.254.123.1/24 --registry-mirror=https://mirror.gcr.io --log-driver=json-file --log-opt=ma
    x-size=10m --log-opt=max-file=5 --insecure-registry 34.64.237.112"


    gke-c-dcn6h-default-0-41c99d2b-zkp7 ~ # docker info | grep Insecure -A2
    Insecure Registries:
    34.64.237.112
    127.0.0.0/8
    ```


    * **/etc/default/docker 파일의 --insecure-registry 구문을 수정한 뒤  
    Docker를 재시작 시켜주면 되는 간단한 작업입니다.**


---

### **그러나 HUB에 로그인이 안되는 문제가 발생했습니다.** <a name="a3"></a>
  

<br/>

* **아래와 같이 Harbor 저장소를 HTTP로 연결하려하는데 실패했습니다.**  

    ```
    gke-c-dcn6h-default-0-41c99d2b-zkp7 ~ # docker login http://34.64.237.112
    Username: admin
    Password: 
    Error response from daemon: Get http://34.64.237.112/v2/: Get http://jenkins/service/token?a
    ccount=admin&client_id=docker&offline_token=true&service=harbor-registry: dial tcp: lookup j
    enkins on 169.254.169.254:53: no such host
    ```

    *   **lookup jenkins on 169.254.169.254:53: no such host**  
        **로그내용을 보니 DNS or HOSTS의 문제인 것으로 판단됩니다.**


<br/>

* **다음과 같이 hosts에 추가해줘봅시다.**

    ```
    gke-c-dcn6h-default-0-41c99d2b-zkp7 ~ # cat /etc/hosts | grep jenkins
    34.64.237.112   jenkins
    ```

* **그럼 아래와 같이 정상적으로 저장소에 로그인이 가능해집니다.**

    ```
    gke-c-dcn6h-default-0-41c99d2b-b3hf ~ # docker login http://34.64.237.112
    Username: admin
    Password: 
    WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
    Configure a credential helper to remove this warning. See
    https://docs.docker.com/engine/reference/commandline/login/#credentials-store
    Error saving credentials: mkdir /root/.docker: read-only file system
    ```

* **물론 이미지를 가져오는 것도 자유롭습니다.**

    ```
    [root@rancher ~]# docker pull 34.64.237.112/cccr/centos:latest
    latest: Pulling from cccr/centos
    e4c3d3e4f7b0: Pull complete 
    101c41d0463b: Pull complete 
    8275efcd805f: Pull complete 
    751620502a7a: Pull complete 
    a59da3a7d0e7: Pull complete 
    5ad32ac1e527: Pull complete 
    50f250ce9768: Pull complete 
    3dd70b2a7b06: Pull complete 
    8c2eed4e2f48: Pull complete 
    724b4bfec817: Pull complete 
    61ae8c03d512: Pull complete 
    9a94fab24995: Pull complete 
    da240281d421: Pull complete 
    a3770e71565d: Pull complete 
    e1c790c868f5: Pull complete 
    70b50f1bf238: Pull complete 
    Digest: sha256:cc72b06299df2ca6ed89a93190f062cb918185742afe270a5e179b2ab52c1d17
    Status: Downloaded newer image for 34.64.237.112/cccr/centos:latest
    34.64.237.112/cccr/centos:latest
    [root@rancher ~]# docker images
    REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
    34.64.237.112/cccr/centos   latest              d35d713b85e5        12 days ago         892M
    B
    ```


---

### **또 그러나 ~ 클러스터에 올려진 Argcod는 쿠버네티스 기반으로 띄워져 있기에..** <a name="a4"></a>

* **쿠버네티스 클러스터에 아래와 같이 시크릿을 추가해줘야 정상적으로 연동이 됩니다..**

    ```
    kubectl get secret regcred --output=yaml
    apiVersion: v1
    data:
    .dockerconfigjson: eyJhdXRocyI6eyJodHRwOi8vMzQuNjQuMjM3LjExMiI6eyJ1c2VybmFtZSI6ImFkbWluIiwicGFzc3dvcmQiOiJIYXJib3IxMjM0NSIsImF1dGgiOiJZV1J0YVc0NlNHRnlZbTl5TVRJek5EVT0ifX19
    kind: Secret
    metadata:
    creationTimestamp: "2020-11-12T09:29:40Z"
    name: regcred
    namespace: default
    resourceVersion: "13089794"
    selfLink: /api/v1/namespaces/default/secrets/regcred
    uid: 50cc6a2d-0f39-4fed-96e7-d5edde4e0f37
    type: kubernetes.io/dockerconfigjson
    > 
    > 
    > kubectl get secret regcred --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode
    base64: unrecognized option: decode
    BusyBox v1.31.1 () multi-call binary.

    Usage: base64 [-d] [FILE]

    Base64 encode or decode FILE to standard output
            -d      Decode data
    > 
    > 
    > kubectl get secret regcred --output="jsonpath={.data.\.dockerconfigjson}" | base64 -d
    {"auths":{"http://34.64.237.112":{"username":"admin","password":"Harbor12345","auth":"YWRtaW46SGFyYm9yMTIzNDU="}}}>
    ```

--- 

### **자 그럼 설치, 연동 모두 완료되었으니 Jenkins에서 다음과 같이 연결합니다.**

<br/>

* **Harbor의 경우 별 다른 APP 설치 없이 파이프라인 스크립트에서 바로 연결이 가능합니다.**


* **저의 경우 스크립트 환경변수에 다음과 같이 할당했습니다.**

    ```
    pipeline {
        environment {
            slack_channel = '#studying'
            REGISTRY = 'cccr/jisun'
            REGISTRY_IP = '34.64.237.112'       <<-- Harbor IP
            REGISTRYCREDENTIAL = 'harbor'       <<-- Credential
            DOCKER_IMAGE = ''
            TAG_NUM = ''
        }
    ...
    ...(중략)

            stage('Docker image push to Harbor') {    <<-- 다음과 같이 푸시하도록.
                steps{
                    script {
                        docker.withRegistry('http://$REGISTRY_IP', REGISTRYCREDENTIAL) {
                            DOCKER_IMAGE.push('${BUILD_NUMBER}')
                            DOCKER_IMAGE.push("latest")
                        }
                    }
                    sh 'docker rmi $REGISTRY:latest'
                    sh 'docker rmi $REGISTRY_IP/$REGISTRY:$BUILD_NUMBER'
                    sh 'docker rmi $REGISTRY_IP/$REGISTRY:latest'
                }
    ```

<br/>

* ### **그럼 최종적으로 아래와 같이 Harbor를 통해서 이미지를 관리할 수 있게 됩니다.**

    ![gg](https://user-images.githubusercontent.com/69498804/102946406-eee2ee00-4503-11eb-87d6-fad094b4187f.PNG)
