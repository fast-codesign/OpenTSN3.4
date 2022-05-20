'''
Date: 2022-04-27 21:02:24
LastEditTime: 2022-04-29 10:17:01
Description: file content
'''
import ctypes
import time


def getNanoSec(txtPath, appPath):
    libso = ctypes.CDLL(appPath + '/lib/libsim.so')

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