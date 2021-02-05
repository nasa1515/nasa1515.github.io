---
layout: post
title: "[AZURE] - AAD & Tanant"
author: nasa1515
categories: AZURE
date: 2021-02-05 14:36
comments: true
cover: "/assets/1800-550.jpg"
tags: AZURE
---



## **AAD & Tanant**


<br/>

**머리말**  
  
**저번 포스트에서는 Resources 관리 부분에 대해서 실습 진행했습니다.**  
**이번 포스트는 AAD & Tanant 부분에 대해서 이론적 내용에 대해 진행하겠습니다.**  

 
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
    - [RG, Resource Locks, Delete](https://nasa1515.github.io/azure/2021/02/05/Resources-Rocking&delete.html)


<br/>

**목차**


- [AAD(Azure Active Directory)](#a1)
- [Azure 구독과 AAD Tanant의 역할](#a2)
- [RG, Respirces Delete](#a3)



--- 

<br/>

## **AAD(Azure Active Directory)**   <a name="a1"></a>

**AAD (Azure Active Directory)는 팀의 구성원이 로그인(인증)하고 권한에 따라(권한부여)  
리소스를 엑세스할 수 있게 해주는 ID & Access Management Service 입니다.**

<br/>

### **AAD <-> Tanant**

**Tanat(테넌트)는 사전적인 의미로 세입자, 입차임등을 뜻하지만**  
**특정 공간을 사용하는 사용자/그룹 등을 대표하는 용어입니다.**  
**Azure에서는 AAD의 사용자와 그룹 같은 보안 주체를 제공하는 디렉터리 전용 인스턴스를 뜻합니다.**

<br/>


**AAD는 사용자와 그룹, 인증, 권한 관리를 제공하며  
Azure에서 만든 Resource나 외부 APP, Service에 대한 Access Control을 제공합니다.**
**특히 구독 리소스를 관리할 때 구독과 연결된 AAD Tanant를 통해 항상 인증을 처리합니다.**  

<br>

**현재 Azure 에서는 4가지 종류의 라이센스를 제공하고 있습니다.**  

<br/>


---

* **Azure Active Directory Free**  

    - ***Azure, Microsoft 365 및 여러 SaaS 앱에 사용자 및 그룹 관리***  
    - ***온-프레미스 디렉터리 동기화*** 
    - ***기본 보고서***   
    - ***Self-Service 암호 변경 및 SSO(Single Sign-On)을 제공합니다.***  

<br/>

* **Office 365 (Microsoft 365 App)**  

    - ***AAD Free 기능 모두 포함***
    - ***Office 365 App용 ID 및 Access 관리***

<br/>

* **Azure Active Directory Premium P1.**  

    * ***AAD Free 기능 & Office 365 기능 모두 포함***  
    * ***Hybrid User에게 On-premise와 Cloud Resource 엑세스 제공***
    * ***On-Premise 사용자에 대한 Self-Service 암호 재설정 허용***
    * ***Self-Service 그룹 관리***
    * ***On-Premise ID 및 엑세스 관리 도구 모음***
    * ***동적 그룹***


<br/>

* **Azure Active Directory Premium P2.**  

    * ***AAD Free 기능 & Office 365  & P1 기능 모두 포함***  
    * ***ID 보고 기능을 통한 앱과 조직에 대한 위험 기반 조건부 엑세스***
    * ***권한 있는 ID 관리를 통한 관리자의 리소스 엑세스 검색 및 제한***

<br/>

---

<br/>

### **Azure 구독과 AAD Tanant의 역할** <a name="a2"></a>

<br/>

* **그림 참조**

    ![캡처](https://user-images.githubusercontent.com/69498804/106999361-64abcc00-67c9-11eb-8553-7c1090c263db.JPG)

    **사실 그림으로만 봤을때는 잘 이해가 가지 않는 것이 당연합니다** 

<br/>


* **간단한 비유와 예**

    ```
    그림에 대한 이해를 돕기 위해 간단한 예를 들어서 설명하겠습니다. 
    간단하게 구독과 테넌트를 집과 통장입니다.  
    구독은 월세 집과 관리비가 나가는 통장으로 볼 수 있습니다.
    특정 가전제품 (정수기등)을 렌탈했을때
    해당 렌탈비용이 나가는 것 역시도 관리비에 포함된다고 가정합시다.
    이때 렌탈한 가전제품이 Resource 입니다.

    또한 여러분은 월세집의 세대주이고, 가족이 존재합니다.
    가족들은 집을 마음대로 출입하고, 렌탈장비 역시 마음대로 사용해야 합니다.
    보통 가족임을 증명하려면 주민등록등본으로 쉽게 증명이 가능합니다.
    즉 가족이려면 등본에 등록이 되어야 한다는 말인거죠
    이렇게 등본에 등록하듯이 AAD에도 구성원을 등록하는 개념입니다.
    가족 구성원에도 개인 물품을 가지고 있고, 아이들이 만지면 안되는 위험한
    물건이 존재 할 수도 있습니다. 
    그때 개인이나 부모가 아이들이 물건에 접근 할 수 없게 범위를 제한해두죠
    마찬가지로 AAD가 해당 역할을 동일하게 Resource에 대한 접근 범위를 결정합니다.  

    추가적으로 출퇴근 하는 회사의 거리가 멀어서 회사 근처에 자취방을 잡았습니다.
    이는 마치 새로운 AAD를 만든 것과 동일합니다.
    자취방에는 접근 할 수 있는 사람을 동일하게 제한할 것이고
    자취방에서만 쓰는 렌탈장비(Resource)가 있을 수도 있죠 
    ```

---

<br/>

## **마치며…**  


**이번 포스트에서는 AAD와 Tanant의 개념에 대해서 이해하는 것을 목적으로 진행하였습니다..**  
**앞으로도 계속해서 Azure에 접근권한, 관리측면의 이론적인 내용에 대해서 다뤄보겠습니다.**


