# single-board-config
Configurations for Single Board Computers

```bash
  # To start the dashboard
  # FIXME: Make this a service that can start with k3s
  sudo kubectl proxy --address='0.0.0.0' --port=8001 --accept-hosts='.*'

  # To get the password for logging in
  k -n kube-system describe secret admin-user-token | grep ^token
```
