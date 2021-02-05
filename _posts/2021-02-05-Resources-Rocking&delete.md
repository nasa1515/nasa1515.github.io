---
layout: post
title: "[AZURE] - RG, Resource 잠금, 삭제하기"
author: nasa1515
categories: AZURE
date: 2021-02-05 13:36
comments: true
cover: "/assets/1800-550.jpg"
tags: AZURE
---



## **RG, Resource 잠금, 삭제하기**


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


- [RG, Resources 잠금](#a1)
- [RG, Respirces 삭제](#a2)



--- 

## **RG, Resources 잠금**   <a name="a1"></a>
