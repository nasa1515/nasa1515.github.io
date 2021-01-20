---
layout: post
title: "[Kubernetes] - GCP 기반 k8s환경구성 - [kubespray]"
author: nasa1515
categories: Kubernetes
date: 2020-08-16 10:36
comments: true
cover: "/assets/kubernets.jpg"
tags: Kubernetes
---



#  KUBERNETES - GCP 기반의 k8S 환경구성 - [kubespray]

**머리말**  
쿠버네티스 환경을 구성하는 방법은 여러가지가 존재한다.  
각 서버를 준비하는 방법은 여러 가지가 있겠지만  
가장 쉽게 생각해볼 수 있는 건 ``VirtualBox`` 와 ``Vagrant`` 를 이용한 ``로컬 VM``로 구성하는 것이다.    
하지만 이번 포스트에서는 CLOUD에 익숙해지고 싶은 마음과  
GCP 무료 크레딧이 아까운 마음에 GCP로 진행해보았다.

   
 
---

**목차**

- [사전준비](#a1)
- [구성 (Install)](#a2)
- [Compute Engine에 ``Kubespray`` 를 설치하여 환경 설정](#a3)
- [Kubespray 설치하기](#a4)



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

### Compute Engine에 ``Kubespray`` 를 설치하여 환경 설정 <a name="a3"></a>  

* **``GCP Console``에 접속합니다.**  

* **``INSTANCE`` 동일하게 4개 생성해보겠습니다. [구성 방법은 "GCP포스트"!!!](https://nasa1515.github.io/gcp/2020/08/10/GCP-1.html)**  
![스크린샷, 2020-08-20 14-20-27](https://user-images.githubusercontent.com/69498804/90719826-4e2fb800-e2f0-11ea-94d4-b8f9dc1d31f4.png)

---

* **아래 처럼 인스턴스 4개를 생성 완료했습니다.**

    ![스크린샷, 2020-08-20 14-24-55](https://user-images.githubusercontent.com/69498804/90720126-eded4600-e2f0-11ea-963e-c7d5203642b8.png)


---

### **사전 작업하기**

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
### **앤서블의 인벤토리는 SSH(RSA) 기반으로 동작하므로 공개키를 공유해줘야 합니다.**

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
    10.178.0.2      nasa-master
    10.178.0.4      nasa-node1
    10.178.0.5      nasa-node2
    10.178.0.3      nasa-node3
    ```

* **``ssh 유저 권한 설정``을 위해 ``master서버``의 ``/etc/sudoers`` 파일에 내용을 추가** 

    ![스크린샷, 2020-08-21 09-49-17](https://user-images.githubusercontent.com/69498804/90839950-b5eb0f00-e393-11ea-94a3-b7dabd3c2d51.png)

    **h43254라는 유저에 대해서 패스워드를 물어보지 않겠다는 설정입니다.**
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


    **``자 이제 마스터 <-> 노드의 통신이 원활해졌습니다.``**

---

## Kubespray 설치하기 <a name="a4"></a>  
![스크린샷, 2020-08-20 14-57-48](https://user-images.githubusercontent.com/69498804/90722288-85549800-e2f5-11ea-8eb9-aefa22c73f46.png)

**이제 ``Kubespray``를 설치해보도록 하겠습니다.  
Kubespray는 ``Ansible을 기반``으로 Kubernetes를 설치합니다.  
이를 이용하면 Kubenetes를 손쉽게 설치할 수 있게 도와줍니다.**


* **우선 ``Master`` 인스턴스인 ``nasa-master``에서 패키지를 업데이트 합니다.**

    ```
    [h43254@nasa-master .ssh]$ sudo yum update
    Loaded plugins: fastestmirror
    Loading mirror speeds from cached hostfile
    * base: mirror.navercorp.com
    * epel: d2lzkl7pfhq30w.cloudfront.net
    * extras: mirror.navercorp.com
    * updates: mirror.navercorp.com
    Resolving Dependencies
    --> Running transaction check
    ---> Package google-cloud-sdk.x86_64 0:304.0.0-1 will be updated
    ---> Package google-cloud-sdk.x86_64 0:306.0.0-1 will be an update
    --> Finished Dependency Resolution
    ....
    ....(중략)
    Updated:
    google-cloud-sdk.x86_64 0:306.0.0-1                                                                                                                                                        
    Complete!
    ```

* **그리고 ``pip``를 설치해줍니다**  
    
    ```
    [h43254@nasa-master /]$ sudo yum -y install python-pip
    Loaded plugins: fastestmirror
    Loading mirror speeds from cached hostfile
    * base: mirror.navercorp.com
    * epel: d2lzkl7pfhq30w.cloudfront.net
    * extras: mirror.navercorp.com
    * updates: mirror.navercorp.com
    Resolving Dependencies
    --> Running transaction check
    ...
    ...(중략)
    python-ipaddress.noarch 0:1.0.16-2.el7                                                       
    python-setuptools.noarch 0:0.9.8-7.el7                                                       

    Complete!
    ```

* **패키지가 정상적으로 설치되었는지 확인해봅니다**  

    ```
    [h43254@nasa-master /]$ pip --version
    pip 8.1.2 from /usr/lib/python2.7/site-packages (python 2.7)
    ```

----

### **본격적으로 ``kubesparay``를 설치합니다.**  

*   **``git clone`` 명령어를 통해서 다운로드를 진행합니다.**  

    ```
    $ git clone https://github.com/kubernetes-sigs/kubespray.git
    ```

    **``다운로드 완료!!``**
    ```
    [h43254@nasa-master /]$ sudo git clone https://github.com/kubernetes-sigs/kubespray.git
    Cloning into 'kubespray'...
    remote: Enumerating objects: 3, done.
    remote: Counting objects: 100% (3/3), done.
    remote: Total 46404 (delta 2), reused 2 (delta 2), pack-reused 46401
    Receiving objects: 100% (46404/46404), 13.45 MiB | 6.09 MiB/s, done.
    Resolving deltas: 100% (25881/25881), done.
    ```
---

* **다운받은 디렉토리에 다음과 같이 필요한 파일들이 잘 있는것을 확인 할 수 있습니다.**

    ```
    $ cd kubespray/
    $ ls -alrt
    ```

    ```
    [h43254@nasa-master /]$ cd /kubespray/
    [h43254@nasa-master kubespray]$ ls -alrt 
    total 184
    dr-xr-xr-x. 18 root root   241 Aug 20 06:26 ..
    -rw-r--r--.  1 root root   285 Aug 20 06:26 .editorconfig
    -rw-r--r--.  1 root root   832 Aug 20 06:26 .ansible-lint
    -rw-r--r--.  1 root root     0 Aug 20 06:26 .nojekyll
    -rw-r--r--.  1 root root    17 Aug 20 06:26 .markdownlint.yaml
    -rw-r--r--.  1 root root     0 Aug 20 06:26 .gitmodules
    -rw-r--r--.  1 root root  1980 Aug 20 06:26 .gitlab-ci.yml
    drwxr-xr-x.  2 root root   102 Aug 20 06:26 .gitlab-ci
    -rw-r--r--.  1 root root  1192 Aug 20 06:26 .gitignore
    drwxr-xr-x.  3 root root    60 Aug 20 06:26 .github
    -rw-r--r--.  1 root root   289 Aug 20 06:26 .yamllint
    -rw-r--r--.  1 root root   531 Aug 20 06:26 SECURITY_CONTACTS
    -rw-r--r--.  1 root root  3272 Aug 20 06:26 RELEASE.md
    -rw-r--r--.  1 root root 12328 Aug 20 06:26 README.md
    -rw-r--r--.  1 root root   283 Aug 20 06:26 OWNERS_ALIASES
    -rw-r--r--.  1 root root   121 Aug 20 06:26 OWNERS
    -rw-r--r--.  1 root root    85 Aug 20 06:26 Makefile
    -rw-r--r--.  1 root root 11342 Aug 20 06:26 LICENSE
    -rw-r--r--.  1 root root   969 Aug 20 06:26 Dockerfile
    -rw-r--r--.  1 root root  1661 Aug 20 06:26 CONTRIBUTING.md
    -rw-r--r--.  1 root root    12 Aug 20 06:26 CNAME
    -rw-r--r--.  1 root root 10127 Aug 20 06:26 Vagrantfile
    -rw-r--r--.  1 root root    30 Aug 20 06:26 _config.yml
    -rw-r--r--.  1 root root   148 Aug 20 06:26 code-of-conduct.md
    -rw-r--r--.  1 root root  4526 Aug 20 06:26 cluster.yml
    -rw-r--r--.  1 root root   412 Aug 20 06:26 ansible_version.yml
    -rw-r--r--.  1 root root   927 Aug 20 06:26 ansible.cfg
    drwxr-xr-x. 13 root root   193 Aug 20 06:26 contrib
    drwxr-xr-x.  4 root root    33 Aug 20 06:26 inventory
    -rw-r--r--.  1 root root  1468 Aug 20 06:26 index.html
    -rw-r--r--.  1 root root   484 Aug 20 06:26 facts.yml
    drwxr-xr-x.  3 root root   115 Aug 20 06:26 extra_playbooks
    drwxr-xr-x.  5 root root  4096 Aug 20 06:26 docs
    drwxr-xr-x.  2 root root    21 Aug 20 06:26 library
    -rw-r--r--.  1 root root    94 Aug 20 06:26 requirements.txt
    -rw-r--r--.  1 root root  1705 Aug 20 06:26 remove-node.yml
    -rw-r--r--.  1 root root   612 Aug 20 06:26 recover-control-plane.yml
    -rw-r--r--.  1 root root  1172 Aug 20 06:26 mitogen.yml
    drwxr-xr-x.  2 root root  4096 Aug 20 06:26 logo
    -rw-r--r--.  1 root root   726 Aug 20 06:26 reset.yml
    -rw-r--r--.  1 root root  2608 Aug 20 06:26 scale.yml
    drwxr-xr-x. 17 root root  4096 Aug 20 06:26 roles
    -rw-r--r--.  1 root root   693 Aug 20 06:26 setup.py
    -rw-r--r--.  1 root root  1663 Aug 20 06:26 setup.cfg
    ```
---

* **``requirements.txt``에 필요한 패키지들이 명시되어 있는데  
이를 이용해 설치를 진행합니다.**

    ```
    [h43254@nasa-master kubespray]$ sudo pip install -r requirements.txt
    Collecting ansible==2.9.6 (from -r requirements.txt (line 1))
    Downloading https://files.pythonhosted.org/packages/ae/b7/c717363f767f7af33d90af9458d5f1e0960
    db9c2393a6c221c2ce97ad1aa/ansible-2.9.6.tar.gz (14.2MB)
        100% |████████████████████████████████| 14.2MB 75kB/s 
    Collecting jinja2==2.11.1 (from -r requirements.txt (line 2))
    Downloading https://files.pythonhosted.org/packages/27/24/4f35961e5c669e96f6559760042a55b9bcf
    ...
    ...(중략)
    8e2a0ecf73d21d6b85865da11/MarkupSafe-1.1.1-cp27-cp27mu-manylinux1_x86_64.whl
    Collecting ruamel.ordereddict; platform_python_implementation == "CPython" and python_version <
    = "2.7" (from ruamel.yaml==0.16.10->-r requirements.txt (line 6))
    Downloading https://files.pythonhosted.org/packages/8c/d6/4971e55c60b972160b911368fa4cd756d68
    739b6616b0cb57d09d8a6ee18/ruamel.ordereddict-0.4.14-cp27-cp27mu-manylinux1_x86_64.whl (93kB)
        100% |████████████████████████████████| 102kB 9.2MB/s 
    ```

--- 

* **설치가 잘됬으면 ``ansible``이 설치된 것을 확인 할 수 있습니다.**

    ```
    [h43254@nasa-master kubespray]$ ansible --version
    /usr/lib64/python2.7/site-packages/cryptography/__init__.py:39: CryptographyDeprecationWarning: Python 2 is no longer supported by the Python core team. Support for it is now deprecated in cryptography, and will be removed in a future release.
    CryptographyDeprecationWarning,
    ansible 2.9.6
    config file = /kubespray/ansible.cfg
    configured module search path = [u'/kubespray/library']
    ansible python module location = /usr/lib/python2.7/site-packages/ansible
    executable location = /usr/bin/ansible
    python version = 2.7.5 (default, Apr  2 2020, 13:16:51) [GCC 4.8.5 20150623 (Red Hat 4.8.5-39)]
    ```
---

* **기본 ``inventory/sample``을 ``inventory/mycluster`` 로 복사합니다.**

    ```
    [h43254@nasa-master kubespray]$ cp -rfp inventory/sample inventory/cluster
    cp: cannot create directory ‘inventory/mycluster’: Permission denied
    [h43254@nasa-master kubespray]$ sudo cp -rfp inventory/sample inventory/mycluster
    [h43254@nasa-master kubespray]$ ls -alrt inventory/mycluster/
    total 4
    drwxr-xr-x. 4 root root  52 Aug 20 06:26 group_vars
    -rw-r--r--. 1 root root 994 Aug 20 06:26 inventory.ini
    drwxr-xr-x. 3 root root  45 Aug 20 06:26 .
    drwxr-xr-x. 5 root root  50 Aug 20 06:45 ..
    ```

    **inventory를 복사할 디렉토리 이름은 아무이름이나 설정해도 됩니다.**

---

* **디렉토리의 ``tree 구조``를 보기 위해서 tree 패키지를 설치합니다.**

    ```
    [h43254@nasa-master kubespray]$ 
    [h43254@nasa-master kubespray]$ sudo yum -y install tree
    Loaded plugins: fastestmirror
    Loading mirror speeds from cached hostfile
    * base: mirror.navercorp.com
    * epel: d2lzkl7pfhq30w.cloudfront.net
    * extras: mirror.navercorp.com
    * updates: mirror.navercorp.com
    Resolving Dependencies
    ...
    ...(중략)
    Transaction test succeeded
    Running transaction
    Installing : tree-1.6.0-10.el7.x86_64                                                    1/1 
    Verifying  : tree-1.6.0-10.el7.x86_64                                                    1/1 
    Installed:
    tree.x86_64 0:1.6.0-10.el7                                                                   
    Complete!
    ```

---

* **``tree``로 ``group_vars 디렉토리``를 보면 설치에 필요한 ``yml 파일``이 있는걸 확인**

    ```
    [h43254@nasa-master kubespray]$ tree inventory/cluster/group_vars
    inventory/mycluster/group_vars
    ├── all
    │   ├── all.yml
    │   ├── aws.yml
    │   ├── azure.yml
    │   ├── containerd.yml
    │   ├── coreos.yml
    │   ├── docker.yml
    │   ├── gcp.yml
    │   ├── oci.yml
    │   ├── openstack.yml
    │   └── vsphere.yml
    ├── etcd.yml
    └── k8s-cluster
        ├── addons.yml
        ├── k8s-cluster.yml
        ├── k8s-net-calico.yml
        ├── k8s-net-canal.yml
        ├── k8s-net-cilium.yml
        ├── k8s-net-contiv.yml
        ├── k8s-net-flannel.yml
        ├── k8s-net-kube-router.yml
        ├── k8s-net-macvlan.yml
        └── k8s-net-weave.yml
    2 directories, 21 files
    ```

---

* **설치를 위한 설정으로 ``inventory.ini``를 수정합니다.**

    ```
    vi inventory/mycluster/inventory.ini
    ```


    ![스크린샷, 2020-08-21 10-18-49](https://user-images.githubusercontent.com/69498804/90841465-b7b6d180-e397-11ea-9c8b-a129f1e9b5ce.png)

    * **``[all]`` 그룹에는 인스턴스의 내부 아이피를 입력합니다**  
    * **``[kube-master]`` 그룹에는 마스터로 사용할 인스턴스 명을 넣습니다.**
    * **``[etcd]`` 그룹에는 etcd를 사용할 인스턴스를 입력합니다 (홀수)**
    * **``[kube-node]`` 그룹에는 노드로 사용 할 인스턴스 명을 넣습니다.**

---

* **``SSH KEY``를 한번 사용해서 마스터와 동기화 시켜줍니다**

    ```
    [h43254@nasa-master ~]$ ssh h43254@nasa-node1
    Last login: Thu Aug 20 09:12:40 2020 from nasa-master.asia-northeast3-a.c.nasa1515.internal
    [h43254@nasa-node1 ~]$ exit
    logout
    Connection to nasa-node1 closed.
    [h43254@nasa-master ~]$ ssh h43254@nasa-node2
    The authenticity of host 'nasa-node2 (10.178.0.5)' can't be established.
    ECDSA key fingerprint is SHA256:+Pcsu6s4ImB0kob1TZ41ieS8wz2drCalVIVzBawpRlk.
    ECDSA key fingerprint is MD5:26:6a:41:28:c8:5a:77:3e:04:7d:88:1e:14:44:d8:14.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added 'nasa-node2' (ECDSA) to the list of known hosts.
    Last login: Thu Aug 20 09:12:40 2020 from nasa-master.asia-northeast3-a.c.nasa1515.internal
    [h43254@nasa-node2 ~]$ exit
    logout
    Connection to nasa-node2 closed.
    [h43254@nasa-master ~]$ ssh h43254@nasa-node3
    Last login: Fri Aug 21 00:43:40 2020 from 35.235.240.229
    [h43254@nasa-node3 ~]$ exit
    logout
    Connection to nasa-node3 closed.
    [h43254@nasa-master ~]$ 
    ```
    **위와 같이 ``ssh``로 한번씩 접속만 해주면 됩니다.**

---

* **모두 완료 되었으면 필요로 하는 ``의존성 및 설정``을 세팅합니다.**

    ```
    $ ansible-playbook -i kubespray/inventory/cluster/inventory.ini -v --become --become-user=root kubespray/cluster.yml
    ```

    ![스크린샷, 2020-08-21 11-11-23](https://user-images.githubusercontent.com/69498804/90844636-5692fc00-e39f-11ea-9bce-2d1bea280a1c.png)
    **``skipped``이 많긴하지만 여러 테스트를 하며 설치를 해서 상관없습니다**

---

* **간혹가다 다음과 같은 에러가 발생할 경우에는 디렉토리를 수동으로 생성해주면 됩니다**
    ![스크린샷, 2020-08-21 10-42-48](https://user-images.githubusercontent.com/69498804/90846348-e71f0b80-e3a2-11ea-91c9-ffecd03462cb.png)

    ```
    sudo mkdir credentials
    ```


---

*   **설치가 완료되고 ``root 권한``으로 ``노드 정보``를 정상적으로 받아옴을 확인합니다**  

    ![스크린샷, 2020-08-21 11-36-30](https://user-images.githubusercontent.com/69498804/90846161-91e2fa00-e3a2-11ea-86e4-cbaf96a90258.png)

---