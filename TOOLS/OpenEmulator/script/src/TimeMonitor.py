'''
Date: 2022-06-04 16:36:54
LastEditTime: 2022-06-07 18:56:38
Description: file content
'''
import time
from PyQt5 import QtCore
import src.tool as tool


class TimeMonitor(QtCore.QThread):

    newTimeSignal = QtCore.pyqtSignal(int, int, float)
    stopSignal = QtCore.pyqtSignal()

    def __init__(self, projectPath, appPath):
        super().__init__()
        self.timeMonitorPath = projectPath + '/data/time.txt'
        self.appPath = appPath

    def setDeadline(self, deadline):
        self.deadline = deadline

    def stop(self):
        self.stopFlag = True

    def run(self):
        firstGetTimeFlag = True
        wallClock = None
        ratio = None
        simTime = None
        self.stopFlag = False

        while (self.stopFlag is False):
            simTime = tool.getNanoSec(self.timeMonitorPath, self.appPath)
            wallClock = int(str(time.time()).split(".", 2)[0])
            if simTime is not None:
                simTime = simTime / 1000
                #get the simtime for the first time
                if firstGetTimeFlag is True:

                    firstWallClock = wallClock
                    wallClock = 1
                    firstGetTimeFlag = False
                else:
                    wallClock = (wallClock - firstWallClock + 1)

                ratio = simTime / (wallClock)
                ratio = (round(ratio, 2))
                # print(self.wallClock, self.simTime, self.ratio)
                self.newTimeSignal.emit(simTime, wallClock, ratio)
                if simTime >= self.deadline * 1000:
                    self.stopSignal.emit()
                    break

            time.sleep(1)
        print("time monitor exit")

    # def
