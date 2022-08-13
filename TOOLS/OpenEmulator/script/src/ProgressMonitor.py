'''
Date: 2022-06-01 18:55:18
LastEditTime: 2022-06-09 10:39:03
Description: file content
'''
from PyQt5 import QtCore
import src.tool as tool


class ProgressMonitor(QtCore.QThread):

    progressSignal = QtCore.pyqtSignal(int)

    def __init__(self, projectPath, appPth):
        super().__init__()
        self.stopFlag = False
        self.projectPath = projectPath
        self.appPath = appPth
        self.timeMonitorPath = projectPath + '/data/time.txt'
        self.tsnLightMonitorPath = projectPath + '/tsn_applications/tsnlight/debug_error.txt'
        self.ptpBcMonitorPath = projectPath + '/tsn_applications/ptp_bc/debug_error.txt'

    def stop(self):
        self.stopFlag = True

    def run(self):
        #TODO:monitor sim
        self.stopFlag = False

        while (self.stopFlag is False):
            simTime = tool.getNanoSec(self.timeMonitorPath, self.appPath)
            if simTime is not None:
                print("Co-Emulation env sucessfully lunched!")
                print("tsnlight signal")
                self.progressSignal.emit(1)
                break
            else:
                continue

        #TODO:
        while (self.stopFlag is False):
            with open(self.tsnLightMonitorPath, 'r', encoding="utf-8") as f:
                if "SYNC_INIT_S" in f.read():
                    print("TSNlight successfully completed the configuration!")
                    print("ptpbc signal")
                    self.progressSignal.emit(2)
                    break

        #TODO:monitor ptp bc
        while (self.stopFlag is False):
            with open(self.ptpBcMonitorPath, 'r', encoding="utf-8") as f:
                if "init finish,start timer and receive pkt" in f.read():
                    # print(f.read())
                    # print("PTP_BC successfully lunched!")
                    print("ptp signal")
                    self.progressSignal.emit(3)
                    break
        print("Progress monitor exit")
