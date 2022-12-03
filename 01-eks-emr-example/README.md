# EMR on EKS
最近开源大数据框架在Kubernetes平台上部署的方式日渐成熟。越来越多的客户甚至是企业客户开始在Kubernetes平台上部署大数据的应用。直接把很多开源大数据框架部署在虚拟机中是非常复杂的一件事，即使在有大量部署工具的云平台也会很繁琐。近来通过Kubernetes来部署和运维大数据平台确实能够大大降低企业的成本和复杂度。在接下来一系列的视频当中我会集中录制一些如何在亚马逊EKS上运行大数据应用，为大家揭秘这一技术趋势！
## 视频
[![NetFlix on UWP](https://res.cloudinary.com/marcomontalbano/image/upload/v1587315555/video_to_markdown/images/youtube--2qqYywttue4-c05b58ac6eb4c4700831b2b3070cd403.jpg)](https://www.bilibili.com/video/BV1MP411M7Fn "Data on EKS")

## 前提
需要一个Bash脚本的执行环境，并安装如下命令行工具：
- [AWS CLI](https://aws.amazon.com/cli/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
- [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html)
- [Helm](https://helm.sh/)
- [curl](https://curl.se/)
- [jq](https://stedolan.github.io/jq/)
- [xargs](https://man7.org/linux/man-pages/man1/xargs.1.html)

## 架构
![](images/emr-on-eks-architecture.png)

## 执行步骤
按照脚本命名的编号顺序执行01到03就可以完成资源的部署和Spark Job提交，最后顺序执行97到99编号的脚本就可以清理所有的资源。

## 参考资源
- [EMR on EKS文档](https://docs.aws.amazon.com/emr/latest/EMR-on-EKS-DevelopmentGuide/emr-eks.html)
- [Karpenter官网](https://karpenter.sh/)
