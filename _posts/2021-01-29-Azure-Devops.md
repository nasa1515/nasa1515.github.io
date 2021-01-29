---
layout: post
title: "[AZURE] - DevOps Service"
author: nasa1515
categories: AZURE
date: 2021-01-29 14:36
comments: true
cover: "/assets/1800-550.jpg"
tags: AZURE
---



## **Azure DevOps Service**


<br/>

**머리말**  
 
**이번 포스트는 AZURE DevOps Service에 관련된 포스트입니다.**   
**본 포스트에서는 이론적인 부분과 예시적인 부분들에 대해서만 다루고**  
**실습의 경우 나중에 따로 다룰 예정입니다.**   

 
---

**Azure 시리즈**

- [이전포스트 - Subscription & management Group](https://nasa1515.github.io/azure/2021/01/21/azure.subscriptions.html)
- [이전포스트 - Resource & Resource Manager](https://nasa1515.github.io/azure/2021/01/22/azure-resoure.html)
- [이전포스트 - Azure Region & availability zones](https://nasa1515.github.io/azure/2021/01/22/azure.region.html)
- [이전포스트 - Azure Computing Service](https://nasa1515.github.io/azure/2021/01/25/azure.compute.html)
- [이전포스트 - Azure Storage](https://nasa1515.github.io/azure/2021/01/26/azure.storage.html)
- [이전포스트 - Azure Network VNET](https://nasa1515.github.io/azure/2021/01/26/azure-vnet.html)
- [이전포스트 - Azure VPN GATEWAY](https://nasa1515.github.io/azure/2021/01/27/Azure-VPN.html)
- [이전포스트 - ExpressRoute](https://nasa1515.github.io/azure/2021/01/27/azure-expreroute.html)

**목차**


- [Azure DevOps Service](#a1)
- [ExpressRoute 장점](#a2)



--- 

## **Azure DevOps Service**   <a name="a1"></a>


**기본적으로 DevOps 방법론의 목적은  
소프트웨어 시스템의 지속적인 개발, 유지 관리 및 배포를 자동화하는 것입니다.**  
**기존에는 Jenkins, Argocd 등 각 프로세스에 맞는 오픈소스들을 도입하여 관리했지만** 
**Azure, GCP, AWS등의 Public Cloud는 소스코드관리, CI/CD 인프라 자동화 등등에 자체적으로 도구를 지원합니다**    
**따라서 Azure DevOps Service의 소프트웨어 개발 수명 주기의 모든 단계에서 문제를 해결 할 수 있는 서비스를 소개합니다.**

<br/>


* **Azure Repos : 소프트웨어 개발, DevOps 엔지니어링, 문서화 전문가가  
검토 및 협업을 위해 코드를 게시하는 중앙형 Source-Code Repo입니다.**

* **Azure Boards : Aglie 방법론을 포함한 Kanban Boards 입니다.  
리포트, high-level의 아이디어, 작업을 Tracking 할 수 있습니다.**

* **Azure Pipelines : CICD 파이프라인 자동화 도구**

* **Azure Artifacts : 테스트, 컴파일된 소스코드와 같은 아티팩트를 호스팅 하기 위한 Repo입니다.**

* **Azure Test Plans : SW 릴리즈 전에 품질을 보장하기 위한 CI/CD 파이프라인 내의 자동화 테스트 도구 입니다.**


<br/>

### **Azure DevTest Labs**  

**Azure DevTest Labs는 SW Build가 포함된 VM을  
빌드, 설정 ,삭제하는 프로세스를 관리하기 위해 자동화된 방법을 제공합니다.**  

**이 방식으로, 개발자와 테스터는 다양한 환경 및 빌드에서 테스트를 수행할 수 있습니다.  
또한 이 기능은 VM으로 제한되지 않습니다.  
ARM 템플릿을 통해 Azure에 배포할 수 있는 것은 무엇이든 DevTest Labs를 통해 프로비저닝할 수 있습니다.**


***이전 버전의 운영 체제에서 새로운 기능을 테스트해야 한다고 가정해보겠습니다.  
Azure DevTest Labs는 요청 시 모든 것을 자동으로 설정할 수 있습니다.  
테스트가 완료된 후 DevTest Labs는 VM을 종료하고 프로비전 해제할 수 있으므로,  
사용하지 않는 동안 비용이 절약됩니다.  
비용을 제어하기 위해 관리 팀은 만들 수 있는 랩의 수, 실행 가능 시간 등을 제한할 수 있습니다.***

<br/>

---