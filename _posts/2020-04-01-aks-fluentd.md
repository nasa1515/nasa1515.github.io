---
layout: post
title: "[AZURE] - AKS에 Helm Chart를 이용해 Fluentd 배포"
author: nasa1515
categories: AZURE
date: 2021-04-01 13:36
comments: true
cover: "/assets/1800-550.jpg"
tags: AZURE
---



## **AKS에 Helm Chart를 이용해 Fluentd 배포**


<br/>

**머리말**  

**Fluentd로 여러 Data들을 수집해오기 위해서 AKS에 배포를 해보겠습니다.**  





  


 
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


- [AKS Cluster 생성](#a1)
- [VSCODE Kubernetes extentions 사용](#a2)
- [Extentions 에 AKS 연결하기](#a3)

<br/>

--- 


## **AKS Cluster 생성**  <a name="a1"></a>  
  
**우선적으로 Cloud-shell or local에 azure login을 해야 합니다.**  
**저는 Window 노트북에 azure-cli를 설치 후 진행했습니다.**  

<br/>

* #### **Login to Azure**  

    ```
    # az login
    ```

    <br/>

* #### **구독을 여러개 가지고 있으면 Account에 Main 구독을 설정해야 합니다.**  

    ```
    # az account set --subscription "구독이름" 
    ```

    <br/>

* #### **Resource Group을 만든 후 AKS Cluster를 생성합니다.**  

    ```
    # az group create --name k8s --location korea-central
    # az aks create --name nasa1515 --resource-group k8s --node-count 2 --generate-ssh-keys 
    ```

    <br/>

* #### **Cluster 생성이 완료되었으면 cli를 설치합니다.**  

    ```
    # sudo az aks install-cli
    ```
    
    <br/>

* #### **Cloud shell(cli)에서 AKS Cluster의 Credential을 받아 옵니다.**  

    ```
    # az aks get-credentials --name nasa1515 --resource-group k8s
    ```

<br/>


## **Helm Install**  

**저의 경우에는 Fluentd를 [bitnami](https://bitnami.com/stack/fluentd/helm) Chart를 이용하여 설치 예정입니다.**  
**AKS의 경우 이미 helm이 배포되어 있어 굳이 설치하지 않아도 됩니다.**  



<br/>

* #### **Helm repo 추가 및 업데이트** 

    ```
    # helm repo add bitnami https://charts.bitnami.com/bitnami
    # helm repo update
    ```

    <br/>

* #### **Test 용으로 Install 진행**  

    ```
    # helm install nasafl bitnami/fluentd
    ```

    **정상 배포 되었습니다!!** 
    ![111](https://user-images.githubusercontent.com/69498804/113230237-8b6f1600-92d3-11eb-8fea-5e7f7a36ef32.JPG)

    <br/>

* #### **test 용으로 Install한 Chart는 다음과 같이 지울 수 있습니다.**  

    ```
    # helm delete nasafl
    ```