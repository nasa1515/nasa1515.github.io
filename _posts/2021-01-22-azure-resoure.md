---
layout: post
title: "[AZURE] - Azure Resource & Resource Manager"
author: nasa1515
categories: AZURE
date: 2021-01-22 12:36
comments: true
cover: "/assets/1800-550.jpg"
tags: AZURE
---



## **Azure Resource & Resource Manager**


<br/>

**머리말**  
 
**이전 포스트에서 미처 다 설명하지 못한 부분을 이어서 포스트 하겠습니다.**  
**실습 전 가장 중요한 이론의 내용들에 대해서는 다 이해하고 가야합니다.**  

 
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

---

**목차**


- [Resources](#a1)
- [Resources Group](#a2)
- [Azure Resource Manager](#a3)
- [관리그룹 (Management Group)](#a4)



---

## **Azure Resources**   <a name="a1"></a>

<br/>

**리소스 (Resources)는 간단하게 AZURE의 "단일 서비스들" 이라고 이해 하면 됩니다.**  
**Azure로 사용, 관리 가능한 VM, Storage acconut, DB, VNET 모두 리소스입니다.**


---

<br/>

## **Azure Resources Group**   <a name="a2"></a>

**리소스 그룹은 AZURE를 사용하기 위한 필수 요소 입니다.**  

**리소스 그룹을 간단히 말하면 리소스의 논리 컨테이너? 입니다**  
**즉 구독을 통해 만든 리소스의 모든 것을 묶었다고 보면 됩니다.**  

**Resource Group과 Resources에는 아래와 같은 특성을 갖습니다.**

* **모든 리소스는 리소스 그룹에 있어야합니다.**  
* **리소스는 하나의 리소스 그룹에만 존재해야 합니다. (단일)** 
* **동일한 구독 안에서 리소스 그룹의 이름은 고유해야 합니다.** 
* **리소스 그룹과 리소스의 Region이 다를 수도 있습니다.**
* **리소스 그룹의 수명이 곧 리소스의 수명입니다.**
* **한 리소스 그룹의 리소스가 다른 리소스 그룹의 리소스와 상호작용할 수 있습니다.**
* **한 리소스 그룹의 리소스를 다른 리소스 그룹으로 이동할 수 있습니다.**
* **리소스 구룹과 리소스의 관리를 위임할 수 있고, 관리 수준을 정의할 수 있습니다.**

<br/>

* **NOTE : Resource Group을 만들 때 Regions 지정이 필요한 이유**

    ```
    Resource Group은 단지 논리적인 개념일 뿐이고 리소스와 위치가 달라도 된다면
    왜 Resource Group을 생성할때 Region을 지정해야 할까요?

    해답 : 우리가 Resource Group에서 확인하는 Resource list는 실제 Metadata 입니다.
    즉 Resource Group은 Resoure의 Metadata를 저장하는 것이며
    Resource Group의 Regions이 그 Metadata가 저장되는 위치입니다. 
    ```


---
<br/>

* **Logical grouping**  

    **리소스 그룹의 용도는 리소스를 간편하게 관리하고 구성하는 것입니다.**  
    **그러나 무수히 많은 리소스를 질서있고 체계적으로 관리하기 위해서는  
    Logical grouping (논리 그룹화)가 필요합니다.**

    ![resource-group](https://user-images.githubusercontent.com/69498804/105316667-8bcca000-5c04-11eb-8cde-9c33a2757c5c.png)



<br/>

* **Life cycle**

    **리소스 그룹을 삭제하면 그룹에 속해 있던 리소스들도 모두 삭제됩니다**  
    **때문에 Life Cycle로 관리하면 TESTING 환경에서 유용하게 사용됩니다.**

<br/>


* **Authorization**

    **리소스 그룹은 RBAC의 권한을 적용하는 범위 입니다.**  
    **RBAC를 통해 필요한 리소스만 사용하도록 엑세스를 제한 할 수 있습니다.**  

---


<br/>

## **Azure Resource Manager**  <a name="a3"></a>

**Azure Resource Manager는 배포 및 관리 서비스 입니다.**  
**계정에서 리소스를 만들고, 업데이트하고, 삭제할 수 있는 관리 계층을 제공합니다.**  

**Azure 도구, API, SDK에서 요청을 보내면 Resource Manager에서 요청을 받습니다.** 
**Resource Manager가 요청을 인증하고, 권한을 부여합니다.**  


**아래 그림을 보면 이해가 쉽습니다.**


![consistent-management-layer](https://user-images.githubusercontent.com/69498804/105319055-a6ecdf00-5c07-11eb-8d36-5579fe1ddf6d.png)

* **그림과 같이 Portal에서 사용할 수 있는 모든 기능은  
Powershell, Cli, rest client, SDK를 통해 사용할 수 있습니다.**


<br/>

###  **장점**

* **스크립트가 아닌 template을 통해 인프라를 관리 합니다.**  
    **(Resource Manager template)은 배포 정의 JSON 파일입니다)**

* **모든 리소스를 개별적이 아닌 그룹으로 배포, 관리, 모니터링 합니다.**

* **리소스가 일관된 상태를 유지하기 위해 Life cycle 내내 재 배포합니다.**

* **리소스의 배포순서를 위해 리소스 사이의 종속성을 정의합니다.**

* **리소스에 태그를 적용해 구독의 모든 리소스를 논리적으로 구성합니다.**

* **동일한 태그를 가진 리소스 그룹의 비용을 확인, 청구를 명확히 구분합니다.**

---


<br/>

## **마치며…**  


**이번 포스트에서는 Azure의 Resources를 주로  
Resource Group, Resource manager의 개념에 대해서 살펴봤습니다.**  
**포스트를 쓸 수록 타 퍼블릭에 비해 AZURE의 진입장벽이 높다는걸 느낍니다.**  
**다음 포스트에서는 Azure의 resion에 대해서 알아보겠습니다.**