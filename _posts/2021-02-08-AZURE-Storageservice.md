---
layout: post
title: "[AZURE] - Storage Service"
author: nasa1515
categories: AZURE
date: 2021-02-08 15:36
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


- [스토리지 서비스](#a1)
- [컨테이너 스토리지 (Blob) 생성](#a2)
- [File Share 스토리지 생성](#a3)

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


<br/>

### **Blob (컨테이너) Storage Service** 

<br/>

**구조화되지 않은 대량의 비정형 데이터를 저장하기 위한 개체 스토리지 솔루션입니다.**  
**원래는 Blob이란 이름을 사용했으나 최근에 컨테이너로 변경되었습니다.**  
**컨테이너 스토리지는 브라우저를 통해 이미지, 문서 파일에 직접 엑세스 하거나 저장할 경우**  
**동영상, 오디오 스트리밍, 로그파일 등을 분석하기 위한 데이터 저장 시나리오에 적합합니다.**

<br/>

* **컨테이너 스토리지의 리소스 관계**

    ![blob1](https://user-images.githubusercontent.com/69498804/107189039-06325800-6a2c-11eb-9105-45da19b6f7fc.png)


<br/>

---

## **컨테이너(Blob) 스토리지 생성** <a name="a2"></a>

<br/>

* **컨테이너 스토리지에 Blob 데이터를 저장하기 위해선 우선 컨테이너를 만들어야 합니다.**  


    ![캡처767676767](https://user-images.githubusercontent.com/69498804/107189266-717c2a00-6a2c-11eb-806c-7f633f01bf7c.JPG)


<br/>

**여기서 컨테이너는 Blob들을 그룹화 하는 논리적인 개념입니다.**  
**간단히 Blob 집합을 모아 놓은 논리적 개념으로 생각해야 합니다.**  

<br/>

* **컨테이너 생성 Option 설명**

    ![캡처89797898798798](https://user-images.githubusercontent.com/69498804/107189434-b902b600-6a2c-11eb-9fd6-f2ae73e54ff5.JPG)

    * **Name : 소문자, 문자와 "-"만 포함, 길이는 3~64자**

    * **Public access level : 컨테이너와 Blob에 익명 엑세스를 관리**

        * **Private : 기본, 익명 엑세스 제공 X**
        * **Blob : 인증 없이 읽을 수 있지만, Blob 목록 나열 x**
        * **Container : Blob을 읽을 수 있습니다.**

<br/>

* **컨테이너를 생성하더라도 스토리지 계정의 다음 부분이 허용되어야 합니다.**

    ![캡처89898898989](https://user-images.githubusercontent.com/69498804/107189964-84432e80-6a2d-11eb-96da-9b43345a8440.JPG)

<br/>


* **Blob 데이터 관리**  

    **컨테이너를 만들고 나면 2가지 방법으로 데이터를 관리 할 수 있습니다.**

    * **루트에 파일을 저장**
    * **폴더를 생성해 폴더 내에 파일을 저장**


<br/>


* **Blob 업로드 Blade의 Option을 살펴봅시다.**

    ![캡처899898989898989](https://user-images.githubusercontent.com/69498804/107190238-eac84c80-6a2d-11eb-9c19-91ce0b488720.JPG)

    * **1. File : 하나 이상의 파일 선택 가능**
    * **2. Authentication Type : Azure AD, Account Key 방식 제공**  
    * **3. Blob Type : 3가지 유형 존재, 변경 불가능**
        * **블록 blob : 텍스트나 이진 데이터 최대 4.75TiB**
        * **페이지 blob : 임의 엑세스 파일 VHD 파일, 최대 8TiB**
        * **추가 blob : 로그 파일 처럼 데이터를 추가**
    <br/>

    * **4.Block Size : 최대 50,000개의 블록을 지원, 기본 값은 4MB**

        ![987978987987978978](https://user-images.githubusercontent.com/69498804/107190749-8d80cb00-6a2e-11eb-8688-a816293b477c.JPG)
 
    <br/>

    * **5. Access tier : HOT,CooL을 선택 가능**
    * **6. Upload to folder : 폴더에 업로드**
    * **7. Encryption scope : Blob을 만들때 암호화 범위 지정**


<br/>

* **이제 컨테이너를 생성하고 임의의 텍스트 파일을 컨테이너에 업로드 해보겠습니다.** 

    ![캡처](https://user-images.githubusercontent.com/69498804/107191268-434c1980-6a2f-11eb-8e47-bba9999d3e2e.JPG)


<br/>

* **저는 NASA1515라는 폴더 안에 업로드 했습니다.**

    ![캡처2](https://user-images.githubusercontent.com/69498804/107191330-57901680-6a2f-11eb-9dbe-f471f683fa89.JPG)


<br/>

* **업로드 한 파일의 Overview Tab에서 정보들과, URL을 확인 가능 합니다.**

    ![캡처3](https://user-images.githubusercontent.com/69498804/107191414-78f10280-6a2f-11eb-8f21-04048ff63ff8.JPG)


<br/>

* **URL로 접속 해보면 다음과 같이 임시 내용이 표시 됩니다.**

    ![44](https://user-images.githubusercontent.com/69498804/107191640-cbcaba00-6a2f-11eb-98fe-69e526bbfcb8.JPG)



<br/>


----



## **File Share 스토리지 생성** <a name="a3"></a>

**File Share는 아주 간단합니다. 이름, 할당량만 지정하면 됩니다.**  
**File Share는 윈도우, 리눅스, 맥OS에서 연결 할 수 있습니다.**  
**기본적으로 SMB 445 Port를 사용합니다.!!**

<br/>

* **저는 간단하게 Linux용 Windows Server용 2개를 만들었습니다.**

    ![캡처4444](https://user-images.githubusercontent.com/69498804/107192630-33cdd000-6a31-11eb-8b9f-fd7df573eb41.JPG)


<br/>

## **Windows Server 연결**

<br/>

* **그럼 만들어져 있는 Windows Server에 연결 한뒤 Windows PowerShell ISE를 실행합니다.**

    ![캡처222](https://user-images.githubusercontent.com/69498804/107193671-6cba7480-6a32-11eb-9f8a-a0d8ab32dd69.JPG)


<br/>

* **이제 연결 할 Fileshare의 Overview에서 Connect tab의 스크립트를 복사합니다.**

    ![캡처22313](https://user-images.githubusercontent.com/69498804/107193807-983d5f00-6a32-11eb-8d57-78def2a4eb43.JPG)

<br/>

* **Windows Service PowerShell에 스크립트를 입력하면 다음과 같이 연결됩니다.**

    ![캡처4444](https://user-images.githubusercontent.com/69498804/107194037-e3f00880-6a32-11eb-812c-b906e847e461.JPG)

<br/>

* **정상적으로 연결이 되었다면 다음과 같이 탐색기에서 확인이 가능합니다.**

    ![캡처55555](https://user-images.githubusercontent.com/69498804/107194195-139f1080-6a33-11eb-8393-1a3b781d9856.JPG)


---

## **리눅스 Server 연결**


<br/>

* **리눅스 서버의 경우도 동일하게 FileShare 스크립트를 복사해줍니다.**

    ![캡처878787](https://user-images.githubusercontent.com/69498804/107195250-70e79180-6a34-11eb-8a6e-d2b432a28204.JPG)

<br/>

* **리눅스 터미널에 스크립트를 입력 해줍니다.**

    ```
    nasa1515@vm-linux-nasa:~$ sudo mkdir /mnt/nasafile02                                                                    f [ ! -d "/etc/smbcredentials" ]; then                                                                                  sudo mkdir /etc/smbcredentials                                                                                          fi                                                                                                                      if [ ! -f "/etc/smbcredentials/nasa1515sa01.cred" ]; then                                                                   sudo bash -c 'echo "username=nasa1515sa01" >> /etc/smbcredentials/nasa1515sa01.cred'                                    sudo bash -c 'echo "password=RPXWVO/LhDiNhiTU0YsDa+wvooAXA1SdAfFD6PyWWeckzkmqSCvVyGPhRqX/keqSvWOgLYPzGK1t3NRViNg38w==" >> /etc/smbcredentials/nasa1515sa01.cred'                                                                            fi                                                                                                                      sudo chmod 600 /etc/smbcredentials/nasa1515sa01.cred                                                                                                                                                                                            sudo bash -c 'echo "//nasa1515sa01.file.core.windows.net/nasafile02 /mnnasa1515@vm-linux-nasa:~$ if [ ! -d "/etc/smbcredentials" ]; then                                                                                                        > sudo mkdir /etc/smbcredentials                                                                                        > fi                                                                                                                    nasa1515@vm-linux-nasa:~$ if [ ! -f "/etc/smbcredentials/nasa1515sa01.cred" ]; then                                     >     sudo bash -c 'echo "username=nasa1515sa01" >> /etc/smbcredentials/nasa1515sa01.cred'                              >     sudo bash -c 'echo "password=RPXWVO/LhDiNhiTU0YsDa+wvooAXA1SdAfFD6PyWWeckzkmqSCvVyGPhRqX/keqSvWOgLYPzGK1t3NRViNg38w==" >> /etc/smbcredentials/nasa1515sa01.cred'                                                                          > fi                                                                                                                    nasa1515@vm-linux-nasa:~$ sudo chmod 600 /etc/smbcredentials/nasa1515sa01.cred                                          nasa1515@vm-linux-nasa:~$                                                                                               nasa1515@vm-linux-nasa:~$ sudo bash -c 'echo "//nasa1515sa01.file.core.windows.net/nasafile02 /mnt/nasafile02 cifs nofail,vers=3.0,credentials=/etc/smbcredentials/nasa1515sa01.cred,dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab'     nasa1515@vm-linux-nasa:~$ sudo mount -t cifs //nasa1515sa01.file.core.windows.net/nasafile02 /mnt/nasafile02 -o vers=3.0,credentials=/etc/smbcredentials/nasa1515sa01.cred,dir_mode=0777,file_mode=0777,serverino                               nasa1515@vm-linux-nasa:~$                              
    ```

<br/>

* **Mount 위치로 이동해 TEST.txt파일을 생성해 봅시다.**


    ```
    nasa1515@vm-linux-nasa:/mnt/nasafile02$ pwd                                                                             /mnt/nasafile02                                                                                                         nasa1515@vm-linux-nasa:/mnt/nasafile02$                                                                                 nasa1515@vm-linux-nasa:/mnt/nasafile02$ touch test.txt                                                                  nasa1515@vm-linux-nasa:/mnt/nasafile02$ ls                                                                              test.txt                                                                                                                nasa1515@vm-linux-nasa:/mnt/nasafile02$ 
    ```

<br/>


* **정상적으로 생성되었다면 FileShare 스토리지를 확인해봅시다.**

    ![23243232432](https://user-images.githubusercontent.com/69498804/107195839-3500fc00-6a35-11eb-8b20-caa23b427b0d.JPG)

<br/>

---

## **이번 포스트에서는 Table, Queue 스토리지 실습을 다루지 않습니다.**


<br/>

<br/>


---

## **마치며…**  


**드디어 대장정의 기초 실습 부분들이 마무리 되었습니다.**  
**다음 포스트에서는 VM 크기조정, 가용성 구현입니다.**


