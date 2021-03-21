# single-board-config
Configurations for Single Board Computers

```bash
  # To start the dashboard
  # FIXME: Make this a service that can start with k3s
  sudo kubectl proxy --address='0.0.0.0' --port=8001 --accept-hosts='.*'

  # To get the password for logging in
  k -n kube-system describe secret admin-user-token | grep ^token
```

To login to the dashboard use the url below

```bash
  http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login
 ``` 

[Click here](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login)
