# DevOps Engineer Assessment

In order to accomplish the demo assessment, I use the following technologies:

- Virtualbox as a platform for running Minikube
- Minikube as a ready to use Kubernetes cluster
- Jenkins Community Kubernetes Helm Charts to deploy Jenkins on the Kubernetus cluster
- Terraform with hashicorp/kubernetes and hashicorp/helm providers to automate of Jenkins deployment
- Kubernetes command-line tool(kubectl) to get nessesary information after Jenkins deployment
- Kubernetes plugin for Jenkins to run Jenkins agents dynamicly on the Kubernetes cluster
- Jenkins Configuration as Code (a.k.a. JCasC) Plugin to configure Kubernetes plugin and set up a test pipeline job
- Small nodejs github project with Jenkinsfile to be triggered by the pipeline job
- Jenkins and nodejs Docker containers from Docker Hub

I was striving to keep the demo clean, concise and easy to reproduce, so I decided to leverage Jenkins Kubernetes Helm Charts as much as possible for the things like:
- Creating Kubernetes Persistent Volume and Persistent Volume Claim for Jenkins controller pod to prevent losing configuration of the Jenkins controller and our jobs when we reboot our minikube.
- Creating ServiceAccount and enable RBAC (using pre-installed jenkins namespaces) to allow Jenkins scheduling of agents via Kubernetes plugin
- Use NodePort Service with static port 30000 to expose Jenkins outside and create network routes automatically
- Set some resources limitations for Jenkins controller
- Install minimal set of Jenkins plugins

The setup is for testing purpose only. Not for production use.

## How to reproduce

### Requirements

2 CPUs<br>
4GB of free memory<br>
20GB of free disk space<br>

[Virtualbox](https://www.virtualbox.org/wiki/Downloads)<br>
[Minikube](https://minikube.sigs.k8s.io/docs/start/)<br>
[Terraform](https://www.terraform.io/downloads.html) >= v0.12.x<br>
[Helm](https://helm.sh/docs/intro/install/) v3.4.x<br>
[kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)<br>

### Steps to reproduce
Spin up the Kubernetes cluster:
```
minikube --memory 4096 --cpus 2 start --vm-driver=virtualbox
```

Clone this repository and apply terraform commands:
```  
terraform init
terraform plan
terraform apply
```

After the installation get the Jenkins ip-address, the port is 30000:
```
kubectl get nodes --namespace jenkins -o jsonpath="{.items[0].status.addresses[0].address}"
```

And get Jenkins 'admin' user password:
```
kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo
```

Open http://<Jenkins ip-address>:30000 and run the nodejs-example pipeline job.<br>
<br>
![ScreenShot](pipeline.png)
<br>

It will clone the https://github.com/y0j/node_js-example repository and does install and test the project in the .

## Links which helps me a lot
https://www.jenkins.io/doc/book/installing/kubernetes/<br>
https://cloud.google.com/solutions/jenkins-on-kubernetes-engine<br>
https://www.jenkins.io/projects/jcasc/<br>
https://www.jenkins.io/doc/book/pipeline/<br>
https://github.com/jenkinsci/jep/tree/master/jep/201<br>
https://github.com/jenkinsci/helm-charts<br>
https://github.com/jenkinsci/configuration-as-code-plugin<br>
https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos/kubernetes<br>
https://github.com/jenkinsci/kubernetes-plugin<br>
https://github.com/jenkinsci/kubernetes-plugin/tree/master/examples<br>
Many more less significant from google search<br>
