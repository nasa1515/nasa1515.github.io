---
layout: post
title: "[AZURE] - Azure Cloud Shell From vscode"
author: nasa1515
categories: AZURE
date: 2021-02-09 14:36
comments: true
cover: "/assets/1800-550.jpg"
tags: AZURE
---



## **Azure Cloud Shell From vscode**


<br/>

**머리말**  
  

**지금까지는 Azure Portal에서만 PowerShell을 이용 했었습니다.**  
**그러나 일일히 VM에 들어가고 인증하고 하는 과정들이 너무 불필요하게 느껴졌고**  
**앞으로 IAC등을 사용할 예정이기에 VSCODE의 연동이 필요하다고 느꼈습니다.**  
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


- [Visual Studio(VS) Code 설치](#a1)

--- 

<br/>

## **1. Visual Studio(VS) Code 설치**   <a name="a1"></a>    



* **[VSCODE 페이지](https://code.visualstudio.com/download)로 이동하여 VS 코드를 설치합니다.**

    ![캡처33](https://user-images.githubusercontent.com/69498804/107454972-52e37380-6b91-11eb-9bed-ca4ccdc70e9c.JPG)


<br/>


---


## **2. Node.js 설치** <a name="a2"></a>  


* **[Nodejs 페이지](https://nodejs.org/en/)로 이동하여 Node.js를 설치합니다.**

    ![캡처](https://user-images.githubusercontent.com/69498804/107476689-b2ee1000-6bb9-11eb-96c5-35c821aab95f.JPG)

<br/>

---

## **3. VSCODE에서 Azure Account extension 설치**

* **VSCODE의 Extension Tab에서 Azure Account를 설치합니다!**

    ![캡처3](https://user-images.githubusercontent.com/69498804/107476968-3f98ce00-6bba-11eb-89a1-62c4f9f51d5a.JPG)


<br/>


---

### **4. 설치가 완료되었으면 명령 단축으로 이동합니다.**  


* **shift + Ctrl + P 단축키로 접속해 Azure:Sign In을 선택**

    ![캡처444](https://user-images.githubusercontent.com/69498804/107477160-9d2d1a80-6bba-11eb-891a-7ea787f34218.JPG)


<br>

* **그 후 Azure 로그인 팝업 창이 발생하면 로그인합니다.**

    ![555](https://user-images.githubusercontent.com/69498804/107477294-d6658a80-6bba-11eb-9ce7-41b4f80949b4.JPG)


<br/>

* **정상적으로 로그인이 되었다면 화면 왼쪽 하단에 로그인 ID가 보입니다.**

    ![캡처4444](https://user-images.githubusercontent.com/69498804/107477389-feed8480-6bba-11eb-9f97-ecb0e49b55c0.JPG)


<br/>



---

## **Cloud Shell에 접속합니다.**


* **로그인 완료 후 shift + Ctrl + P으로 Azure:Open PowerShell in Cloud Shell을 선택**

    ![캡처777](https://user-images.githubusercontent.com/69498804/107477565-4b38c480-6bbb-11eb-9c77-18e53bbde690.JPG)


<br/>


* **이후 터미널이 실행되고 Cloud Shell에 접속됩니다.**

    ![캡처5555](https://user-images.githubusercontent.com/69498804/107477612-673c6600-6bbb-11eb-9045-49d9f19764b4.JPG)


<br/>


---

## **마치며…**  


**이제 진정한 Azure의 시작입니다.**  
**VSCODE 연동도 완료되었으니 앞으로 거의 대부분의 실습은 CLI로 진행합니다.**  


