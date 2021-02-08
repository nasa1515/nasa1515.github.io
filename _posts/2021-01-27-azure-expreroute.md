---
layout: post
title: "[AZURE] - ExpressRoute"
author: nasa1515
categories: AZURE
date: 2021-01-27 14:36
comments: true
cover: "/assets/1800-550.jpg"
tags: AZURE
---



## **Azure ExpressRoute**


<br/>

**머리말**  
 
**이번 포스트는 이전 포스트인 VPN GW에서 이어진 영역의 포스트입니다.**  

 
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


- [Azure ExpressRoute](#a1)
- [ExpressRoute 장점](#a2)



--- 

## **Azure ExpressRoute**   <a name="a1"></a>

<br/>

**ExpressRoute를 사용하면 connectivity provider로 Private 하게 on-premise network를 클라우드로 확장할 수 있습니다.**  
**또한 ExpressRoute를 통해 Azure 및 Microsoft 365, Service 에 대한 연결을 설정할 수 있습니다.**

**연결은 connectivity provider를 통해 아래 3가지로 가능합니다.** 

* **any-to-any (IP VPN) network**
* **point-to-point Ethernet network**
* **virtual cross-connection**

**ExpressRoute 연결은 퍼블릭 인터넷을 통해 이동하지 않습니다.**  

![azure-expressroute-overview (1)](https://user-images.githubusercontent.com/69498804/105943568-e3578980-60a4-11eb-88a2-19970cbb0646.png)

<br/>

**ExpressRoute 포스트에서는 OSI 2,3 계층을 중점적으로 다루겠습니다.**  

* **계층 2(L2): 이 계층은 데이터 링크 계층이며, 같은 네트워크에 있는 두 노드 사이에 노드 간 통신을 제공합니다.**
* **계층 3(L3): 이 계층은 다중 노드 네트워크에서 노드 간의 라우팅 및 주소 지정을 제공하는 네트워크 계층입니다.**

---


## **ExpressRoute 장점**  <a name="a2"></a>

<br/>

* **connectivity provider를 통한 ON-Premise 네트워크와 Cloud 간의 ``3계층 연결입니다.``**  
**때문에 아래와 같은 연결방식을 지원합니다.**  

    * **any-to-any (IP VPN) network**
    * **point-to-point Ethernet network**
    * **virtual cross-connection**

![azure-connectivity-models](https://user-images.githubusercontent.com/69498804/105944510-c754e780-60a6-11eb-8389-d503e99a2b79.png)


<br/>

* **지정된 지역에 Microsoft 클라우드 서비스에 연결합니다.**

* **ExpressRoute premium add-on 설치하면 모든 지역에 Microsoft 클라우드 서비스에 연결합니다.**

* **BGP를 사용해 네트워크와 Microsoft 간 동적 라우팅을 지원**

---

<br/>

### **Microsoft 클라우드 서비스에 연결**

**ExpressRoute를 통해 모든 지역에서 다음 서비스에 직접 액세스할 수 있습니다.**

* **Microsoft Office 365**
* **Microsoft Dynamics 365**
* **Azure 컴퓨팅 서비스(예: Azure Virtual Machines)**
* **Azure 클라우드 서비스(예: Azure Cosmos DB 및 Azure Storage)**

---

## **마치며…**  

**여기까지 간단하네 Azure의 네트워크에 대한 기본 설명을 진행해봤습니다.**  
**물론 이정도의 서비스만 있는 것이 아니기 때문에 아직 갈길은 멀지만**  
**기초는 다졌다고 생각을 합니다.**

