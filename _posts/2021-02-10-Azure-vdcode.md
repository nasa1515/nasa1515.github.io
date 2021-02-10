---
layout: post
title: "[AZURE] - Visual Studio Coud 연결하기"
author: nasa1515
categories: AZURE
date: 2021-02-09 14:36
comments: true
cover: "/assets/1800-550.jpg"
tags: AZURE
---



## **Visual Studio Coud 연결하기**


<br/>

**머리말**  
  

**지금까지의 포스트에서는 PowerShell을 이용할때 Portal을 통해서 입력했었습니다.**  
**일일히 VM에 들어가고 인증하고 하는 과정들이 너무 불필요하게 느껴졌고**  
**앞으로 Terraform등을 연동해서 실습을 할 예정이기에 이쯤에서 VSCODE의 연동이 필요하다고 느꼈습니다.**  
**그래서 이번 포스트는 VSCODE의 연동입니다.**  


**본 포스트는 ``Windows 10 Pro`` 기반에서 시행되었습니다.**
 
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
    - [가용성(Availability)](https://nasa1515.github.io/azure/2021/02/08/scail.html)
    - [Application Gateway](https://nasa1515.github.io/azure/2021/02/09/Azure-LB.html)
    - [LoadBalancer](https://nasa1515.github.io/azure/2021/02/09/Azure-lb2.html)


---



**목차**


- [Visual Studio(VS) Code 설치](#a1)
- [PowerShell Core 설치](#a2)
- [LB TEST!!](#a3)



--- 

<br/>

## **1. Visual Studio(VS) Code 설치**   <a name="a1"></a>    


<br/>


* **[VSCODE 페이지](https://code.visualstudio.com/download)로 이동하여 VS 코드를 설치합니다.**

    ![캡처33](https://user-images.githubusercontent.com/69498804/107454972-52e37380-6b91-11eb-9bed-ca4ccdc70e9c.JPG)


<br/>


---


## **2. PowerShell Core 설치** <a name="a2"></a>  
