---
layout: post
title: "[AZURE] - Cloudshell error = Error creating Azure Storage Account - code : 409"
author: nasa1515
categories: AZURE
date: 2021-03-24 14:36
comments: true
cover: "/assets/1800-550.jpg"
tags: AZURE
---



## **Cloudshell error = Error creating Azure Storage Account - code : 409**


<br/>

**머리말**  
  

**이번에 새롭게 Azure PASS를 전달받아서 해당 구독으로 Cloud Shell을 사용하려고 했으나**  
**Cloudshell error = Error creating Azure Storage Account - code : 409 error가 발생으로**  
**Storage가 생성되지 않아 관련 포스트를 작성합니다.**  




 
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


- [ERROR!](#a1)




--- 

## **Error!**   <a name="a1"></a>  

#### **Cloud Shell에 연결을 위한 Storage를 생성하려는데 다음과 같은 Error 발생**  
![11111](https://user-images.githubusercontent.com/69498804/112244518-cb5e4980-8c92-11eb-9688-bddeb6457fbf.JPG)

* **해당 Error Code : 409가 발생전에 403 Error도 발생했으나 해결했습니다.**  


<br/>


* #### **403 ERROR 해결 : [StackOverFlow](https://stackoverflow.com/questions/44107943/unable-to-create-storage-for-persisting-account-files-in-azure-cloud-shell-cli)에서 구독의 Resource providers의 Microsoft.Storage 권한 설정**  

    ![ehMUs](https://user-images.githubusercontent.com/69498804/112245160-b504bd80-8c93-11eb-96cc-11449ff92060.png)


    * **해당 ERROR는 구독에서 providers의 권한이 없어서 발생한 문제였음**  

<br/>

* #### **409 ERROR 해결 : [StackOverFlow](https://stackoverflow.com/questions/60620035/unable-to-open-cloud-shell-because-of-storage-account-error)에서 Custom하게 Storage 생성**    

    ![KKoo7](https://user-images.githubusercontent.com/69498804/112245280-e4b3c580-8c93-11eb-9514-14be46875521.png)

    * **다음과 같이 ``show advanced settings`` tab을 선택해 Custom하게 생성**   

    **StorageAccountAlreadyTaken error는 스토리지 계정 생성 문제입니다.**   **이는 새로운 스토리지 계정을 만들고 있지만 동일한 이름의 스토리지 계정이 전 세계의 이미 존재함을 나타냅니다.**  
    **(왜냐하면 스토리지 계정 이름은 모든 Azure 계정에서 고유해야 하기 떄문).**  
    **또한 구독에 상속되어있는 Default Region의 문제일 수도 있어 해당 Region도 지정해주었음.**  


<br/>
