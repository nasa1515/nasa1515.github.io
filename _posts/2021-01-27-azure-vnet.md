---
layout: post
title: "[AZURE] - NetWork (Vnet)"
author: nasa1515
categories: AZURE
date: 2021-01-27 13:36
comments: true
cover: "/assets/1800-550.jpg"
tags: AZURE
---



## **Azure NetWork (Vnet)**


<br/>

**머리말**  
 
**이번 포스트에서는 Azure에서 사용하는 가상 네트워크 Vnet에 대해 다뤘습니다.  
아마 Azure도 Public이기 때문에 기본 개념은 다른 것들과 동일 할 것 같습니다.**

 
---

**Azure 시리즈**

- [이전포스트 - Subscription & management Group](https://nasa1515.github.io/azure/2021/01/21/azure.subscriptions.html)
- [이전포스트 - Resource & Resource Manager](https://nasa1515.github.io/azure/2021/01/22/azure-resoure.html)
- [이전포스트 - Azure Region & availability zones](https://nasa1515.github.io/azure/2021/01/22/azure.region.html)
- [이전포스트 - Azure Computing Service](https://nasa1515.github.io/azure/2021/01/25/azure.compute.html)
- [이전포스트 - Azure Storage](https://nasa1515.github.io/azure/2021/01/26/azure.storage.html)

**목차**


- [Azure Netowrk Resource](#a1)
- [가상 네트워크 연결](#a2)

--- 

## **Azure Network Resource - VNET**   <a name="a1"></a>

**사실 Vnet은 사전 설명이 필요 없을 정도로 이미 다 아는 기능 일 겁니다.**  
**간단히 설명하자면 Azure Resource 간의 통신을 책임지는 기능이다. 로 정리가 됩니다.**  
**그래도 몇가지 특징은 알아봐야겠죠**

<br/>

### **1. 격리 및 구분** 
**Vnet은 내부는 사설IP를 사용하기에 독립적인 공간을 사용 할 수 있습니다.**  

<br/>

### **2. 인터넷 통신**  

<br/>

### **3. Azure 리소스 간 통신**  
**아래 두가지로 리소스간의 통신을 연결합니다.**  
* **Virtual networks : VM뿐 아니라 대부분의 Resource를 연결**
* **Service endpoints : SQL DB, Storage Account 등 다른 TYPE의 연결을 제공합니다.**

<br/>

### **4. ON-Premise 리소스 통신**  
**클라우드 <-> On-Premise의 통신방법은 세가지가 있습니다.**

* **Point-to-site VPN : 반대 방향으로 작동한다는 점을 제외하고는  
회사 내의 VM <-> 회사 외의 VM을 연결하는 VPN과 동일합니다.**


* **Site-to-site VPN : On-premise VPN Device & GateWay를 Azure VPN에 연결합니다.   
이 경우 Azure Device는 Local 연결로 표시되고 암호화되며 인터넷에서 작동합니다.**

* **Azure ExpressRoute : 큰 대역폭과 높은 수준의 보안을 제공합니다  
인터넷을 통해 연결하지 않아 전용 Private 연결을 제공합니다.** 

<br/>

### **5. 네트워크 트래픽 라우팅**  
**Azure는 기본적으로 Vnet Subnet, On-Premise, Internet 간의 트래픽을 라우팅 합니다.  
대표적으로 아래 두가지를 사용합니다.**  

* **Route tables : 트래픽을 전달하는 방식에 대한 Rule을 정의할 수 있습니다.  
Subnet 간 패킷이 라우팅 되는 Custom table을 생성 할 수 있습니다.**

* **Border Gateway Protocol (BGP) : VPN GW & ExpressRoute와 함께 동작하여 BGP 라우팅을 Azure Network에 전달합니다.**

<br/>


### **6. 네트워크 트래픽 필터링**

**아래 두가지 방법으로 SubNet간의 트래픽을 필터링 할 수 있습니다.**  

* **NSG : Source, Destination IP, Port, Protocol 등으로 트래픽을 허용하거나 차단하도록 규칙을 정의 할 수 있습니다.**  

* **Network virtual appliances : 방화벽 실행, WAN 최적화 같은 특정 네트워크 기능을 수행하는 특수한 VM입니다.**

<br/>


### **가상 네트워크 연결** <a name="a2"></a>

**``Network peering`` 을 사용해서 다른 위치에 있는 Vnet과 상호 연결 할 수 있습니다.**

![local-or-remote-gateway-in-peered-virual-network](https://user-images.githubusercontent.com/69498804/105928004-7c2bdc00-6088-11eb-8630-a63f6f8714f6.png)


* **UDR (user-defined Routing)**  
**UDR은 AZURE Vnet의 중요한 업데이트 입니다.**  
**UDF을 사용하는 network admins는 Vnet내의 SubNet 간의 라우팅 테이블을 제어 할 수 있습니다.**  
**따라서 UDR을 사용해 Network traffice flow를 세밀하게 제어 합니다.**

---


<br/>

## **마치며…**  


**이번 포스트에서는 간단한 Vnet 개념에 대해서만 설명했습니다.**  
**기본적으로 Public Cloud 는 Vnet을 모르고는 사용할 수 없어서 이해가 쉬웠습니다.**  
**그러나 Azure의 네트워크들에 많은 설명을 하기 위해 부득이하게 포스트를 여러가지로 나누었습니다.**  
**다음 포스트부터 Gateway에 대해서 설명하겠습니다.**


