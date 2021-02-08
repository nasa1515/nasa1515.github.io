---
layout: post
title: "[AZURE] - Storage Service"
author: nasa1515
categories: AZURE
date: 2021-02-08 14:36
comments: true
cover: "/assets/1800-550.jpg"
tags: AZURE
---



## **Storage Service**


<br/>

**머리말**  
  
**앞서 스토리지 계정에 대해서 다뤄봤습니다.**  
**이번 포스트에서는 생성한 스토리지 계정을 기반으로 스토리지 서비스를 생성해봅시다.** 

 
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

---



**목차**


- [스토리지 서비스](#a1)
- [스토리지 계정(Storage Account)](#a2)
- [스토리지 계정(Storage Account) 생성](#a3)

--- 

<br/>

## **스토리지 Service**   <a name="a1"></a>

<br/>

**위에서 StorageV2 범용 계정을 생성했다면 기본적으로 모든 스토리지 서비스를 제공합니다.**  
**각 스토리지 서비스는 HTTP/HTTPS를 통해 어디서나 엑세스 할 수 있습니다.**  
**따라서 스토리지 서비스 마다 고유한 엑세스 URL을 제공합니다.** 

* **컨테이너(Blob)스토리지 : http://(스토리지 계정).blob.core.windows.net/**
* **파일 공유 스토리지 : http://(스토리지 계정).file.core.windows.net/**
* **큐 스토리지 : http://(스토리지 계정).queue.core.windows.net/**
* **테이블 스토리지 : http://(스토리지 계정).table.core.windows.net/**

<br/>

**이제 각 스토리지 서비스에 대해 살펴보겠습니다.**

