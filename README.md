# Example domain deployment:

```
KVM Host
┌─────────────────────────────────────────────────────────────┐
│     ┌────────────────────────────────────────────────┐      │
│     │                    example                     │      │
│     │                                                │      │
│     │   ┌─────────────────┐    ┌─────────────────┐   │      │
│     │   │                 │    │                 │   │      │
│     │   │  Primary Disk   │    │ Cloud-Init Disk │   │      │
│     │   │                 │    │                 │   │      │
│     │   └─────────────────┘    └─────────────────┘   │      │
│     └──────────────────────┬─────────────────────────┘      │
│                            │                                │
│  ■─────────────────────────┴─────────────────────────────■  │
└─────────────────────────────────────────────────────────────┘
```
## Download and verify base image
```
curl -O https://dl.rockylinux.org/pub/rocky/9.3/images/x86_64/Rocky-9-GenericCloud-Base-9.3-20231113.0.x86_64.qcow2
curl -O https://dl.rockylinux.org/pub/rocky/9.3/images/x86_64/Rocky-9-GenericCloud-Base-9.3-20231113.0.x86_64.qcow2.CHECKSUM
sha256sum --check Rocky-9-GenericCloud-Base-9.3-20231113.0.x86_64.qcow2.CHECKSUM
```
## Create base image volume
```
export LIBVIRT_DEFAULT_URI=qemu:///system
virsh vol-create-as --pool filesystems --name rocky-base-9.3 --capacity 1g
virsh vol-upload --pool filesystems --vol rocky-base-9.3 --file Rocky-9-GenericCloud-Base-9.3-20231113.0.x86_64.qcow2
```
## Deploy virtual machines
```
terraform init
terraform plan
terraform apply -auto-approve
```
... later
```
terraform destroy -auto-approve
```
