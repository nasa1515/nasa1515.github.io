---
layout: post
title: "[Kubernetes] - GCP 기반 k8s환경구성 - [kubeadm]"
author: nasa1515
categories: Kubernetes
date: 2020-08-16 09:36
comments: true
cover: "/assets/kubernets.jpg"
tags: Kubernetes
---



#  KUBERNETES - GCP 기반의 k8S 환경구성 - [kubeadm]
**머리말**  
이전 포스트에서는 kubespay 자동화 툴을 사용해서 K8S 클러스터를 구축했었다.  
이번 포스트에서는 kubeadm을 이용해서 K8S 클러스터를 구축하는 방법에 대해서 포스트했다.  


   
 
---

**목차**

- [사전준비](#a1)
- [구성 (Install)](#a2)
- [사전 작업하기](#a3)
- [쿠버네티스  설치하기 [kubeadm]](#a4)
- [WORKER 노드 설정](#a5)
- [설치 후 동작 테스트](#a6)


WORKER 노드 설정


---

## 사전준비   <a name="a1"></a>

* **쿠버네티스는 3개월 마다 새로운 버전이 릴리즈 되고**  
       **해당 버전은 9개월 동안 버그와 보안 이슈를 수정하는 패치가 이루어집니다.**  


* **이번 포스트에 구성할 노드는 ``Master 노드 하나``와 ``Worker 노드 세 개``로  
    총 ``네 개``의 서버가 필요합니다.**

* **노드의 최소 요구 사양은 다음과 같습니다.**


    |항목|사양|
    |---|-------|
    |CPU|	1 CPU 이상
    |메모리|	2 GB 이상
    |OS|	CentOS 7, RHEL 7, Ubuntu 16.04+ etc.

---

* **또한 각 서버는 다음 조건을 만족해야 합니다.**

    * **각 노드가 서로 ``네트워크 연결``되어 있어야 합니다.**
    * **각 노드는 다음 ``정보가 겹치지 않아야`` 합니다.**

        ```
        hostname: hostname
        MAC address: ip link 또는 ifconfig -a
        product_uuid: sudo cat /sys/class/dmi/id/product_uuid
        ```

* **각 노드가 사용하는 ``포트``입니다. ``각 포트는 모두 열려`` 있어야 합니다.**

    |노드	|프로토콜|	방향|	포트 범위|	목적|	누가 사용?|
    |--|--|--|--|:-----:|:-----:|
    |Master|	TCP|	Inbound|	6443|	Kubernetes API server|	All
    |Master|	TCP|	Inbound|	2379-2380|	etcd server client API|	kube-apiserver, etcd
    |Master|	TCP|	Inbound|	10250|	Kubelet API	|Self, Control plane
    |Master|	TCP|	Inbound|	10251|	kube-scheduler|	Self
    |Master|	TCP|	Inbound|	10252|	kube-controller-manager|	Self
    |Worker|	TCP|	Inbound|	10250|	Kubelet API	|Self, Control plane
    |Worker|	TCP|	Inbound|	30000-32767|	NodePort Services|	All|



 ---

* **GCP VM 노드 정보**


    |구분	|호스트네임|	역 할	|
    |---|-----|---|
    |1	|nasa-master|Master 노드,  Ansible 제어 노드 및 작업자용 노드
    |2	|nasa-node1|Worker 노드
    |3  |nasa-node2 |Worker 노드	 
    |4	|nasa-node3|Worker 노드 
    

 

---

## 구성 (Install)  <a name="a2"></a>  

### **구성 전 안내**
* **쿠버네티스를 처음으로 만들고, 공개한 회사가 구글이나 보니 구글 클라우드인  
 ``GCP``에서도 ``Kubernetes Engine``란 이름으로 쿠버네티스를 사용할 수 있는 서비스를 제공하고 있습니다.**

    ![스크린샷, 2020-08-20 12-34-57](https://user-images.githubusercontent.com/69498804/90713985-91cef580-e2e1-11ea-98f2-09c7e0f72c9f.png)

* **실제 해당 메뉴에 들어가보면 이렇게 설치 없이 바로 클러스터를 만들 수 있습니다.**
![스크린샷, 2020-08-20 12-36-07](https://user-images.githubusercontent.com/69498804/90714040-ba56ef80-e2e1-11ea-91a7-51616910e81e.png)

* **하지만 이번 포스트에서는 쿠버스프레이를 이용한  
구성방법을 포스팅 할 것이기 때문에 해당 서비스는 넘기겠습니다.**

---

### Compute Engine 환경 설정 

* **``GCP Console``에 접속합니다.**  

* **``INSTANCE`` 동일하게 4개 생성해보겠습니다. [구성 방법은 "GCP포스트"!!!](https://nasa1515.github.io/gcp/2020/08/10/GCP-1.html)** 
![스크린샷, 2020-08-20 14-20-27](https://user-images.githubusercontent.com/69498804/90719826-4e2fb800-e2f0-11ea-94d4-b8f9dc1d31f4.png)

---

* **아래 처럼 인스턴스 4개를 생성 완료했습니다.**

    ![스크린샷, 2020-08-20 14-24-55](https://user-images.githubusercontent.com/69498804/90720126-eded4600-e2f0-11ea-963e-c7d5203642b8.png)


---

### **사전 작업하기** <a name="a3"></a> 

**사전 작업은 master, node1, node2 모두 동일하게 진행합니다.**

* **사전 작업의 모든 과정은 ``root`` 권한으로 진행합니다.**

    ```
    sudo su -
    ```


* **스왑 메모리 사용 중지**  
    **``Swap`` 은 디스크의 일부 공간을 메모리처럼 사용하는 기능입니다.**  
    **``Kubelet`` 이 정상 동작할 수 있도록 swap 디바이스와 파일 모두 ``disable`` 합니다.**

    ```
    swapoff -a
    echo 0 > /proc/sys/vm/swappiness
    sed -e '/swap/ s/^#*/#/' -i /etc/fstab
    ```

    **``swapoff -a``: paging 과 swap 기능을 끕니다.**  
    **``/proc/sys/vm/swappiness``: 커널 속성을 변경해 swap을 disable 합니다.**  
    **``/etc/fastab``: Swap을 하는 파일 시스템을 찾아 disable 합니다.**

---

* **각 노드의 통신을 원활하게 하기 위해 ``방화벽을 해제``합니다.**

    ```
    systemctl disable firewalld
    systemctl stop firewalld
    ```

* **``SELinux(Security-Enhanced Linux)``를 꺼줍니다.**   
**컨테이너가 호스트의 파일시스템에 접속할 수 있도록 해당 기능을 꺼야 합니다.**

    ```
    setenforce 0
    sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

    ```


* **``RHEL`` 과 ``CentOS 7``에서 ``iptables`` 관련 이슈가 있어 ``커널 매개변수``를 다음과 같이 수정하고 적용합니다.**

    ```
    cat <<EOF >  /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    EOF
    sysctl --system
    ```

* **``br_netfilter 모듈``을 ``활성화``합니다.**  
    **``modprobe br_netfilter 명령어``로 해당 모듈을 명시적으로 ``추가``하고  
    ``lsmod | grep br_netfilter`` 명령어로 추가 여부를 ``확인``할 수 있습니다.**

    ```
    modprobe br_netfilter
    ```


---
### **SSH(RSA) 접속을 위한 공개키를 공유해줘야 합니다.**

* **각 인스턴스 별로 ``호스트 네임``을 설정해줍니다.**  
    **사실 GCP는 자동적으로 인스턴스의 이름을 받아오지만  
    GCP가 아닌 직접 구성을 할 경우에는 호스트네임을 모두 바꿔주어야 합니다.**

    ```
    [h43254@nasa-node3 ~]$ hostnamectl set-hostname nasa-node3
    [h43254@nasa-node3 ~]$ hostname
    nasa-node3
    ```

* **``MASTER`` 인스턴스에 HOST 정보 및 SSH 권한 설정을 합니다.**  
    **GCP에서는 할 필요가 없지만 직접 구성시에는 필요합니다.**


*   **``/etc/hosts``에 각 노드 등록**
    ```
    [h43254@nasa-master ~]$ sudo cat /etc/hosts
    127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
    ::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
    10.146.0.2      nasa-master
    10.146.0.3      nasa-node1
    10.146.0.4      nasa-node2
    10.146.0.5      nasa-node3
    ```

---

* **``공개키 설정``을 위해서 SSH 버튼을 눌러서 ``nasa-master``에 접속해  
    ``ssh-keygen -t rsa``를 입력해 공개키를 생성합니다.**  

    **(그 외에 옵션은 Enter를 눌러서 기본값을 넣어줍니다.)**

    ```
    [h43254@nasa-master ~]$ ssh-keygen -t rsa
    Generating public/private rsa key pair.
    Enter file in which to save the key (/home/h43254/.ssh/id_rsa): 
    Enter passphrase (empty for no passphrase): 
    Enter same passphrase again: 
    Your identification has been saved in /home/h43254/.ssh/id_rsa.
    Your public key has been saved in /home/h43254/.ssh/id_rsa.pub.
    The key fingerprint is:
    SHA256:sr6RS6MW/ESkXfbVBi9LTdRSfPm3a2F7VrC9K8e93mc h43254@nasa-master
    The key's randomart image is:
    +---[RSA 2048]----+
    |            .+o+o|
    |      . o   .++.+|
    |     + o . .o.o.o|
    |    . o   .. o. o|
    |   . .. S   .  +o|
    |    o .+      .+o|
    |     +*       o B|
    |    .+.+     . BE|
    |   .. +.      =**|
    +----[SHA256]-----+
    ```

* **키가 잘 만들어 있는지 확인하기 위해서 아래 명령어로 확인합니다.** 

    ```
    [h43254@nasa-master ~]$ cd .ssh
    [h43254@nasa-master .ssh]$ ls -al
    total 8
    drwx------. 2 h43254 h43254   38 Aug 20 05:31 .
    drwx------. 3 h43254 h43254   74 Aug 20 05:28 ..
    -rw-------. 1 h43254 h43254 1679 Aug 20 05:30 id_rsa
    -rw-r--r--. 1 h43254 h43254  400 Aug 20 05:30 id_rsa.pub       ## 정상 생성.
    ```
---
    
* **아래 명령어를 통해서 공개키를 복사하고, 나온 명령어를 복사합니다.**
    
    ```
    [h43254@nasa-master .ssh]$ cat id_rsa.pub 
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMcBYtD/NDrxGOyjPJ9DryBOWzoWlVszqI+jqSAUeAsZ+hwjTtyU60I3vuBn9Ge6HcgKfKUccUyGPickMyTXk2qzeMsa9iN0MOgLZ3GM//aFE5z6yoEvjPJ9KxQg9qRrLhUUWqYtBhyegBt26E+YdSWF24ZNutp7CRLtVQpwT/opMkY9XTseaD1kaj1BZF8ls2V5WNCgC504JfPKuKBVKcbuOwBIBv6TyZhhGXRWfKTKpma3/L5Yhc4qNOZGDo913/kkwlMpqPb4JQAEasXELfFPMou9vPOaKEK7CDdcJ/EOkXct7d43vnMRa8360okA+BMP7vJ4c4ElWW+T0op5rt h43254@nasa-master
    ```
---

* **GCP에 ``공개키를 등록``하기 위해서 ``Compute Engine - 메타데이터- SSH`` 에  서  공개키를 추가합니다.**  

    ![스크린샷, 2020-08-20 14-43-15](https://user-images.githubusercontent.com/69498804/90721321-7e2c8a80-e2f3-11ea-914e-8174cfc57d39.png)

    **복사한 키를 넣으면 자동으로 왼쪽에 아이디(여기서는  h43254)이 나타납니다.  
    아이디를 확인 한 다음에 저장을 누릅니다.**

    **(만약에 나타나지 않았다면 공개키 코드의 띄어쓰기 때문이니 확인해야 합니다)**

---

* **메타데이터 정상 확인을 위해 ``NODE1``에 접속 후 확인합니다.**

    ```
    [h43254@nasa-node1 ~]$ cat .ssh/authorized_keys 
    # Added by Google
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCJjI66r5lO6y/3NVCDA9RZt98DCs1LDLL4rScU+scCDdIJmEHhqvOSU7bmK+a8BezaoqmlQgBWKt0Yj6FqxXyokAs2KBNEJMDA99yTAiy/R1omopwsgD7Ce50iUDGs6jWvagPktuUznYyi75hQXoTQKt9FEhjBrpLBxoBZUoBgxa67mkc+rn1icoWoKRlAEt1UQzmT13Spx6ueTMYxC5CZIhPlWpTRpe5SthSvuOShv5KZyZ+0ByOycrTUrjDfqIY1zPiOJb5Q92UXbmSbsk2ZEMyD5JCC5kvD4poQBToE/mdFcdvfAkta/l9qh2qmI8FMHKkelLXM0m82yM0IRStR google-ssh {"userName":"h43254@gmail.com","expireOn":"2020-08-20T05:49:24+0000"}
    # Added by Google
    ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFwFZIw8RvKf9xUVUx+NO3yzwCMFgqTRB2UxxnjqrxImnPWraBpEKdtY4m/VIxn9hL26OyF3fD+NRGMySo7xlnI= google-ssh {"userName":"h43254@gmail.com","expireOn":"2020-08-20T05:49:22+0000"}
    # Added by Google         ###### 정상 등록 확인!!! ######
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMcBYtD/NDrxGOyjPJ9DryBOWzoWlVszqI+jqSAUeAsZ+hwjTtyU60I3vuBn9Ge6HcgKfKUccUyGPickMyTXk2qzeMsa9iN0MOgLZ3GM//aFE5z6yoEvjPJ9KxQg9qRrLhUUWqYtBhyegBt26E+YdSWF24ZNutp7CRLtVQpwT/opMkY9XTseaD1kaj1BZF8ls2V5WNCgC504JfPKuKBVKcbuOwBIBv6TyZhhGXRWfKTKpma3/L5Yhc4qNOZGDo913/kkwlMpqPb4JQAEasXELfFPMou9vPOaKEK7CDdcJ/EOkXct7d43vnMRa8360okA+BMP7vJ4c4ElWW+T0op5rt h43254@nasa-master
    [h43254@nasa-node1 ~]$ 
    ```

    **터미널에서 ``cat .ssh/authorized_keys``를 쳐보면  
    아래와 같이 등록된 키를 확인할 수 있습니다.**


    **``자 이제 마스터 <-> 노드의 ssh 통신이 원활해졌습니다.``**

---

## 쿠버네티스  설치하기 [kubeadm] <a name="a4"></a>  


**본격적인 설치 과정입니다.**
**``Kubeadm``은 ``Kubelet`` 과 ``Kubectl`` 을 ``설치하지 않기`` 때문에 직접 설치해야 합니다.**  

* **아래 ``리파지토리``를 추가합니다.**  


    ```
    cat <<EOF > /etc/yum.repos.d/kubernetes.repo
    [kubernetes]
    name=Kubernetes
    baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
    enabled=1
    gpgcheck=1
    repo_gpgcheck=1
    gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
    exclude=kube*
    EOF
    ```

* **``CENSOS yum update``**

    ```
    $ yum -y update
    ```

* **``도커 설치 전 사전 세팅``**  

    ```
    $ yum install -y yum-utils device-mapper-persistent-data lvm2 
    ```

* **``도커 저장소 설정``**  

    ```
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    ```

* **``도커 패키지 설치``**  

    
    ```
    yum update && yum install docker-ce-18.06.2.ce
    ```

* **``쿠버네티스 설치``**  

 
    ```
    yum install -y --disableexcludes=kubernetes kubeadm-1.15.5-0.x86_64 kubectl-1.15.5-0.x86_64 kubelet-1.15.5-0.x86_64
    ```

    **1.15 버전으로 설치하는 이유 : 헬스체크 이슈, 대쉬보드 호환성**

---
* **``Master 노드``에 ``컨트롤 구성 요소를 설치``합니다.**  
**해당 작업은 ``master`` 에서만 실행합니다.  
설치 시 사용할 이미지를 먼저 다운로드 합니다.**

    ```
    [root@nasa-master ~]# kubeadm config images pull
    I0824 02:21:37.374466   13234 version.go:248] remote version is much newer: v1.18.8; falling back to: stable-1.15
    [config/images] Pulled k8s.gcr.io/kube-apiserver:v1.15.12
    [config/images] Pulled k8s.gcr.io/kube-controller-manager:v1.15.12
    [config/images] Pulled k8s.gcr.io/kube-scheduler:v1.15.12
    [config/images] Pulled k8s.gcr.io/kube-proxy:v1.15.12
    [config/images] Pulled k8s.gcr.io/pause:3.1
    [config/images] Pulled k8s.gcr.io/etcd:3.3.10
    [config/images] Pulled k8s.gcr.io/coredns:1.3.1
    ```

---

* **마스터 노드를 ``초기화``합니다.**

    ```
    [root@nasa-master ~]# kubeadm init
    I0824 02:22:23.982576   13371 version.go:248] remote version is much newer: v1.18.8; falling back to: stable-1.15
    [init] Using Kubernetes version: v1.15.12
    [preflight] Running pre-flight checks
            [WARNING Service-Kubelet]: kubelet service is not enabled, please run 'systemctl enable kubelet.service'
    [preflight] Pulling images required for setting up a Kubernetes cluster
    [preflight] This might take a minute or two, depending on the speed of your internet connection
    [preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
    [kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
    [kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
    [kubelet-start] Activating the kubelet service
    [certs] Using certificateDir folder "/etc/kubernetes/pki"
    [certs] Generating "ca" certificate and key
    [certs] Generating "apiserver-kubelet-client" certificate and key
    ...
    ...(중략)
    -----
    Your Kubernetes control-plane has initialized successfully!
    To start using your cluster, you need to run the following as a regular user:
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    You should now deploy a pod network to the cluster.
    Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
    https://kubernetes.io/docs/concepts/cluster-administration/addons/
    Then you can join any number of worker nodes by running the following on each as root:
    kubeadm join 10.146.0.6:6443 --token ofhrxu.dgsn2pc08glnfj06 \
        --discovery-token-ca-cert-hash sha256:00f7773eea1e619ea4c5698417679475cb07774b26cd7f738fb82a315f643b5a
    ```
---

* **여기서 ``일반 사용자``가 ``kubectl`` 을 ``사용``할 수 있도록 환경변수를 설정합니다.**

    ```
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    ```


---

### WORKER 노드 설정 <a name="a5"></a>  

*   **``도커 실행``**

    ```
    systemctl daemon-reload
    systemctl enable --now docker
    ```

* **``쿠버네티스 실행``**  

 
    ```
    systemctl enable --now kubelet
    ```

---

* **로그의 ``마지막 라인의 명령어``는 ``워커 노드``를 해당 ``클러스터에 추가``하는 명령어입니다.**  
**해당 명령어를 복사해서 ``nasa-node1``, ``nasa-node2``, ``nasa-node3`` 노드에서 수행합니다.**

    ```
    [root@nasa-node1 ~]# kubeadm join 10.146.0.6:6443 --token ofhrxu.dgsn2pc08glnfj06 \--discove
    ry-token-ca-cert-hash sha256:00f7773eea1e619ea4c5698417679475cb07774b26cd7f738fb82a315f643b5
    a 
    [preflight] Running pre-flight checks
    [preflight] Reading configuration from the cluster...
    [preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubead
    m-config -oyaml'
    [kubelet-start] Downloading configuration for the kubelet from the "kubelet-config-1.15" Con
    figMap in the kube-system namespace
    [kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
    [kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubead
    m-flags.env"
    [kubelet-start] Activating the kubelet service
    [kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...
    This node has joined the cluster:
    * Certificate signing request was sent to apiserver and a response was received.
    * The Kubelet was informed of the new secure connection details.
    Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
    ```

---

### **Pod network add-on 설치하기** <a name="a6"></a> 
**``Pod`` 은 실제로 여러 노드에 걸쳐 배포되는데,  
Pod 끼리 하나의 네트워크에 있는 것처럼 통신할 수 있습니다.**  
**이를 ``오버레이 네트워크(Overlay Network)``라고 합니다.**

**오버레이 네트워크를 지원하는 ``CNI(Container Network Interface) 플러그인``을 설치해보겠습니다.**  
**CNI 에는 여러 종류가 있는데, 이번 포스트는 ``Weave`` 를 이용합니다.**

---

* **``Master`` 노드에서 ``weave``를 설치합니다**


    ```
    [root@nasa-master ~]# kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
    serviceaccount/weave-net created
    clusterrole.rbac.authorization.k8s.io/weave-net created
    clusterrolebinding.rbac.authorization.k8s.io/weave-net created
    role.rbac.authorization.k8s.io/weave-net created
    rolebinding.rbac.authorization.k8s.io/weave-net created
    daemonset.apps/weave-net created
    ```

    **``CNI``를 설치하면 ``CoreDNS Pod`` 이 ``정상적으로 동작``하게 됩니다.**

* **각 노드와 상태를 확인해보겠습니다** 

    ```
    [root@nasa-master ~]# kubectl get nodes
    NAME          STATUS   ROLES    AGE     VERSION
    nasa-master   Ready    master   10m     v1.15.5
    nasa-node1    Ready    <none>   3m48s   v1.15.5
    nasa-node2    Ready    <none>   4m15s   v1.15.5
    nasa-node3    Ready    <none>   3m48s   v1.15.5
    ```

    ```
    [root@nasa-master ~]# kubectl get cs
    NAME                 STATUS    MESSAGE             ERROR
    controller-manager   Healthy   ok                  
    scheduler            Healthy   ok                  
    etcd-0               Healthy   {"health":"true"}   
    ```

* **최종적으로 구성 API, 및 요소가 정상적으로 실행중인지 확인합니다**

    ```
    [root@nasa-master ~]# kubectl get po -o custom-columns=POD:metadata.name,NODE:spec.nodeName --sort-by spec.nodeName 
    -n kube-system
    POD                                   NODE
    kube-scheduler-nasa-master            nasa-master
    weave-net-v7bff                       nasa-master
    etcd-nasa-master                      nasa-master
    kube-apiserver-nasa-master            nasa-master
    kube-controller-manager-nasa-master   nasa-master
    kube-proxy-6w9dk                      nasa-master
    kube-proxy-lxn6d                      nasa-node1
    weave-net-k2tcb                       nasa-node1
    coredns-5c98db65d4-8cg79              nasa-node1
    kube-proxy-jqks7                      nasa-node2
    weave-net-dd6f2                       nasa-node2
    coredns-5c98db65d4-zbvbn              nasa-node2
    weave-net-k2jc9                       nasa-node3
    kube-proxy-kr9sb                      nasa-node3
    ```

---

### **간단한 pods 배포 TEST**


* **간단한 Pod 을 배포해서 동작을 확인해봅시다.**  
    **아래 pod-test.yaml 파일을 생성.**
    
    ```
    apiVersion: v1
    kind: Pod
    metadata:
    name: myapp-pod
    labels:
        app: myapp
    spec:
    containers:
    - name: myapp-container
        image: busybox
        command: ['sh', '-c', 'echo Hello Kubernetes! && sleep 3600']
    ```
    **해당 Pod 이 실행되면 ``busybox`` 라는 경량 리눅스 이미지에  
    ``Hello Kubernetes!`` 라는 로그가 잠시 동안 출력되고 Pod 은 종료됩니다.**

---

* **PODS 배포**

    ```
    [root@nasa-master kube]# kubectl apply -f pod-test.yaml
    pod/nasa-pod created
    ```

* **동작 및 로그 확인**

    ```
    [root@nasa-master kube]# kubectl get po
    NAME       READY   STATUS    RESTARTS   AGE
    nasa-pod   1/1     Running   0          10s
    [root@nasa-master kube]# 
    [root@nasa-master kube]# kubectl logs nasa-pod
    Hello Kubernetes!
    ```

    **이로써 기본적인 k8s 클러스터 구성이 완료되었습니다**

----
