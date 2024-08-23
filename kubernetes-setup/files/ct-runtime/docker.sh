#!/bin/bash

set -e

MASTERHOSTNAME=$1
DOCKERCACHE=$2

#  Docker
# Add repo and Install packages
#sudo apt update
#sudo apt install -y curl software-properties-common #gnupg2 # ca-certificates # apt-transport-https 
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#sudo add-apt-repository "deb [arch=amd64] http://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
#sudo apt update
#sudo apt install -y containerd.io docker-ce docker-ce-cli
#

# fix containerd for newer k8s versions >=1.24
#sudo apt -y install vim git curl wget ca-certificates curl gnupg
#sudo install -m 0755 -d /etc/apt/keyrings
#
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
#sudo chmod a+r /etc/apt/keyrings/docker.gpg
#
#
#echo \
#  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
#  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
#  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#
#
#sudo apt-get update -y
#sudo apt-get install docker-ce docker-ce-cli docker-buildx-plugin docker-compose-plugin  -y
##sudo rm -f /etc/containerd/config.toml comment out rm config.toml for containerd to use proxy in the config
#sudo systemctl restart containerd
## --- end fix
#
#
### Create required directories
#sudo mkdir -p /etc/systemd/system/docker.service.d
### adding my local pull-through cache
#if [ -z "$DOCKERCACHE" ]
#then
#    echo "DOCKERCACHE var is unset, skipping docker images caching"
#else 
#    sudo touch /etc/systemd/system/docker.service.d/http-proxy.conf
#    sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf <<EOF
#    [Service]
#    Environment="HTTP_PROXY=http://$DOCKERCACHE"
#    Environment="HTTPS_PROXY=http://$DOCKERCACHE"
#EOF
#    sudo curl http://$DOCKERCACHE/ca.crt > /usr/share/ca-certificates/docker_registry_proxy.crt
#    sudo echo "docker_registry_proxy.crt" >> /etc/ca-certificates.conf
#    sudo update-ca-certificates --fresh
#fi
#
#
### Reload systemd
#systemctl daemon-reload
##
### Restart dockerd
#systemctl restart docker.service

## docker images multi-repo pull through cache example
## Simple (no auth, all cache)
##docker run --rm --name docker_registry_proxy -it \
##       -p 0.0.0.0:3128:3128 -e ENABLE_MANIFEST_CACHE=true \
##       -v $(pwd)/docker_mirror_cache:/docker_mirror_cache \
##       -v $(pwd)/docker_mirror_certs:/ca \
##       rpardini/docker-registry-proxy:0.6.2
##
##
##
##  "registry-mirrors": ["http://192.168.1.147:3128"],
## Create daemon json config file


# new installation (from k8s website)
# Add Docker's official GPG key:
sudo apt-get update -y
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# docker installs faulty config for containerd
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd

sudo tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
 "log-driver": "json-file",
 "insecure-registries" : [ "$MASTERHOSTNAME:5000" ],
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

# Start and enable Services
sudo systemctl daemon-reload 
sudo systemctl restart docker
sudo systemctl enable docker
#                             -----------------------------

sudo systemctl show --property=Environment docker
#

# containerD part
sudo tee /etc/containerd/config.toml<<EOF
disabled_plugins = []
imports = []
oom_score = 0
plugin_dir = ""
required_plugins = []
root = "/var/lib/containerd"
state = "/run/containerd"
temp = ""
version = 2

[cgroup]
  path = ""

[debug]
  address = ""
  format = ""
  gid = 0
  level = ""
  uid = 0

[grpc]
  address = "/run/containerd/containerd.sock"
  gid = 0
  max_recv_message_size = 16777216
  max_send_message_size = 16777216
  tcp_address = ""
  tcp_tls_ca = ""
  tcp_tls_cert = ""
  tcp_tls_key = ""
  uid = 0

[metrics]
  address = ""
  grpc_histogram = false

[plugins]

  [plugins."io.containerd.gc.v1.scheduler"]
    deletion_threshold = 0
    mutation_threshold = 100
    pause_threshold = 0.02
    schedule_delay = "0s"
    startup_delay = "100ms"

  [plugins."io.containerd.grpc.v1.cri"]
    device_ownership_from_security_context = false
    disable_apparmor = false
    disable_cgroup = false
    disable_hugetlb_controller = true
    disable_proc_mount = false
    disable_tcp_service = true
    drain_exec_sync_io_timeout = "0s"
    enable_selinux = false
    enable_tls_streaming = false
    enable_unprivileged_icmp = false
    enable_unprivileged_ports = false
    ignore_deprecation_warnings = []
    ignore_image_defined_volumes = false
    max_concurrent_downloads = 3
    max_container_log_line_size = 16384
    netns_mounts_under_state_dir = false
    restrict_oom_score_adj = false
    sandbox_image = "registry.k8s.io/pause:3.6"
    selinux_category_range = 1024
    stats_collect_period = 10
    stream_idle_timeout = "4h0m0s"
    stream_server_address = "127.0.0.1"
    stream_server_port = "0"
    systemd_cgroup = false
    tolerate_missing_hugetlb_controller = true
    unset_seccomp_profile = ""

    [plugins."io.containerd.grpc.v1.cri".cni]
      bin_dir = "/opt/cni/bin"
      conf_dir = "/etc/cni/net.d"
      conf_template = ""
      ip_pref = ""
      max_conf_num = 1

    [plugins."io.containerd.grpc.v1.cri".containerd]
      default_runtime_name = "runc"
      disable_snapshot_annotations = true
      discard_unpacked_layers = false
      ignore_rdt_not_enabled_errors = false
      no_pivot = false
      snapshotter = "overlayfs"

      [plugins."io.containerd.grpc.v1.cri".containerd.default_runtime]
        base_runtime_spec = ""
        cni_conf_dir = ""
        cni_max_conf_num = 0
        container_annotations = []
        pod_annotations = []
        privileged_without_host_devices = false
        runtime_engine = ""
        runtime_path = ""
        runtime_root = ""
        runtime_type = ""

        [plugins."io.containerd.grpc.v1.cri".containerd.default_runtime.options]

      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]

        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
          base_runtime_spec = ""
          cni_conf_dir = ""
          cni_max_conf_num = 0
          container_annotations = []
          pod_annotations = []
          privileged_without_host_devices = false
          runtime_engine = ""
          runtime_path = ""
          runtime_root = ""
          runtime_type = "io.containerd.runc.v2"

          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
            BinaryName = ""
            CriuImagePath = ""
            CriuPath = ""
            CriuWorkPath = ""
            IoGid = 0
            IoUid = 0
            NoNewKeyring = false
            NoPivotRoot = false
            Root = ""
            ShimCgroup = ""
            SystemdCgroup = true

      [plugins."io.containerd.grpc.v1.cri".containerd.untrusted_workload_runtime]
        base_runtime_spec = ""
        cni_conf_dir = ""
        cni_max_conf_num = 0
        container_annotations = []
        pod_annotations = []
        privileged_without_host_devices = false
        runtime_engine = ""
        runtime_path = ""
        runtime_root = ""
        runtime_type = ""

        [plugins."io.containerd.grpc.v1.cri".containerd.untrusted_workload_runtime.options]

    [plugins."io.containerd.grpc.v1.cri".image_decryption]
      key_model = "node"

    [plugins."io.containerd.grpc.v1.cri".registry]
      config_path = "/etc/containerd/certs.d"

      [plugins."io.containerd.grpc.v1.cri".registry.auths]

      [plugins."io.containerd.grpc.v1.cri".registry.configs]

      [plugins."io.containerd.grpc.v1.cri".registry.headers]

      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]

    [plugins."io.containerd.grpc.v1.cri".x509_key_pair_streaming]
      tls_cert_file = ""
      tls_key_file = ""

  [plugins."io.containerd.internal.v1.opt"]
    path = "/opt/containerd"

  [plugins."io.containerd.internal.v1.restart"]
    interval = "10s"

  [plugins."io.containerd.internal.v1.tracing"]

  [plugins."io.containerd.metadata.v1.bolt"]
    content_sharing_policy = "shared"

  [plugins."io.containerd.monitor.v1.cgroups"]
    no_prometheus = false

  [plugins."io.containerd.runtime.v1.linux"]
    no_shim = false
    runtime = "runc"
    runtime_root = ""
    shim = "containerd-shim"
    shim_debug = false

  [plugins."io.containerd.runtime.v2.task"]
    platforms = ["linux/amd64"]
    sched_core = false

  [plugins."io.containerd.service.v1.diff-service"]
    default = ["walking"]

  [plugins."io.containerd.service.v1.tasks-service"]
    rdt_config_file = ""

  [plugins."io.containerd.snapshotter.v1.aufs"]
    root_path = ""

  [plugins."io.containerd.snapshotter.v1.btrfs"]
    root_path = ""

  [plugins."io.containerd.snapshotter.v1.devmapper"]
    async_remove = false
    base_image_size = ""
    discard_blocks = false
    fs_options = ""
    fs_type = ""
    pool_name = ""
    root_path = ""

  [plugins."io.containerd.snapshotter.v1.native"]
    root_path = ""

  [plugins."io.containerd.snapshotter.v1.overlayfs"]
    mount_options = []
    root_path = ""
    sync_remove = false
    upperdir_label = false

  [plugins."io.containerd.snapshotter.v1.zfs"]
    root_path = ""

  [plugins."io.containerd.tracing.processor.v1.otlp"]

[proxy_plugins]

[stream_processors]

  [stream_processors."io.containerd.ocicrypt.decoder.v1.tar"]
    accepts = ["application/vnd.oci.image.layer.v1.tar+encrypted"]
    args = ["--decryption-keys-path", "/etc/containerd/ocicrypt/keys"]
    env = ["OCICRYPT_KEYPROVIDER_CONFIG=/etc/containerd/ocicrypt/ocicrypt_keyprovider.conf"]
    path = "ctd-decoder"
    returns = "application/vnd.oci.image.layer.v1.tar"

  [stream_processors."io.containerd.ocicrypt.decoder.v1.tar.gzip"]
    accepts = ["application/vnd.oci.image.layer.v1.tar+gzip+encrypted"]
    args = ["--decryption-keys-path", "/etc/containerd/ocicrypt/keys"]
    env = ["OCICRYPT_KEYPROVIDER_CONFIG=/etc/containerd/ocicrypt/ocicrypt_keyprovider.conf"]
    path = "ctd-decoder"
    returns = "application/vnd.oci.image.layer.v1.tar+gzip"

[timeouts]
  "io.containerd.timeout.bolt.open" = "0s"
  "io.containerd.timeout.shim.cleanup" = "5s"
  "io.containerd.timeout.shim.load" = "5s"
  "io.containerd.timeout.shim.shutdown" = "3s"
  "io.containerd.timeout.task.state" = "2s"

[ttrpc]
  address = ""
  gid = 0
  uid = 0
EOF


mkdir -p /etc/containerd/certs.d/_default
mkdir -p /etc/containerd/certs.d/docker.io
mkdir -p /etc/containerd/certs.d/quay.io
mkdir -p /etc/containerd/certs.d/k8s.io
mkdir -p /etc/containerd/certs.d/gcr.io
mkdir -p /etc/containerd/certs.d/ghcr.io
touch /etc/containerd/certs.d/docker.io/hosts.toml
touch /etc/containerd/certs.d/quay.io/hosts.toml
touch /etc/containerd/certs.d/k8s.io/hosts.toml
touch /etc/containerd/certs.d/gcr.io/hosts.toml
touch /etc/containerd/certs.d/ghcr.io/hosts.toml
mkdir -p /host/etc/systemd/system/containerd.service.d/
touch /host/etc/systemd/system/containerd.service.d/http-proxy.conf


# # containerD deprecated "mediaType": "application/octet-stream" 
# # use internet for now
sudo tee /etc/containerd/certs.d/docker.io/hosts.toml<<EOF
server = "https://registry-1.docker.io"

[host."http://$DOCKERCACHE:5000"]
  capabilities = ["pull", "resolve", "push"]
  skip_verify = true
  auth = ""
  plain_http = true
EOF

sudo tee /etc/containerd/certs.d/k8s.io/hosts.toml<<EOF
server = "https://registry.k8s.io"

[host."http://$DOCKERCACHE:5001"]
  capabilities = ["pull", "resolve"]
  skip_verify = true
  auth = ""
  plain_http = true
EOF


sudo tee /etc/containerd/certs.d/gcr.io/hosts.toml<<EOF
server = "https://gcr.io"

[host."http://$DOCKERCACHE:5003"]
  capabilities = ["pull", "resolve"]
  skip_verify = true
  auth = ""
  plain_http = true
EOF

sudo tee /etc/containerd/certs.d/ghcr.io/hosts.toml<<EOF
server = "https://ghcr.io"

[host."http://$DOCKERCACHE:5004"]
  capabilities = ["pull", "resolve"]
  skip_verify = true
  auth = ""
  plain_http = true
EOF


sudo tee /etc/containerd/certs.d/quay.io/hosts.toml<<EOF
server = "https://quay.io"

[host."http://$DOCKERCACHE:5005"]
  capabilities = ["pull", "resolve"]
  skip_verify = true
  auth = ""
  plain_http = true
EOF

sudo tee /host/etc/systemd/system/containerd.service.d/http-proxy.conf<<EOF
[Service]
Environment="HTTP_PROXY=http://$DOCKERCACHE"
Environment="HTTPS_PROXY=http://$DOCKERCACHE"
EOF


sudo systemctl restart containerd
