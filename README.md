# Example domain deployment:

```
KVM Host
┌───────────────────────────────────────────────────────────┐
│     ┌──────────────────────────────────────────────┐      │
│     │                    example                   │      │
│     │   ┌─────────────────┐  ┌─────────────────┐   │      │
│     │   │                 │  │                 │   │      │
│     │   │  primary_disk   │  │ cloud_init_disk │   │      │
│     │   │                 │  │                 │   │      │
│     │   └────────┬────────┘  └─────────────────┘   │      │
│     │   ┌────────┴────────┐                        │      │
│     │   │                 │                        │      │
│     │   │  base_volume    │                        │      │
│     │   │                 │                        │      │
│     │   └─────────────────┘                        │      │
│     └──────────────────────┬───────────────────────┘      │
│                            │                              │
│  ■─────────────────────────┴───────────────────────────■  │
└───────────────────────────────────────────────────────────┘
```
## Prerequisites

Make sure you have generated a SSH key-pair as this project will injet the public key at ``~/.ssh/id_rsa.pub``.

Review deployment-specific environment variables:
```
grep TF_VAR deployment.env
  export TF_VAR_libvirt_uri="${LIBVIRT_DEFAULT_URI}"
  export TF_VAR_guest_name="example"
  export TF_VAR_base_volume_name="rocky-base-9.3"
  export TF_VAR_base_volume_size=$(numfmt --from=auto 20Gi)
  export TF_VAR_user="${USER}"
  export TF_VAR_ssh_public_key="$(cat ~/.ssh/id_rsa.pub)"
```
## Download and verify base image
```
# Rocky Linux

curl -O https://dl.rockylinux.org/pub/rocky/9.3/images/x86_64/Rocky-9-GenericCloud-Base-9.3-20231113.0.x86_64.qcow2
curl -O https://dl.rockylinux.org/pub/rocky/9.3/images/x86_64/Rocky-9-GenericCloud-Base-9.3-20231113.0.x86_64.qcow2.CHECKSUM
sha256sum --check Rocky-9-GenericCloud-Base-9.3-20231113.0.x86_64.qcow2.CHECKSUM

# Ubuntu Jammy

curl -O https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64-disk-kvm.img
```
## Create base image volume
```
export LIBVIRT_DEFAULT_URI=qemu:///system
virsh vol-create-as --pool filesystems --name rocky-base-9.3.qcow2 --capacity 1m
virsh vol-upload --pool filesystems --vol rocky-base-9.3.qcow2 --file Rocky-9-GenericCloud-Base-9.3-20231113.0.x86_64.qcow2

virsh vol-create-as --pool filesystems --name ubuntu-jammy-base.qcow2 --capacity 1m
virsh vol-upload --pool filesystems --vol ubuntu-jammy-base.qcow2 --file jammy-server-cloudimg-amd64-disk-kvm.img
```
## Deploy virtual machine
```
. deployment.env    # set environment

terraform init
terraform plan
terraform apply -auto-approve
```
## Find the IP address of the VM and ssh into it
```
$ virsh net-dhcp-leases --network default

 Expiry Time           MAC address         Protocol   IP address          Hostname   Client ID or DUID
-----------------------------------------------------------------------------------------------------------
 2024-03-28 23:02:16   52:54:00:86:8e:e2   ipv4       192.168.122.46/24   -          01:52:54:00:86:8e:e2

$ ssh 192.168.122.46
```
... later
```
terraform destroy -auto-approve
```
