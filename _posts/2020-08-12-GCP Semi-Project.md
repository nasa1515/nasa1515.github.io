---
layout: post
title: "[GCP] - Toy Project"
author: Lee Wonseok
categories: GCP
comments: true
cover: "/assets/GCP.png"
tags: GGP
---



#  GCP (Google Cloud Platform) 토이 프로젝트

**머리말**  
 GCP를 공부하기 위해 모인 사람들로 구성해서 간단한 토이 프로젝트를 진행해보았다.  
 리눅스를 처음 공부하듯 GCP에서도 웹페이지를 띄우는 프로젝트를 우선 진행해보았다.  
 
---

**목차**

- [프로젝트 개요](#a1)
- [서버 구축 순서](#a2)
- [서버 구축](#a3)
- [DB 구축](#a4)
- [DNS 구성](#a5)
- [오토스케일링 구축](#a6)
- [로드밸런서 구축](#a7)
- [서비스 동작 확인](#a8)


---

## 1. GCP를 사용한 웹 사이트 구축 토이 프로젝트   <a name="a1"></a>

* 사용기술
    
    * 인스턴스
    * SQL (VPC)
    * 로드밸런싱
    * 오토스케일링
    * HTTP/APACHE/MYSQL/Wordpress
    * DNS 


---

* **개요**  

    오토스케일링은 클라우드 환경의 가장 기본적 요소들 중에 하나이다.  
    트래픽 집중에 따라 서버, 스토리지 등의 자원이 자동으로 확장하면서  안정적인 서비스를 유지 할 수 있다.  
    서버의 개수가 늘어나는 것을 ``스케일 아웃 (scale out)``  줄어드는 것을 ``스케일 인 (scale in)``이라고 한다.  
    오토스케일링을 통해 트래픽에 따라 서버를 늘리고 줄이는 것을 자동화해  
    효율적으로 웹서버를 운영할 수 있는 프로젝트를 진행해보았습니다.  


----

* **Architecture**  

    오토스케일링이 가능한 웹서버를 구축하기 위해서 다음과 같이 구성했습니다.  
    먼저, 외부의 요청을 받을 글로벌 로드 밸런서를 구축했고 웹서버가 설치된 인스턴스 그룹이 필요합니다.  
    실제로 서비스 할 VM 인스턴스는 인스턴스 그룹의 설정 정보 (CPU 사용량 등 모니터링 메트릭)에 따라 인스턴스 템플릿을 통해 자동으로 생성이 되거나 삭제가 됩니다.  

    **프로젝트 서비스 아키텍처**



    ![아키](https://user-images.githubusercontent.com/64260883/89745329-0ccc2b00-daee-11ea-9c38-212150528a9b.png)


    ``Client`` : 웹서버에 접속하는 유저들  
    ``DNS`` : 특정 LB의 주소로 DNS를 구축해 로드밸런싱 될 수 있도록 구성  
    ``LB`` : 특정 웹서버의 CPU 사용량이 일정 수준을 넘어가면 오토스케일링 진행.  
    ``VPN`` : 특정 호스트만 관리자 웹서버에 접속하기 위한 보안 설정
---


## 2. 서버 구축 순서 <a name="a2"></a>

  1) 인스턴스 템플릿을 만들기 위해 VM 인스턴스를 생성합니다.  
    
  2) 생성된 VM 인스턴스에 웹서버를 설치합니다.  
    
  3) 웹서버에 GCP SQL을 이용해 DB를 공유시킵니다.  
 
  4) Wordpress 설정을 진행합니다.
   
  5) 웹서버가 설치된 인스턴스를 스냅샷으로 만듭니다.
    
  6) 생성된 스냅샷을 가지고 이미지를 만듭니다.
    
  7) 이미지를 가지고 인스턴스 템플릿을 생성합니다.
    
  8) 인스턴스 템플릿으로 인스턴스 그룹을 생성합니다.
    
  9) 로드 밸런서를 적용해 웹서버에 들어오는 트래픽을 부하분산 시킵니다.
    
  10) DNS 서버를 위한 인스턴스를 하나 생성합니다.
    
  11) DNS 를 위한 방화벽 설정 을 추가합니다.


----

## 3. 서버 구축 <a name="a3"></a> 

  **1. VM Instance 생성**  
  
  ![스크린샷, 2020-08-04 10-00-11](https://user-images.githubusercontent.com/64260883/89241265-5a9dea80-d639-11ea-8daf-15a819085531.png)


    GCP 콘솔에서 [Compute Engine]에서 [VM 인스턴스]를 선택 후  
    [인스턴스 만들기]를 클릭해서 인스턴스를 생성합니다.  
    VM 인스턴스는 아래와 같은 조건으로 생성합니다.      
    CLOUD SQL API를 이용할 것이기 때문에 API 허용 설정을 해줍니다.  
    VPC를 통해서 직접 DB를 연결 할 것이기 때문에 외부IP를 고정으로 예약합니다.  
    나머지 값들은 기본으로 둡니다.
    
  ---
    
  **2. WEB SERVER 구성**  
  
  [**LAMP 구성Permalink**]
  * **Wordpress를 위한 Apache, MySQL(MariaDB), PHP를 설치합니다**


  * **Apache**  

    [**아래 명령으로 업데이트 및 httpd 설치, 설정을 진행합니다**]

    ![스크린샷, 2020-08-04 10-19-08](https://user-images.githubusercontent.com/64260883/89242215-f7618780-d63b-11ea-8c85-aa504d02ffff.png)

    ```
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    firewall-cmd --add-service=http --permanent
    firewall-cmd --add-port=80/tcp --pernmanent
     ```

---

## 4. DB 구축 <a name="a4"></a> 

  [**VM 인스턴스에 MariaDB를 설치합니다**]

    yum install mariadb mariadb-server

* **API 설정**

    [**GCP의 SQL을 Web Server 인스턴스에 연동해 구성할 것이다**]  
    대쉬보드의 [API 및 서비스] - 라이브러리 탭에서  
    CLOUD SQL ADMIN API를 설치합니다.  


    ![스크린샷, 2020-08-04 10-25-09](https://user-images.githubusercontent.com/64260883/89242651-03017e00-d63d-11ea-972b-52f85721a5c2.png)
    
    
* **CLOUD SQL 생성**  
    
    [**MySQL, 리전을 인스턴스와 동일한 SQL 인스턴스를 생성**]  
    
    ![스크린샷, 2020-08-04 10-33-03](https://user-images.githubusercontent.com/64260883/89243033-e580e400-d63d-11ea-8ec0-be652ec77ae5.png)


    [**VPC로 인스턴트에 DB를 직접 연결 할 것이라 IP를 추가해줍니다**]  
    
    ![스크린샷, 2020-08-04 10-31-18](https://user-images.githubusercontent.com/64260883/89242922-a6529300-d63d-11ea-9b6d-8550cda05f52.png)


    [**인스턴트에서 연결 후 사용할 DB를 생성해줍니다.**]  
    
    ![스크린샷, 2020-08-04 11-11-39](https://user-images.githubusercontent.com/64260883/89245204-49f27200-d643-11ea-96d2-9c3dd9a33b90.png)

      # 구성 정보
    
      [DB Name : nasa1415]
      [DB IP : 34.64.187.52]
      [WEB SERVER : 35.216.67.219 (CENTOS 7) ]
      [Region : seoul]

---

* **PHP**  
    [**다음 명령으로 PHP를 설치합니다**]

      yum install epel-release
      rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
      yum install mod_php72w php72w-cli
      yum install php72w-bcmath php72w-gd php72w-mbstring php72w-mysqlnd php72w-pear php72w-xml php72w-xmlrpc php7

      php -v


    [**PHP가 7.2 버전으로 설치되었는지 확인합니다.**]  
    
    ![스크린샷, 2020-08-04 11-18-39](https://user-images.githubusercontent.com/64260883/89245659-427f9880-d644-11ea-91ee-439eff531fd2.png)

---

* **Wordpress**  
    [**다음 명령으로 Wordpress를 설치합니다**]  
    
    ![스크린샷, 2020-08-04 11-23-04](https://user-images.githubusercontent.com/64260883/89245906-e23d2680-d644-11ea-8509-173f27f49792.png)

      yum install -y wget
      wget "http://wordpress.org/latest.tar.gz"
      tar -xvzf latest.tar.gz -C /var/www/html
      chown -R apache: /var/www/html/wordpress


    **웹페이지 설정 - DB 연동**  
    
    [지정 DB NAME], [GCP SQL IP] 등을 입력 해 연동.
    ![aaa](https://user-images.githubusercontent.com/64260883/89596888-73a1d800-d893-11ea-99c6-a3b914465be1.png)

    [**연동 위해 인스턴트의 SELINUX 설정이 필요하다**]  
    [**본 포스트에서는 종료하고 진행하였음**]  
    
    ![sel](https://user-images.githubusercontent.com/64260883/89598140-055f1480-d897-11ea-9bef-0308dd5ef437.png)



    [**웹 설정 완료 후 홈페이지가 정상 동작 확인**]
    ![aaaaaa](https://user-images.githubusercontent.com/64260883/89598279-61c23400-d897-11ea-839f-d184557dfec8.png)


    [**홈페이지 동작 table이 생성, DB 정상 연동 확인**]  
    
    ![addddddddddddddddddd](https://user-images.githubusercontent.com/64260883/89598402-af3ea100-d897-11ea-9ffe-ca9986c66165.png)

----

## 5. DNS 구성 <a name="a5"></a>  

  실제 도메인을 구매하지 못해 내부 통신으로 DNS를 구축,  
  웹사이트에 매칭 시켜주도록 설정하였음.  


  * **[인스턴스 만들기]를 클릭해서 인스턴스를 생성합니다.**   

    **WEBServer와 동일하게 구성하였음.**  
    
    ![dbs](https://user-images.githubusercontent.com/64260883/89745943-ca0c5200-daf1-11ea-8ac0-29a9f9fb7826.png)

    GCP 기반의 서버이다 보니 ``DNS 네트워크를 내부로 고정``  
    
    ![ip](https://user-images.githubusercontent.com/64260883/89746273-cb3e7e80-daf3-11ea-8bc8-5c5d7fb80f46.png)

----

  **DNS SERVER 구축**

  * **기본적인 DNS 파일 설치 및 환경구성을 위한 명령.**


        yum -y install bind
        setenforce 0
        firewall-cmd --add-service=dns  --permanent 
        firewall-cmd --add-port=80/tcp --permanent 
        firewall-cmd --reload 

  * **네트워크 환경 변경**

        내부 IP로만 통신 할 예정이라 STATIC하게 설정 변경.
        nmcli connection modify eth0 ipv4.method manual 
        nmcli connection modify eth0 ipv4.addresses 10.178.0.16/32
        nmcli connection modify eth0 ipv4.gateway 10.178.0.1
        nmcli connection modify eth0 ipv4.method manual 
        nmcli connection modify eth0 ipv4.dns 10.178.0.16

  * **존파일 내용 확인**  
    **[로드밸런서 아이피를 삽입]**  
    
    ![aaaaaaaaa](https://user-images.githubusercontent.com/64260883/89758291-68b0a700-db22-11ea-99e6-6276c529d9c2.png)


  * **정상적으로 내부 도메인 통신이 되는지 확인.**  
  
    ![ㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜ](https://user-images.githubusercontent.com/64260883/89758746-787cbb00-db23-11ea-964c-26cccecb2df4.png)


  * **GCP는 외부 연결이 가능하게 방화벽 설정.**  
  
    ![스크린샷, 2020-08-10 16-16-02](https://user-images.githubusercontent.com/64260883/89759290-cba33d80-db24-11ea-9a3f-0b07e3b11269.png)


---

## 6. 오토스케일링 구축 <a name="a6"></a>  

  * **웹서버 종료 후 스냅샷 생성**  
  
    ![snap](https://user-images.githubusercontent.com/64260883/89753240-6f372280-db12-11ea-8d33-bf01ef7fe653.png)
  
  * **스냅샷으로 이미지 생성**  
  
    ![ima](https://user-images.githubusercontent.com/64260883/89753351-e8cf1080-db12-11ea-9706-dd36393456c9.png)

  * **이미지로 인스턴트 템플릿 생성**  
    [인스턴트 생성과 같지만 생성한 이미지 선택.]  
    
      ![aaaaaa](https://user-images.githubusercontent.com/64260883/89753520-96422400-db13-11ea-82f4-f1f9eea4246e.png)

  * **인스턴트 템플릿으로 그룹 생성**  
    [인스턴트 템플릿 선택 후 자동확장 모드 설정]   
    [자동 확장 모드 - 오토스케일링 기능]
    [측정 항목 - 오토스케일링 범위]  
    
      ![aqweqqweqweqw](https://user-images.githubusercontent.com/64260883/89754132-ac50e400-db15-11ea-9a0f-1009707f93aa.png)  

    [대기 시간 등 세부 설정 또한 가능하다.]  
      
      ![ㅁ123123123123](https://user-images.githubusercontent.com/64260883/89755145-5a11c200-db19-11ea-9794-22558669ce85.png)


    [추가적으로 자동복구 상태 확인을 생성한다.]  
    
      ![1111111111111111](https://user-images.githubusercontent.com/64260883/89755224-9fce8a80-db19-11ea-8a99-062438ea049d.png)


    [정상적으로 그룹이 생성되었다면 아래와 같이 그룹 별 인스턴트가 생성]  
    
      ![44444444444](https://user-images.githubusercontent.com/64260883/89755723-5da64880-db1b-11ea-87a6-38d3cf9afde4.png)

----

## 7. 로드밸런서 구축 <a name="a7"></a>    

  * **로드밸런서 생성**  
  ``[네트워크 서비스 - 부하분산 - 만들기]``   
  ``[웹서버의 트래픽을 부하분산을 위해 http 선택]``  
  
    ![5555555555555](https://user-images.githubusercontent.com/64260883/89755826-b544b400-db1b-11ea-9643-1e5a4a37df9a.png)  


  * **백앤드 서비스 생성**  
  
    ![bbab](https://user-images.githubusercontent.com/64260883/89755992-356b1980-db1c-11ea-8cf4-ba58d148c84a.png)

    [추가적을 상태확인에서 아까 만든 상태확인을 사용한다]  
    
      ![xxxxxxxxxxxx](https://user-images.githubusercontent.com/64260883/89756099-7bc07880-db1c-11ea-9c87-a7df902e6fee.png)

  * **프론트앤드 서비스 생성**  
  
    ![vvvvvvvvvvvvv](https://user-images.githubusercontent.com/64260883/89756153-af030780-db1c-11ea-99b6-f86d61bccb06.png)

  * **오토 스케일링 정상 동작 확인**  
  ``[스트레스 스크립트로 CPU과부화를 주었을 경우 동작 확인]``  
  
    ![999999999999](https://user-images.githubusercontent.com/64260883/89756237-de197900-db1c-11ea-8a9c-fa6189cbead7.png)

  * **생성된 로드밸런서를 설정 및 IP를 확인한다**  
  ``[로드밸러서 IP를 사용해 DNS 부하분산을 위한.]``  
  
    ![ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ](https://user-images.githubusercontent.com/64260883/89756384-48321e00-db1d-11ea-98b2-80e0d496bc5f.png)

-----

## 8. 서비스 동작 확인 <a name="a8"></a>    

  * **웹사이트 정상 동작 확인**  
  [임의로 워드프레스 기반으로 만든 웹페이지가 정상 동작]  
  [DNS의 경우 내부로 통신을 했기에 ``DNS 공인IP를 외부서버에 추가``해줘야함]  
  
    ![스크린샷, 2020-08-10 16-11-44](https://user-images.githubusercontent.com/64260883/89759020-343dea80-db24-11ea-8a5e-63d4719a11af.png)

  * **웹사이트 정상 동작 확인**  
  
    ![스크린샷, 2020-08-10 16-13-33](https://user-images.githubusercontent.com/64260883/89759139-7404d200-db24-11ea-8bbf-1723e70f4521.png)


  * **VPN 설정 후 정상 동작 확인**  
  
    ![스크린샷, 2020-08-10 16-14-51](https://user-images.githubusercontent.com/64260883/89759221-a44c7080-db24-11ea-90f6-812e3ec63ec7.png)


  * **로드밸런싱 동작 확인**  

    [**로드밸런싱 설정 전 트래픽**]  
    
      ![스크린샷, 2020-08-10 16-51-16](https://user-images.githubusercontent.com/64260883/89761607-b846a100-db29-11ea-9a06-c104b4efccc4.png)

    [**로드밸런싱 설정 후 트래픽**]  
    
      ![스크린샷, 2020-08-10 16-51-42](https://user-images.githubusercontent.com/64260883/89761632-c72d5380-db29-11ea-9a5c-409d182ac80b.png)  

----