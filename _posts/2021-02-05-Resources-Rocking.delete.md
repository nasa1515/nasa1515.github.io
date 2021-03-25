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

<br/>

**기존에 만들어 두었던 리소스들에 잠금을 설정해보겠습니다.**

* **RG : NASA-RG02**
* **PIP : NASA-PIP01**


<br/>

* **NASA-RG02 RG의 NASA-PIP01 리소스의 잠금 메뉴를 선택합니다.**

    ![1111111](https://user-images.githubusercontent.com/69498804/106989749-23f68780-67b6-11eb-85b4-e37977f2c2e0.JPG)


<br/>

* **NASA-LOCKS-D01 이름을 가진 Delete Type의 Locks을 생성합니다.**

    ![333333](https://user-images.githubusercontent.com/69498804/106990499-b77c8800-67b7-11eb-94a5-b1aab14e985e.JPG)

<br/>

* **Locks가 정상적으로 할당되었는지 PIP Resource를 삭제해보겠습니다.**  

    ![캡처](https://user-images.githubusercontent.com/69498804/106990579-d8dd7400-67b7-11eb-8d3e-fd392250ddac.JPG)

<br/>

* **Resource Locks의 영향으로 삭제하지 못한다는 Noti를 확인할 수 있습니다.**

    ![캡처w](https://user-images.githubusercontent.com/69498804/106990662-07f3e580-67b8-11eb-86e2-f8daa1991312.JPG)


<br/>

* **또한 RG를 삭제하려고 해도 다음과 같이 Noti를 띄우면 삭제가 불가능 합니다.**  

    ![캡처3](https://user-images.githubusercontent.com/69498804/106990806-5903d980-67b8-11eb-8d82-85f92cc19f23.JPG)


    * **NASA-RG02 RG 내의 Resources 중 하나가 Locks 상태이기 때문에  
    RG나 다른 Resource도 삭제가 불가능 합니다.**


<br/>

* **추가적으로 PIP에 설정한 Locks은 RG에서도 확인이 가능합니다.**

    ![캡처4](https://user-images.githubusercontent.com/69498804/106990968-a97b3700-67b8-11eb-83c6-e3d9c5895827.JPG)

    * **그리고 RG의 Locks 메뉴에서 RG에 대한 Locks도 추가할 수 있습니다.**

<br/>


---

<br/>


## **RG, Resources Locks 삭제** <a name="a4"></a>


**Azure의 Resources는 두가지 방법으로 삭제가 가능합니다.** 

<br/>

* **1. 리소스를 일일히 삭제하는 방법**
* **2. RG를 삭제해 RG에 포함된 하위 Resources 까지 모두 삭제하는 방법**  


<br/>

* **1번 방법의 경우 삭제할 Resource tab에서 Delete 메뉴로 가능합니다.**

    ![캡처6](https://user-images.githubusercontent.com/69498804/106991288-3faf5d00-67b9-11eb-8e9c-fffa32fb9894.JPG)


<br/>

* **2번의 경우 RG 자체를 삭제하면 됩니다.** 

    ![캡처7](https://user-images.githubusercontent.com/69498804/106991389-771e0980-67b9-11eb-9259-d326443a22a9.JPG)

    * **RG NAME을 입력하는 안전장치를 해제한 뒤 삭제합시다.**


<br/>

* **NASA-RG02와 PIP 모두 삭제 되었습니다.**

    ![캡처111](https://user-images.githubusercontent.com/69498804/106991612-f3b0e800-67b9-11eb-8f37-0038195f6a57.JPG)

<br/>


---

## **마치며…**  


**이번 포스트에서는 Azure Portal로 Resource와 RG의 Rocks 부터 Delete 까지의 실습을 진행했습니다.**  
**이론적인 내용과 실습적인 부분을 함께 감당하려고 하니 점점 공부 해야 할 내용이 많아지네요..**

