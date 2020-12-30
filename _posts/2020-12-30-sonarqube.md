---
layout: post
title: "[DevOps] - SonarQube With Jenkins"
author: Lee Wonseok
categories: DevOps
date: 2020-12-30 12:36
comments: true
cover: "/assets/kubernets.jpg"
tags: DevOps
---



#  [DevOps] - SonarQube With Jenkins  

**머리말**  

**이번 포스트로 이제 파이프라인에서 동작하는 전체적인 보안툴에 대한 포스트는 끝났습니다.**  
**최종적으로는**   

**1. SonarQube로 Build 될 이미지의 소스코드에 대한 전략적 정적분석을   
2. Anchore로 빌드된 이미지에 대한 분석을  
3. OWASP ZAP으로 배포 된 서비스에 대한 동적분석을**  

**Jenkins를 이용해 자동화 하였습니다.**


---

**전체적인 프로젝트 글들은 아래를 참고 해주시면 됩니다.**

### [1. Jenkins를 이용한 CI 구축기](https://nasa1515.github.io/devops/2020/09/22/CICD.html)
### [2. Rancher를 사용한 k8s 클러스터 구축기 - on-pre 환경](https://nasa1515.github.io/devops/2020/10/13/CICD.html)
### [3. Rancher를 사용한 k8s 클러스터 구축기 GKE](https://nasa1515.github.io/devops/2020/10/13/CICD2.html)
### [4. Argo-CD를 이용한 배포 자동화](https://nasa1515.github.io/devops/2020/10/14/CICD3.html)
### [5. 보안 취약점 검사를 위한 Dvmn 앱 배포하기!](https://nasa1515.github.io/devops/2020/10/21/CICD4.html)
### [6. GCP의 FileStore (NFS) 사용해 DB 데이터 백업](https://nasa1515.github.io/devops/2020/10/21/CICD5.html)
### [7. Jenkins로 Dvmn 앱 이미지 빌드 및 푸시하기](https://nasa1515.github.io/devops/2020/10/21/CICD6.html)
### [8. Harbor 이미지 저장소 도입](https://nasa1515.github.io/devops/2020/12/23/CICD-harbor.html)

---


* **사용 할 툴을 다음과 같습니다.**  

    - **Jenkins**
    * **Sonarqube**

---


**목차**

- [Sonarqube 설치](#a1)
- [Jenkins 설정](#a2)
- [Jenkins Pipeline Script 수정](#a3)
- [파이프라인 실행 결과](#a4)

---

## **SonarQube ??**

**위키백과 왈**

*소나큐브(SonarQube, 이전 이름: 소나/Sonar)는 20개 이상의 프로그래밍 언어에서 버그, 코드 스멜, 보안 취약점을 발견할 목적으로 정적 코드 분석으로 자동 리뷰를 수행하기 위한 지속적인 코드 품질 검사용 오픈 소스 플랫폼이다.  
소나큐브는 중복 코드, 코딩 표준, 유닛 테스트, 코드 커버리지, 코드 복잡도, 주석, 버그 및 보안 취약점의 보고서를 제공한다.*

**음 읽어보니 개발자들에게 유용한 정적분석 툴입니다.**

---

<br/>



### **SonarQube 설치** <a name="a1"></a>

* **이번 포스트에서 SonarQube의 설치과정은 다루지 않습니다.**  
  **즉 이미 SonarQube 서버와, Jenkins 서버가 설치되었다는 가정하에 진행하였습니다.**


* **설치에 관련된 포스트는 [여기](https://www.lesstif.com/software-architect/sonarqube-39126262.html)를 참고해주세요**

<br/>



---



### **Jenkins 설정** <a name="a2"></a>

<br/>

* **Jenkins 내에서 SonarQube를 사용하기 위해서는 아래 플러그인 설치가 필요합니다.**

    ![AAAAAA](https://user-images.githubusercontent.com/69498804/103322025-cf0d7600-4a7f-11eb-8081-02b118e9b30c.PNG)


    * **자세한 플러그인 정보는 [링크](https://plugins.jenkins.io/sonar/) 확인해주세요**



<br/>

* **플러그인 설치가 완료되었다면 Jenkins 환경설정에서 Sonarqube 서버의 설정이 필요합니다.**

    ![222222](https://user-images.githubusercontent.com/69498804/103322080-09771300-4a80-11eb-8022-2f2b6e12fd14.PNG)

    * **설치한 SonarQube 서버의 정보를 기입해줍니다**


<br/>


* **Jenkins Global tool configuration 탭에서 Scanner에 대한 설정을 합니다.**

    ![3332131](https://user-images.githubusercontent.com/69498804/103322135-54912600-4a80-11eb-8b21-23d6f51e0fea.PNG)

    * **별다르게 상이하는 부분은 없이 동일하게 설정하면 동작됩니다.**




<br/>

* **이제 SonarQube 서버에서 Jenkins 서버에 대한 Webhook을 설정합니다.**

    ![3333333333](https://user-images.githubusercontent.com/69498804/103322208-97eb9480-4a80-11eb-8848-bd3142e2bb53.PNG)

    * **Jenkins 서버의 IP와 Port로 웹훅을 걸어주시면 됩니다.**


<br/>

* **정상적으로 설정이 되었다면 다음과 같이 웹훅이 생성됩니다.**

    ![AAAAAAAAAAADDDDD](https://user-images.githubusercontent.com/69498804/103322240-b6ea2680-4a80-11eb-9bfe-eb624f8054b9.PNG)



### **여기까지 완료되었다면 이제 Jenkins에서 SonarQube를 사용하실 수 있습니다.!!**

---



### **Jenkins Pipeline Script 수정** <a name="a3"></a>


**그럼 파이프라인 스크립트 내에 SonarQube와 관련된 내용을 삽입해보겠습니다.**


* **파이프라인 내용**

    ```
    properties([
    parameters([
        string(name: 'sonar.projectKey', defaultValue: 'com.appsecco:dvja'),
        string(name: 'sonar.host.url', defaultValue: 'http://34.64.237.112:9000'),
        string(name: 'sonar.login', defaultValue: '608cacd6bb83c50712ebb34c4cba377c841cdebb')
    ]) 
    ])
    ...
    ```

    **우선 간단하게 파이프라인을 작성하기위해 변수 설정을 했습니다.**

<br/>

* **그리고 SonarQube와 SonarQube 내에있는 Dependency-Check를 작성해줍니다.**

    ```
            stage ('Dependency-Check Analysis') {
                steps {
                    sh '/var/lib/jenkins/dependency-check/bin/dependency-check.sh --scan `pwd` --format XML --out /var/lib/jenkins/workspace/ci-build-pipeline/dependency-check-report --prettyPrint'
                    
                    dependencyCheckPublisher pattern: 'dependency-check-report/dependency-check-report.xml'
                }
            }
            stage('Sonarqube and Quality gate') {
                options {
                    timeout(time: 5, unit: 'MINUTES')
                    retry(2)
                }
                steps {
                    withSonarQubeEnv('SonarQube Server') {
                        sh "mvn sonar:sonar"
                    }
                    script {
                        qualitygate = waitForQualityGate()
                        if (qualitygate.status != "OK") {
                            currentBuild.result = "FAILURE"
                        }
                    }
                }
            }
    ```
<br/>

### **여기까지만 하면 파이프라인 내에서는 SonarQube는 정상동작합니다.**

---