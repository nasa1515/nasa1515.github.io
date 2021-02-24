---
layout: post
title: "[AZURE] - Virtual Network Gateway - VPN"
author: nasa1515
categories: AZURE
date: 2021-02-09 12:36
comments: true
cover: "/assets/1800-550.jpg"
tags: AZURE
---



## **Virtual Network Gateway - VPN**


<br/>

**머리말**  
  

**앞서서 Azure의 많은 기능들을 설명했지만 주관적으로 인프라 엔지니어에게 제일 중요한 부분은**  
**이번 포스트에서 진행할 Gateway 부분인 것 같습니다.!**  


 
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



---



**목차**


- [Virtual Network Gateway - VPN](#a1)
- [VNET-VNET VpnGW 생성 실습](#a2)


--- 

<br/>

## **Virtual Network Gateway - VPN**   <a name="a1"></a>

**Azure에서 VPN(Virtual Private Network)를 사용하는 경우는 다음과 같습니다.**

<br/>

* **S2S (Site-to-Site) : 가상네트워크와 On-Premise 네트워크를 연결하는 VPN, VPNgw와 LocalGW가 필요**  

* **P2S (Point-to-Site) : 가상네트워크와 개별 디바이스를 연결하는 VPN, VPNgw와 ClientVpn 필요.**

* **Vnet-Vnet : 서로 다른 지역이나, 구독에 있는 Azure Vnet을 연결, Peering, VpnGW를 이용**  


<br/>

#### **아래 그림을 보면 쉽게 위에서 설명한 VPN 종류의 차이를 파악 할 수 있습니다.**


![22222](https://user-images.githubusercontent.com/69498804/107910006-dd1a4600-6f9c-11eb-9865-fcaebda388bb.jpg)

<br/>

---

## **VNET-VNET VpnGW 생성 실습**   <a name="a2"></a>  

**이번 실습에서는 다른 RG의 다른 Resource를 가지고 있는 VM을 VpnGW로 통신을 해보겠습니다.**  


<br/>

### **각 RG의 생성 Resource 정보**


<br/>

* **RG-VPN01** 

    * **VM01**
    * **Vnet01 (East US) - IP : 10.1.0.0/16 / Subnet : 10.1.0.0/24**
    * **VnetGW01 - IP : 10.1.255.0/27 / PIP -(PIP-VnetGW01)**



* **RG-VPN99** 

    * **VM99**
    * **Vnet99 (East Asia) - IP : 10.41.0.0/16 / Subnet : 10.41.0.0/24**
    * **VnetGW99 - IP : 10.41.255.0/27 / PIP -(PIP-VnetGW99)**


<br/>

---

### **Vnet 생성** 

**각각의 RG 그룹에 위의 정보에 맞게 Vnet Resource를 생성합니다.**  


<br/>

* **VM01의 Vnet**

    ![캡처555](https://user-images.githubusercontent.com/69498804/107916501-b9113180-6fa9-11eb-8ea6-4e5bfe2386ca.JPG)


<br/>

* **VM99의 Vnet**

    ![캡처666](https://user-images.githubusercontent.com/69498804/107916575-d8a85a00-6fa9-11eb-9b64-9861a43c21cd.JPG)

<br/>

---


### **Virtual Network Gateway 생성**  


**Vnet과 동일하게 각각의 RG 그룹에 위의 정보에 맞게 Gateway 를 생성합니다.**  


* **VM01의 Gateway** 

    ![캡처777](https://user-images.githubusercontent.com/69498804/107916831-4a80a380-6faa-11eb-84e4-2a5150e35b32.JPG)

<br/>

* **VM99의 Gateway** 

    ![캡처888](https://user-images.githubusercontent.com/69498804/107916889-66844500-6faa-11eb-94cf-ad2a420f1f26.JPG)


<br/>

---

#### **Vnet <-> VnetGW 연결 구성**   

**위에 진행한대로 VNet, VnetGW를 모두 생성했으면 이제 connection을 만들 수 있습니다.**  
**지금 진행하는 과정은 동일한 구독에 있는 Vnet Resource 에 대해서만 작동하기 때문에.**  
**만약 생성한 Vnet이 다른 구독에 있는 경우엔 PowerShell 을 이용해 연결 해야 합니다.**  
**그러나 지금 같이 VNet이 동일한 구독의 다른 RG인 경우 포털을 사용하여 연결할 수 있습니다.**   
**그럼 이제 VNet1과 VNet2에 connection 만들겠습니다.**  

<br/>

* **Connection 생성 [생성한 GW01의 Connections Blade에 Add]** 

    ![캡처44](https://user-images.githubusercontent.com/69498804/107913101-1c4b9580-6fa3-11eb-845f-f556f6c449aa.JPG)


  
<br/>

* **Connection Create Blade에서 Second VnetGW 설정** 
    
    ![캡처89999](https://user-images.githubusercontent.com/69498804/107917614-8d8f4680-6fab-11eb-9ac8-b072666ab650.JPG)

    * **Second Virtual network gateway : 연결 할 VnetGW** 
    * **PSK : 연결에 사용할 공유 키**


<br/>


* **Second Virtual Network gateway tab에서 다음과 같이 VM99를 선택해 추가합니다.**

    ![캡처9999](https://user-images.githubusercontent.com/69498804/107917758-cc250100-6fab-11eb-92ec-e04ef6c6eb15.JPG)



<br>


### **위와 동일한 방법으로 VM99의 VnetGW에도 Connection을 추가해줍니다.** 


<br/>


* **모든 Connection 을 추가 한 뒤 Status를 확인해보면 다음과 같이 Connected로 연결됩니다.**

    ![캡처99879897](https://user-images.githubusercontent.com/69498804/107918407-f3300280-6fac-11eb-806a-5266f5628f45.JPG)

<br/>

* **Connection 1에 들어가 자세한 정보를 확인해봅시다.**

    ![캡처222](https://user-images.githubusercontent.com/69498804/107918531-325e5380-6fad-11eb-9ac0-00c560701e6e.JPG)

    * **Virtual network gateway 1에는 VM01에 해당하는 VnetGW가 연결 되어있고**
    * **Virtual network gateway 2에는 VM99에 해당하는 VnetGW가 연결 되어 있습니다.**
    * **Data in : 들어온 Data가 없어 0으로 표시됩니다.** 



<br/>

---

### **간단하게 VM01 -> VM99로 Ping(IGMP) TEST를 해봅시다.!!**

<br/>

* **VM01 (10.1.0.4)에 접속한 뒤 VM99의 IP인 10.41.0.4으로 Ping!**

    ![캡처232323](https://user-images.githubusercontent.com/69498804/107920087-b0bbf500-6faf-11eb-9b63-d2099dc0b17a.JPG)

    **정상적으로 다른 RG, Region, IP 대역과 통신이 되는 것을 확인합니다!!** 


<br/>

* **추가적으로 VnetGW01에서 Data in, Out에도 IGMP Packet 만큼의 로그가 찍히게 됩니다.**  

    ![캡처2222](https://user-images.githubusercontent.com/69498804/107920205-e82aa180-6faf-11eb-92ff-99e3582a0b28.JPG)

<br/>

---
