'''
Date: 2022-06-02 10:47:06
LastEditTime: 2022-06-14 22:09:04
Description: file content
'''
'''
Date: 2022-04-27 21:02:24
LastEditTime: 2022-04-29 10:17:01
Description: file content
'''
import ctypes
import time
import xml.dom.minidom


def createXml(cfgList):
    doc = xml.dom.minidom.Document()

    root = doc.createElement('cfg')
    doc.appendChild(root)

    for i in cfgList:
        for j in i:
            nodeDelta = doc.createElement(j)
            nodeDelta.appendChild(doc.createTextNode(str(i[j])))
            root.appendChild(nodeDelta)

    xmlFile = open("./Cfg.xml", 'w')
    doc.writexml(xmlFile, indent='\t', addindent='\t', newl='\n', encoding="utf-8")


def getNanoSec(txtPath, appPath):
    libPath = appPath.rsplit("/", 1)[0] + "/lib/libsim.so"
    libso = ctypes.CDLL(libPath)

    input = ctypes.c_char_p()  #对应c指针类型 char *p
    input.value = txtPath.encode('utf-8')  #字符串赋值

    nanoSec = libso.get_nsec_of_txt(input)

    if nanoSec == 0:
        nanoSec = None

    return nanoSec


def timeInfoSave(timeInfoQueue, startTime, appPath):
    timeLogDir = appPath + "/log/"
    timeLogPath = time.localtime(startTime)
    timeLogPath = timeLogDir + str(timeLogPath[1]) +"_"+ str(timeLogPath[2]) +"_"+ str(timeLogPath[3]) +"_"\
                + str(timeLogPath[4])+"_"+ str(timeLogPath[5]) + ".log"

    if not timeInfoQueue.empty():
        content = timeInfoQueue.get()
        contentToWrite = str(content[0]) + "\t" + str(content[1]) + "\n"
        with open(timeLogPath, "a", encoding="utf-8") as f:
            f.write(contentToWrite)
    else:
        pass

    return