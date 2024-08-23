import libvirt
from xml.dom import minidom

conn = libvirt.open('qemu:///system')
domainIDs = conn.listAllDomains(0)

print("\tNAME\tSTATE\tCPUs\tMEM\tDISK\tUSED")
for domain in domainIDs:
        raw_xml = domain.XMLDesc(0)
        state, maxmem, mem2, cpus, cput = domain.info()
        name = domain.name()
        mem   = domain.maxMemory()/1024**2
        xml = minidom.parseString(raw_xml)
        diskTypes = xml.getElementsByTagName('disk')
        for diskType in diskTypes:
                if diskType.getAttribute('device') == 'disk':
                        diskNodes = diskType.childNodes
                        for diskNode in diskNodes:
                                if diskNode.nodeName == 'source':
                                        for attr in diskNode.attributes.keys():
                                                if diskNode.attributes[attr].name == 'file':
                                                        blkinf = domain.blockInfo(diskNode.attributes[attr].value)
                if   state == 1: vmstate = "running"
                elif state == 5: vmstate = "stopped"
                disksize = round(blkinf[0]/1024**3)
                diskused = round(blkinf[1]/1024**3)
        print(name+"\t"+vmstate+"\t"+str(cpus)+"\t"+str(mem)+"G"+"\t"+str(disksize)+"G\t"+str(diskused)+"G")

conn.close()
