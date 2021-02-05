---
layout: post
title: "[AZURE] - RG, Resource Locks, Delete"
author: nasa1515
categories: AZURE
date: 2021-02-05 13:36
comments: true
cover: "/assets/1800-550.jpg"
tags: AZURE
---



## **RG, Resource Locks, Delete**


<br/>

**머리말**  
  
**저번 포스트에서는 Resources의 생성, 태깅, 이동 부분에 대해서 다뤄봤습니다.**  
**이번 포스트는 리소스, RG의 잠금(Lock) , 삭제 부분에 대해서 실습합니다.**  

 
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

* **실습**

    - [RG 생성, Resource 생성, TAGING, Resoureces 이동하기](https://nasa1515.github.io/azure/2021/02/05/azure-resource2.html)

**목차**


- [RG, Resources Locks](#a1)
- [RG, Resources Locks 생성](#a2)
- [RG, Respirces Delete](#a3)



--- 

<br/>

## **RG, Resources 잠금 (locks)**   <a name="a1"></a>


**Resources 와 RG는 운명 공동체입니다.**  
**Resources를 효율적이고 편리하게 관리하기 위해 존재하는게 RG이니까요**  
**그러나 이 편리함이 가끔은 단점이 될 수도 있습니다.**  
**노력을 들인 리소스들이 한번에 몽땅 삭제 될 수도 있기 때문이죠**  

**물론 RG를 삭제할 때 이름을 한번 더 입력하는 등의 안전장치는 있지만**  
**이 안전장치 또한 RG가 여러개이면 헷갈릴 가능성이 매우 높습니다.**  
**그래서 중요한 Resources를 관리하고 있는 RG에 대한 추가적인 보호 조치가 필요합니다.**  
**이 목적으로 Azure에서는 Locks 기능을 제공합니다.**  

<br/>

### **잠금(locks)을 사용할 수 있는 대상**  

* **구독**
* **RG**
* **Resources**

<br/>

### **잠금 유형** 

* **읽기 전용 잠금 (Read-Only)**
* **삭제 잠금 (Delete)**

<br/>

**위 두가지 잠금 중 Read-Only 잠금이 더 강력합니다.**  
**간단히 Delete Locks은 수정은 가능하지만 삭제만 불가능하고**  
**Read-Only Locks는 수정과 삭제 모두 불가능합니다.**  
**추가적으로 Locks도 하위 리소스에 상속됩니다.**  
**예를 들어 구독에 설정한 잠금은 속해있는 모든 리소스 그룹에 상속됩니다.**

<br/>

* **Locks Type 그림 참고**

    ![2222](https://user-images.githubusercontent.com/69498804/106989236-1096ec80-67b5-11eb-9442-6b7928a68991.JPG)



<br/>

---

<br/>

## **RG, Resources Locks 생성** <a name="a2"></a>