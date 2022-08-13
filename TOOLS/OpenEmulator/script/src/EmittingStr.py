'''
Date: 2022-06-01 15:07:46
LastEditTime: 2022-06-01 15:09:03
Description: file content
'''

from PyQt5 import QtCore

class EmittingStr(QtCore.QObject):  
        textWritten = QtCore.pyqtSignal(str)  #定义一个发送str的信号
        def write(self, text):
            self.textWritten.emit(str(text))
