---
layout: post
title: "[AZURE] - App Service로 Word Press 띄우기"
author: nasa1515
categories: AZURE
date: 2021-01-22 14:36
comments: true
cover: "/assets/1800-550.jpg"
tags: AZURE
---



## **App Service로 Word Press 띄우기**


<br/>

**머리말**  
 
**이전 포스트에서는 이론적인 부분들만 설명했습니다.**  
**이번 포스트에서는 App Service의 이론적인 내용과 실습을 같이 다뤄봤습니다.**  
**아직도 많이 부족합니다..ㅠㅠ**
 
---


**Azure 시리즈**

* **이론**

    - [Subscription & management Group](https://nasa1515.github.io/azure/2021/01/21/azure.subscriptions.html)
    - [Resource & Resource Manager](https://nasa1515.github.io/azure/2021/01/22/azure-resoure.html)
    - [Azure Region & availability zones](https://nasa1515.github.io/azure/2021/01/22/azure.region.html)
    - [Azure Computing Service](https://nasa1515.github.io/azure/2021/01/25/azure.compute.html)
    - [Azure Storage](https://nasa1515.github.io/azure/2021/01/26/azure.storage.html)
    - [Azure Network VNET](https://nasa1515.github.io/azure/2021/01/26/azure-vnet.html)
    - [Azure VPN GATEWAY](https://nasa1515.github.io/azure/2021/01/27/Azure-VPN.html)
    - [Azure ExpressRoute](https://nasa1515.github.io/azure/2021/01/27/azure-expreroute.html)
    - [Azure Storage Account](https://nasa1515.github.io/azure/2021/02/08/storage2.html)


* **실습**

    - [RG 생성, Resource 생성, TAGING, Resoureces 이동하기](https://nasa1515.github.io/azure/2021/02/05/azure-resource2.html)
    - [Vnet 생성하기](https://nasa1515.github.io/azure/2021/02/05/vnet2.html)
    - [가상머신(VM)](https://nasa1515.github.io/azure/2021/02/08/VM2.html)
    - [Storage Service 생성](https://nasa1515.github.io/azure/2021/02/08/AZURE-Storageservice.html)
    - [가용성(Availability)](https://nasa1515.github.io/azure/2021/02/08/scale.html)
    - [가상 머신 확장 집합 (VMSS)](https://nasa1515.github.io/azure/2021/02/09/Azure-VMSS.html)   
    - [Virtual Network Gateway - VPN](https://nasa1515.github.io/azure/2021/02/09/Azure-vpngw.html)   
    - [Application GateWay](https://nasa1515.github.io/azure/2021/02/09/Azure-LB.html)   
    - [LoadBalancer](https://nasa1515.github.io/azure/2021/02/09/Azure-lb2.html)   
    - [VSCODE <-> Cloudshell](https://nasa1515.github.io/azure/2021/02/09/Azure-vdcode.html)   
    - [VM 으로 LAPM 서비스 구축하기](https://nasa1515.github.io/azure/2021/02/24/AZURE-WEB.html)   
    - [VSCODE로 AKS 관리하기](https://nasa1515.github.io/azure/2021/03/19/aks-vscode.html)

* **ERROR Report**  

    - [Cloudshell error = Error creating Azure Storage Account - code : 409](https://nasa1515.github.io/azure/2021/03/24/azure-cloudshellerror.html)
---

**목차**


- [Azure App Serivce](#a1)
- [Azure MarketPlace](#a2)
- [Word Press 띄우기](#a3)
- [관리그룹 (Management Group)](#a4)

---


## **App Service**   <a name="a1"></a>

***App Service는 인프라를 구성, 관리하지 않고도 여러 유형의 웹 기반 솔루션을  
Build, Hosting 할 수 있는 HTTP 기반 서비스 입니다.***  


***.NET, .NET Core, Java, Ruby, Node.js, PHP 또는 Python 기반 APP은  
Windows,Linux 기반 환경 양쪽에서 실행하고 간편하게 확장할 수 있습니다.***

* **이번 포스트에서는 Code가 아닌 Portal을 이용해서 실습을 진행합니다.**  
**따라서 MarketPlace를 통해 진행합니다.**

<br/>

----

## **MarketPlace**  <a name="a2"></a>

**Azure에서 간편히 실행 할 수 있도록 최적화된 app을 호스팅하는 Store입니다.**  

* **음 Rancher의 APP Store같은 느낌입니다.**

<br/>

---

## **Word Press 띄우기** <a name="a3"></a>

<br/>

**Azure에서 어떠한 서비스듡지 사용하려면 기본적으로 갖춰야 하는 조건이 있습니다.**

* **Subscription**
* **Resources**
* **RG**


**그러나 이번 포스트는 SandBox의 리소스 그룹을 통해 진행하기에**  
**앞의 조건들을 생성하는 것은 다른 포스트에서 다루겠습니다.**  


* **기본적으로 SandBox를 이용하면 아래와 같은 RG가 자동으로 생성됩니다.**

    ![캡처](https://user-images.githubusercontent.com/69498804/105447049-c0992f80-5cb6-11eb-84b3-360f5874c0cf.JPG)

<br/>

---

## **App Serivce를 통해 WordPress를 실행** 

<br/>

**[리소스 만들기] - [MarketPlace] - [WordPress 검색]**

![캡처2](https://user-images.githubusercontent.com/69498804/105447294-4ae19380-5cb7-11eb-8a8a-ce0c761efa6c.JPG)


<br/>

**다음과 같이 WordPress APP에 대한 설정을 할 수 있습니다.**

![333](https://user-images.githubusercontent.com/69498804/105447525-baf01980-5cb7-11eb-9d5d-b113511c5f8c.JPG)

<br/>

**SandBox로는 App Service 요금제를 최하로 밖에 못쓰기 때문에 바꿔줍시다.**


 ![44](https://user-images.githubusercontent.com/69498804/105448000-c1cb5c00-5cb8-11eb-958c-b75113c29d88.JPG)

**Nasa-Wordpress라는 이름으로 Plan을 하나 만들고 App을 활성화 합시다.**  
**[캡쳐를 잘못했네요 S1 -> F1으로 바꿔야합니다]** 

<br/>



**그럼 Port 알림에서 App Service에 대한 배포 진행을 확인할 수 있습니다.**

![캡처5555](https://user-images.githubusercontent.com/69498804/105448344-82e9d600-5cb9-11eb-9b92-490ade016329.JPG)


<br/>

**2~3분 정도 기다리면 App Serivce과 다음과 같이 배포됩니다.**

![777](https://user-images.githubusercontent.com/69498804/105448552-dbb96e80-5cb9-11eb-9775-6fda718fb259.JPG)

<br/>

**정상적으로 배포되었는지 URL을 접속해봅시다** 

![121232121](https://user-images.githubusercontent.com/69498804/105448799-54b8c600-5cba-11eb-9c44-5db096f7639b.JPG)


<br/>

**정상적으로 URL에 접속됩니다!**

![wwww](https://user-images.githubusercontent.com/69498804/105448875-82057400-5cba-11eb-8cfd-e0643ecc3d63.JPG)

---



<br/>

## **마치며…**  


**이번 포스트는 App Service에 대한 이론적인 내용과 간단한 실습을 진행했습니다.**  
**역시 이론보다는 실습이 재미있습니다.**  
**조금씩 포스트가 늘어감에 따라 지식도 늘어가고 있네요**
