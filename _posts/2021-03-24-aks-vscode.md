---
layout: post
title: "[AZURE] - VSCODE로 Cloud PaaS k8s (AKS) 관리하기"
author: nasa1515
categories: AZURE
date: 2021-03-19 13:36
comments: true
cover: "/assets/1800-550.jpg"
tags: AZURE
---



## **VSCODE로 Cloud PaaS k8s (AKS) 관리하기**


<br/>

**머리말**  

**추후에 Kafka를 k8s Cluster 환경에서 설치 및 구동을 해보려고 합니다.**  
**그래서 일단 YAM을 더 효율적이게 생성하기 위해 VSCODE와 AKS를 연결해봅시다.**  





  


 
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


- [AKS 구성](#a1)
- [VSCODE Kubernetes extentions 사용](#a2)
- [Extentions 에 AKS 연결하기](#a3)

<br/>

--- 


## **Preview : VSCODE를 사용해 k8s를 관리한다면?**  

![nasagif](https://user-images.githubusercontent.com/69498804/112405756-40468780-8d56-11eb-923c-2eb754abb929.gif)


* **위처럼 pod, service 등의 yaml 형식을 자동으로 정의해 편리하게 사용 가능**  
* **굳이 명령어를 치지 않고도 배포 및 상태 확인이 가능**  
* **yaml manifest 모아서 관리 한 뒤 helm Chart를 만들기 간편하다.**  

### **그냥 겁나 편하다**  

<br/>

---

## **AKS 구성**   <a name="a1"></a>     

#### **아래 Azure의 공식 DOC로 CLI, Portal을 이용해서 AKS Cluster를 구축합니다.** 

* #### **[Azure AKS DOC](https://docs.microsoft.com/ko-kr/azure/aks/kubernetes-walkthrough)**  
* #### **[Azure Portal 용 AKS DOC](https://docs.microsoft.com/ko-kr/azure/aks/kubernetes-walkthrough-portal)**


<br/>


* #### **Cluster 생성되면 아래와 같이 RG와 Resource들이 생성됩니다.**  

    ![123](https://user-images.githubusercontent.com/69498804/112254765-762b3380-8ca4-11eb-88b9-b64266de090c.JPG)

    * **k8s : AKS Resource가 있는 RG** 
    * **MC_k8s_nasa1515_koreacentral : AKS의 실제 VMSS나 PIP들의 Resource가 있는 RG**  


<br/>


* #### **이제 Cloud shell에서 kubelet 명령어를 입력해보려는데 ERROR가 발생합니다.**  

    ![캡처](https://user-images.githubusercontent.com/69498804/112254836-9529c580-8ca4-11eb-9edf-f971a165e43b.JPG)

    * **Cloud shell에서 AKS에 연결하기 위해선 Credentials이 필요하기 때문입니다.**  

<br/>

* #### **다음 명령어로 credentials을 가져 올 수 있습니다.**

    ```
    az aks get-credentials --resource-group [myResourceGroup] --name [myAKSCluster]
    ```

<br/>

* #### **Credentials을 가져온 뒤 정상적으로 kebectl 명령이 실행됩니다.**

    ![캡처2](https://user-images.githubusercontent.com/69498804/112256786-97d9ea00-8ca7-11eb-90a6-56a7150ef2b7.JPG)

<br/>


* #### **사실 이미 VSCODE의 Azure extentions을 이용해 Cloud shell에 연결해 사용 가능합니다.**  

    ![캡처3333](https://user-images.githubusercontent.com/69498804/112258604-1afc3f80-8caa-11eb-8641-fe03947a05a8.JPG)

    * **다만 저는 CloudShell의 불편함을 해결하고, 왼쪽의 File list에서 여러 yaml 을 관리하고 싶습니다.**  



<br/>

---

### **VSCODE Kubernetes extentions 사용** <a name="a2"></a>   


#### **그래서 VSCODE의 Kubernetes extentions을 사용해 AKS와 직접 연결하겠습니다.**  


* #### **[설정 가이드](https://mountainss.wordpress.com/2018/07/17/create-azure-kubernetes-cluster-and-manage-in-visual-studio-code-vsc-kubernetes-cloud/)** 



    #### **위의 링크에서 설명하는 방법은 다음과 같습니다.**  

    * #### **1. AKS Cluster 생성** 
    * #### **2. Local에 Azure CLI 설치**
    * #### **3. vscode에 kubernetes extentions 설치** 
    * #### **4. kubernetes extentions을 사용해 AKS와 직접 연결** 

    <br/>


    #### **1,2번 작업은 이미 완료했다고 가정하고** 
    #### **2번 작업 이후 local 에서 Azure cli에 연결해야 합니다.**  

<br/>

* #### **az aks install-cli** 

    ![캡처4](https://user-images.githubusercontent.com/69498804/112259140-1ab07400-8cab-11eb-9abc-8341b85fff04.JPG)

    <br/>

* #### **az login 명령으로 azure 로그인**

    ```
    # az login
    ```

    ![캡처5555](https://user-images.githubusercontent.com/69498804/112259289-5f3c0f80-8cab-11eb-906e-ccc957cdc10e.JPG)


<br/>


* #### **AKS의 Credentials 가져오기**  

    ```
    E az aks get-credentials --resource-group k8s --name nasa1515 
    ```

    ![캡처666](https://user-images.githubusercontent.com/69498804/112259355-80046500-8cab-11eb-8a94-b990a1a72a08.JPG)


    <br/>

* #### **AKS의 dashboard 실행시키기**  

    ```
    az aks browse --resource-group k8s --name nasa1515
    ```

    ![캡처6666](https://user-images.githubusercontent.com/69498804/112259585-e5585600-8cab-11eb-903d-e05c85c33f60.JPG)
    

<br/>

---

### **Extentions 에 AKS 연결하기**  <a name="a3"></a>  


* #### **위의 작업을 완료하면 vscode의 extentions에서 다음과 같이 구독이 표시됩니다.**  

    ![캡처77777](https://user-images.githubusercontent.com/69498804/112259771-2ea8a580-8cac-11eb-87a4-b88237ea493f.JPG)


    <br/>


* #### **정상적으로 Cluster를 추가했으나 옆에 Cluster 목록에 뜨지 않는 이슈가 발생.**  

    ![캡처32323](https://user-images.githubusercontent.com/69498804/112261431-31f16080-8caf-11eb-835b-f4b44fe0a015.JPG)

    * **vscode에서 kubectl.exe의 환경변수가 정상적으로 등록되지 않아서 발생.**  


<br/>

* #### **기본적으로 kubernetes extentions을 설치하면 아래 위치에 tools이 설치됩니다.**

    ![1231211](https://user-images.githubusercontent.com/69498804/112275393-e8127580-8cc2-11eb-992a-69fcfddaa45c.JPG)

<br/>


* #### **해당 위치의 환경변수 설정이 자동으로 되지 않아 이슈가 발생.**

    ![MicrosoftTeams-image](https://user-images.githubusercontent.com/69498804/112275708-37f13c80-8cc3-11eb-8ae8-0aafe3abefcf.png)

    * **위처럼 window cmd console 에서도 kubectl 명령이 먹지 않습니다.**  


<br/>


* #### **[window 10] 고급 시스템 설정 -> 환경변수에서 ``path``에 해당 경로를 추가해줍니다.**  

    ![1112211211](https://user-images.githubusercontent.com/69498804/112276007-8f8fa800-8cc3-11eb-95e0-d96b91f86000.JPG)

    * **적용하고 나오기**  


    <br/>


* #### **이제 window cmd , vscode terminer에서 모두 kubectl이 사용 가능합니다.**  

    ![44444](https://user-images.githubusercontent.com/69498804/112276186-cebdf900-8cc3-11eb-8043-bc2bbf6d9fc0.JPG)


<br/>

---

### **이미 설치된 kubectl 말고도 따로 바이너리를 설치 할 수도 있습니다.**  

* **[가이드](https://kubernetes.io/ko/docs/tasks/tools/install-kubectl-windows/)**  

    <br/>

    **설치 방법은 다음과 같습니다.**  

    <br/>

    * **1. curl로 kubectl 바이너리 설치**  

        ```
        curl -LO https://dl.k8s.io/release/v1.20.0/bin/windows/amd64/kubectl.exe
        ```

        <br/>

    * **2. 바이너리 검증**  

        ```
        ### checksum file download 

        curl -LO https://dl.k8s.io/v1.20.0/bin/windows/amd64/kubectl.exe.sha256
        ```
        
        <br/>

    * **3. checksum file로 검증**  
        
        ```
        CertUtil -hashfile kubectl.exe SHA256
        type kubectl.exe.sha256
        ```

        ```
        ### 점검 결과 동일
        C:\Users\USER>CertUtil -hashfile kubectl.exe SHA256                                                                                                                                                                                   SHA256의 kubectl.exe 해시:                                                                                                                                                                                                            ee7be8e93349fb0fd1db7f5cdb5985f5698cef69b7b7be012fc0e6bed06b254d                                                                                                                                                                      CertUtil: -hashfile 명령이 성공적으로 완료되었습니다.                                                                                                                                                                                                                                                                                                                                                                                                                       C:\Users\USER>type kubectl.exe.sha256                                                                                                                                                                                                 ee7be8e93349fb0fd1db7f5cdb5985f5698cef69b7b7be012fc0e6bed06b254d                                                                                                                                                                      C:\Users\USER>
        ````

    <br/>

    * **4. kubectl version 확인** 

        ```
        C:\Users\USER>kubectl version --client
        Client Version: version.Info{Major:"1", Minor:"20", GitVersion:"v1.20.0", GitCommit:"af46c47ce925f4c4ad5cc8d1fca46c7b77d13b38", GitTreeState:"clean", BuildDate:"2020-12-08T17:59:43Z", GoVersion:"go1.15.5", Compiler:"gc", Platform:"windows/amd64"}
        ```


<br/>

---


* #### **환경변수 설정 후 동일하게 진행했지만 이번엔 다른 에러가 발생합니다.**  

    ![KakaoTalk_20210324_164952086](https://user-images.githubusercontent.com/69498804/112276614-49871400-8cc4-11eb-868e-0a7db41a3c2d.png)

    * **해당 경로에는 한글이나 깨질만한 언어로 생성된 것이 없었습니다.**  

<br/>


* #### **그래서 vscode kubenetes extentions의 config 설정을 확인하니**


    ![캡처444444](https://user-images.githubusercontent.com/69498804/112277112-c31f0200-8cc4-11eb-88df-e5b269b0b0d1.JPG)

    * **다음과 같이 settings.json이라는 file로 관리되고 있었습니다.**  



<br/>


* #### **해당 settings.json file은 실제 extentions 설정의 값을 그대로 반영합니다.**  

    ![캡처55555](https://user-images.githubusercontent.com/69498804/112277273-ee095600-8cc4-11eb-98b2-0dd559b6f7b7.JPG)

    * **그러나 다음과 같이 main path로 등록이 될 부분들은 빈칸이 되어야 했습니다.**  

        * **저의 경우에는 해당 칸들이 자동으로 undefined로 채워져 있었습니다.**  
    * **또한 이미 undefined로 채워져 있었을 경우**  
    **이후 빈칸으로 만든 뒤 저장을해도 setting.json 파일에서는 인식이 안되는 이슈가 있습니다.**  

<br/>


* #### **그래서 저는 settings.json file을 직접 수정했습니다.** 


    ```
    ## 해당 부분이 helm이나 kubectl들의 main 바이너리 위치를 읽는 부분입니다.

    "vs-kubernetes": {
    
    "vscode-kubernetes.helm-path.windows": "C:\\Users\\USER\\.vs-kubernetes\\tools\\helm\\windows-amd64\\helm.exe",
    "vscode-kubernetes.minikube-path.windows": "C:\\Users\\USER\\.vs-kubernetes\\tools\\minikube\\windows-amd64\\minikube.exe",
    "vs-kubernetes.kubeconfig": "undefined",    <<--- 지정하지 않고 undefined 로 둬야함
    "vscode-kubernetes.kubectl-path.windows": "C:\\Users\\USER\\.vs-kubernetes\\tools\\kubectl\\kubectl.exe"  <<--- 해당 환경 변수 문을 추가
    },
    ```


<br/>

* #### **위 까지 모든 설정을 완료했으면 가이드 대로 AKS 연결 시 정상 연결됩니다.**  

    ![222313121](https://user-images.githubusercontent.com/69498804/112278060-c23aa000-8cc5-11eb-8b3a-623f0f11f9ca.JPG)

    * **그럼 위처럼 vscode <-> aks cluster가 직접 연결되어 환경관리나 배포가 가능합니다.**  

<br/>
<br/>


* ### **추가 이슈 발생 : Cluster는 연결이되나 명령어 실행이 되지 않음**  
 

    ![캡처](https://user-images.githubusercontent.com/69498804/112402848-a03a2f80-8d50-11eb-8e70-eee856ff7a16.JPG)

    * **사실 ERROR만 봐도 알 수 있는 error 입니다.** 
    * **위의 Settings.json File에서 Config File의 위치를 지정해야함**  


<br/>

* #### **저의 최종 Settings.json File은 다음과 같습니다.** 

    ![캡처2](https://user-images.githubusercontent.com/69498804/112403164-425a1780-8d51-11eb-8132-c792deee9559.JPG)

<br/>


* #### **간단한 테스트 Yaml을 하나 생성해서 배포해보겠습니다.**  

    ![캡처3](https://user-images.githubusercontent.com/69498804/112403390-aa106280-8d51-11eb-97f5-f91408e8fa4d.JPG)

    <br/>

* #### **vscode에서 yaml 작성 후 Shift + Ctrl + P 입력 후 Create로 배포**

    ![캡처4](https://user-images.githubusercontent.com/69498804/112403539-ef349480-8d51-11eb-9239-54a97f38e4fc.JPG)

<br/>

* #### **실제 연결된 Cluster의 pod 목록에서도 확인히 가능합니다.**  

    ![캡처5](https://user-images.githubusercontent.com/69498804/112403663-2b67f500-8d52-11eb-9b83-57a2646d5bc9.JPG)

<br/>

* #### **또한 명령어로 입력하지 않고 클릭으로만 확인이 가능합니다.**  

    ![캡처6](https://user-images.githubusercontent.com/69498804/112403794-6c600980-8d52-11eb-895e-872580f22dea.JPG)


<br/>


---

## **마치며…**  

  
**환경변수의 문제의 경우 제 노트북 환경에서만 발생한 문제라 (검색해도 나오질 않음)**  
**꽤나 애를 먹었습니다. 결국은 하루를 사용해서 잘 해결하긴 했지만 돌이켜보면**  
**충분히 가지고 있는 지식만으로 1~2시간 내에 해결 할 수 있었던 문제 인 것 같습니다.**   
**다음에는 연결된 aks에 kafka를 구동시키는 포스트로 뵙겠습니다.**  





