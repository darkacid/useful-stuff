from time import sleep
import libvirt
conn = libvirt.open('qemu:///system')

a = conn.listAllDomains()

for i in range(0,3):
    canHalt = True
    for domain in a:
        if domain.isActive() == 1:
            domain.shutdown()
            canHalt = False
    if canHalt:
        exit (0)
    sleep(15)
sleep(5)
if domain.isActive() == 1:
    domain.destroy()
sleep(5)