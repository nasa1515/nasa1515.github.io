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

**지난 포스트에서 간단하게 전체적인 파이프라인에 대해서 포스트를 했습니다.**  
**이번 포스트는 Harbor에 배포 될 Container Image 분석 오픈소스**  
**Anchore를 도입했던 포스트를 작성했습니다.**


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