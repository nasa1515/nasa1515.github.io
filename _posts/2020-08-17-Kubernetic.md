---
layout: post
title: "[Kubernetes] - 1.17버전 이상 헬스 체크 에러 리포트"
author: nasa1515
categories: Kubernetes
date: 2020-08-16 12:36
comments: true
cover: "/assets/kubernets.jpg"
tags: Kubernetes
---



# K8S 1.17버전 이 후 헬스체크 에러 리포트


이번 포스트는 이전 K8S 설치 및 구성 포스트에서 정상적으로 설치 뒤에 발견된 이슈에 대한 리포트 입니다.  
github, 영문 리포트 사이트에서 여러가지 글이 있지만  
정확한 원인과 해결방법에 대한 댓글이 없어 리포트 합니다.

---

### **해결방법**

* **``해당이슈는 1.17버전`` 이후에서만 발생하는 이슈입니다.**  
    **버전을 낮춰 설치를 진행, 혹은 버그가 릴리즈 될 때까지 기다리는 수 밖에 없을 것 같습니다.**  

* **저는 1.16 버전으로 설치 후 정상 구동을 확인 했습니다.**

* **추가적으로 GCP같은 퍼블릭 클라우드의 환경에서만 발생하는건지  
기존의 레거시 설치 환경에서도 발생하는 건지는 테스트가 필요합니다.**

---

### **이슈 내용**


* **``K8S 1.17 이상의 버전``에서 헬스체크 이슈**  
    **``kubespray , adm``으로 기본 설치 이후 아래와 같이 헬스체크의 ``Unhealthy``에러 확인**

    ```
    kubectrl get cs
    ```

    ![스크린샷, 2020-08-24 09-52-12](https://user-images.githubusercontent.com/69498804/90993355-88020680-e5ef-11ea-8b59-6102415fec3f.png)


* **에러**

    ```
    $ kubectl get componentstatus
    NAME                 STATUS      MESSAGE                                                                                        ERROR
    controller-manager   Unhealthy   Get http://127.0.0.1:10252/healthz: dial tcp 127.0.0.1:10252: getsockopt: connection refused
    scheduler            Unhealthy   Get http://127.0.0.1:10251/healthz: dial tcp 127.0.0.1:10251: getsockopt: connection refused
    etcd-0               Healthy     {"health": "true"}
    ---
    ```

---

### **분석 결과**  

* **해당이슈는 아래와 같이 ``GoRang`` 코드 자체에 ``Port가 하드코딩`` 되어 있어   
``헬스체크만`` 되지 않을 뿐 실제 Pods, Replicaset등의 ``동작에는 영향이 없습니다``**  

    ![스크린샷, 2020-08-24 09-51-58](https://user-images.githubusercontent.com/69498804/90993350-859fac80-e5ef-11ea-9bf9-8d42a5cb7978.png)  

    **실제 서비스 포트는 ``10259``이지만 ``헬스체크는 10251,2 포트``로 연결하려고 함**

---

### **``github 에서 코드 확인``**  


* **``하드코딩 코드 확인``**

* **test/e2e/framework/ports.go**  

    ![스크린샷, 2020-08-24 10-09-04](https://user-images.githubusercontent.com/69498804/90993931-da442700-e5f1-11ea-9804-ddc3bf45a233.png)
    ![스크린샷, 2020-08-24 10-09-34](https://user-images.githubusercontent.com/69498804/90993943-eaf49d00-e5f1-11ea-870f-16e0652ab6a9.png)


    https://github.com/kubernetes/kubernetes/search?q=InsecureKubeControllerManagerPort&unscoped_q=InsecureKubeControllerManagerPort


* **``insecure`` 일때랑 포트가 다르게 쓰이는 코드로 보인다**
    

    ```
    /*
    Copyright 2014 The Kubernetes Authors.
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
        http://www.apache.org/licenses/LICENSE-2.0
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    */

    package ports

    import (
        "k8s.io/cloud-provider"
    )

    const (
        // ProxyStatusPort is the default port for the proxy metrics server.
        // May be overridden by a flag at startup.
        ProxyStatusPort = 10249
        // KubeletPort is the default port for the kubelet server on each host machine.
        // May be overridden by a flag at startup.
        KubeletPort = 10250
        // InsecureKubeControllerManagerPort is the default port for the controller manager status server.
        // May be overridden by a flag at startup.
        // Deprecated: use the secure KubeControllerManagerPort instead.
        InsecureKubeControllerManagerPort = 10252
        // KubeletReadOnlyPort exposes basic read-only services from the kubelet.
        // May be overridden by a flag at startup.
        // This is necessary for heapster to collect monitoring stats from the kubelet
        // until heapster can transition to using the SSL endpoint.
        // TODO(roberthbailey): Remove this once we have a better solution for heapster.
        KubeletReadOnlyPort = 10255
        // ProxyHealthzPort is the default port for the proxy healthz server.
        // May be overridden by a flag at startup.
        ProxyHealthzPort = 10256
        // KubeControllerManagerPort is the default port for the controller manager status server.
        // May be overridden by a flag at startup.
        KubeControllerManagerPort = 10257
        // CloudControllerManagerPort is the default port for the cloud controller manager server.
        // This value may be overridden by a flag at startup.
        CloudControllerManagerPort = cloudprovider.CloudControllerManagerPort
    )

    ```
    https://github.com/kubernetes/kubernetes/blob/462742fcf6732abf0c630422320b3972575bae59/pkg/master/ports/ports.go

----

### **추가적으로 ``aks``명령으로 해결했다는 리포트를 보아 시도해봤지만 해결되지 않았음**


* **내용은 다음과 같다**
![스크린샷, 2020-08-24 10-11-24](https://user-images.githubusercontent.com/69498804/90994011-2becb180-e5f2-11ea-9e7e-169a7a3cef4a.png)


    https://github.com/Azure/AKS/issues/173