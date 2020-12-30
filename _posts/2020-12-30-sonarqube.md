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

**이번 포스트로 이제 파이프라인의 전체적인 보안툴은 끝났습니다.**  
**SonarQube로 Build 될 이미지의 소스코드에 대한 전략적 정적분석을**  
**Jenkins를 이용해 자동화 할 생각입니다.**


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
    * **Anchore**

---


**목차**

- [Anchore 설치](#a1)
- [GCP 방화벽 설정](#a2)
- [Jenkins Pipeline Script 수정](#a3)
- [파이프라인 실행 결과](#a4)

---

## **Anchore ??**