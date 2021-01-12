---
layout: post
title: "[AZURE] SERVICE - 컴퓨팅, 네트워크.."
author: Lee Wonseok
categories: AZURE
date: 2021-01-12 13:36
comments: true
cover: "/assets/1800-550.jpg"
tags: AZURE
---



## [AZURE] SERVICE - 컴퓨팅, 네트워크...


**머리말**  
 
**이번 포스트부터 본격적으로 이론적인 내용에 대해서 공부했습니다.**  
**애저에만 있는 차별화된 기능들에 대해서 정리하려고 노력했습니다.**

 
---

**목차**

- [AZURE SERVICE](#a1)
- [Microsoft learn](#a2)
- [AZURE Portal](#a3)
- [Marketplace](#a4)


---

## **Azure Service**  <a name="a1"></a>

**인스턴스, 네트워크 등 3사 퍼블릭 클라우드가 제공하는 기능은 거의 동일 합니다.**  


* **AZURE 전체 서비스**

![azure-services](https://user-images.githubusercontent.com/69498804/104278532-19fda380-54ec-11eb-97fc-24f612788848.png)


<br/>


**가장 일반적으로 사용량이 많은 순으로 정리 해봤습니다.**

* **컴퓨팅**
* **네트워킹**
* **스토리지**
* **모바일**
* **데이터베이스**
* **웹**
* **IoT(사물 인터넷)**
* **빅 데이터**
* **AI**
* **DevOps**

<br/>


---

## **컴퓨팅(Computing)** 

*컴퓨팅 서비스는 회사가 Azure 플랫폼으로 이전하는 주된 이유 중 하나입니다. Azure에서는 애플리케이션 및 서비스를 호스팅하는 다양한 옵션을 제공합니다. 다음은 Azure의 컴퓨팅 서비스 예제입니다.*

**간단히 요약 : VM(인스턴스) SERVICE**

<br/>


**Azure 컴퓨팅 서비스 예제**  

|**서비스 이름**|**서비스 기능**|
|:---|---------|
|**Azure Virtual Machines**|Azure에서 호스트된 Windows 또는 Linux VM(가상 머신)|
|**Azure Virtual Machine Scale Sets**|Azure에서 호스트된 Windows 또는 Linux VM의 스케일링|
|**Azure Kubernetes Service**|컨테이너화된 서비스를 실행하는 VM을 위한 클러스터 관리|
|**Azure Service Fabric**|Azure 또는 온-프레미스에서 실행되는 분산 시스템 플랫폼|
|**Azure Batch**|병렬 및 고성능 컴퓨팅 애플리케이션을 위한 관리 서비스|
|**Azure Container Instances**|서버 또는 VM을 프로비저닝하지 않고 Azure에서 실행되는 컨테이너화된 앱|
|**Azure Functions**|이벤트 기반의 서버리스 컴퓨팅 서비스|


<br/>

## **네트워킹(Networking)**

*컴퓨팅 리소스를 연결하고 애플리케이션에 대한 액세스를 제공하는 것이 Azure 네트워킹의 주요 기능입니다. Azure의 네트워킹 기능에는 글로벌 Azure 데이터 센터의 서비스 및 기능을 외부 환경에 연결하는 다양한 옵션이 포함되어 있습니다.*

<br/>

**Azure 네트워크 서비스 예제**  

|**서비스 이름**|**서비스 기능**|
|:---|---------|
|**Azure Virtual Network**|수신 VPN(가상 사설망) 연결에 VM을 연결합니다.|
|**Azure Load Balancer**|애플리케이션 또는 서비스 엔드포인트에 대한 인바운드 및 아웃바운드 연결의 균형을 맞춥니다.|
|**Azure Application Gateway**|애플리케이션 보안을 강화하는 동시에 앱 서버 팜 제공을 최적화합니다.|
|**Azure VPN Gateway**|고성능 VPN 게이트웨이를 통해 Azure 가상 네트워크에 액세스합니다.|
|**Azure DNS**|매우 빠른 DNS 응답과 매우 높은 도메인 가용성을 제공합니다.|
|**Azure CDN**|전 세계 고객에게 고대역폭 콘텐츠를 제공합니다.|
|**Azure DDoS Protection**|Azure에서 호스트되는 애플리케이션을 DDoS(배포된 서비스 거부) 공격으로부터 보호합니다.|
|**Azure Traffic Manager**|전 세계 Azure 지역에 네트워크 트래픽을 분산합니다.|
|**Azure ExpressRoute**|고대역폭 전용 보안 연결을 통해 Azure에 연결합니다.|
|**Azure Network Watcher**|시나리오 기반 분석을 사용하여 네트워크 문제를 모니터링하고 진단합니다.|
|**Azure Firewall**|스케일링 성능에 제한이 없고 보안 수준이 높은 고가용성 방화벽을 구현합니다.|
|**Azure Virtual WAN**|로컬 사이트와 원격 사이트를 연결하는 통합 WAN(광역 네트워크)을 구축합니다.|


<br/>

## **스토리지** 

**Azure는 네 가지 기본 유형의 스토리지 서비스를 제공합니다.**

|**서비스 이름**|**서비스 기능**|
|:---|---------|
|**Azure Blob Storage**|비디오 파일이나 비트맵 같은 대규모 개체를 위한 스토리지 서비스|
|**Azure File 스토리지**|파일 서버처럼 액세스하고 관리할 수 있는 파일 공유|
|**Azure Queue 스토리지**|애플리케이션 간 메시지를 큐에 넣고 안정적으로 전달하기 위한 데이터 저장소|
|**Azure Table Storage**|스키마와 관계없이 비정형 데이터를 호스트하는 NoSQL 스토리지|

<br/>


**위의 스토리지 서비스는 모두 몇 가지 공통적인 특성을 가지고 있습니다.**
* **중복 및 복제 기능을 갖추고 있어 내구성 과 가용성이 뛰어납니다.**  
* **자동 암호화와 역할 기반 액세스 제어를 통해 보안을 유지 합니다.**
* **사실상 스토리지에 제한이 없으므로 확장성 이 뛰어납니다.**
* **유지 관리 및 사용자에 대한 중요한 문제를 관리 하고 처리합니다.**
* **HTTP 또는 HTTPS를 통해 전 세계 어디에서든 액세스 할 수 있습니다.**