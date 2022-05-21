import tkinter as tk
import sys
import ttkbootstrap as ttk
from tkinter import filedialog

sys.path.append('..')

from src.main_control import *
from src import tool

import threading
from queue import Queue
import time
import sys
import os


class TextRedirector(object):

    def __init__(self, widget, tag='stdout'):
        self.widget = widget
        self.tag = tag

    def write(self, str):
        self.widget.configure(state='normal')
        self.widget.insert(tk.END, str, (self.tag, ))
        self.widget.configure(state='disabled')


class Application(tk.Tk):

    def __init__(self):
        super(Application, self).__init__()

        self.projectPath = ""
        self.simTime = tk.IntVar()
        self.wallClock = tk.IntVar()
        self.ratio = tk.DoubleVar()
        self.timeInfoQueue = Queue()
        self.runningFlag = False

        #View
        self.title(appName)
        self.width = 800
        self.height = 494
        self.geometry(str(self.width) + 'x' + str(self.height))
        self.resizable(0, 0)

        self.menubar = ttk.Menu(self, font=("fangsong ti", '12'))

        self.filemenu = ttk.Menu(self.menubar, tearoff=0, font=("fangsong ti", '10'))
        self.filemenu.add_command(label="打开", command=self.open)
        self.filemenu.add_command(label="退出", command=self.__destroy)

        self.aboutmenu = ttk.Menu(self.menubar, tearoff=0, font=("fangsong ti", '12'))
        self.aboutmenu.add_command(label="关于OpenEmulator")
        self.aboutmenu.add_command(label="关于OpenTSN")

        self.menubar.add_cascade(label="文件", menu=self.filemenu)
        self.menubar.add_cascade(label="关于", menu=self.aboutmenu)
        self['menu'] = self.menubar

        self.leftFrame = ttk.Frame(self, height=200, width=500)
        self.leftFrame.pack(side='left', expand=True, fill='both')

        self.ltFrame = ttk.Frame(self.leftFrame)
        self.ltFrame.pack(side='top', expand=False, fill='both', pady=20)

        self.simTimeLabel = ttk.Label(self.ltFrame, text="仿真推进时间(单位:ns):", bootstyle="dark", font=("fangsong ti", '12'))
        self.simTimeLabel.pack(side='left', expand=False, padx=15, pady=10)

        self.simTimeValue = ttk.Label(self.ltFrame, textvariable=self.simTime, bootstyle="dark", font=("fangsong ti", '12'))
        self.simTimeValue.pack(side='left', expand=False, padx=0, pady=00)

        self.wallClockLabel = ttk.Label(self.ltFrame, text="墙钟推进时间(单位:s):", bootstyle="dark", font=("fangsong ti", '12'))
        self.wallClockLabel.pack(side='left', expand=False, padx=10, pady=0)

        self.wallClockValue = ttk.Label(self.ltFrame, textvariable=self.wallClock, bootstyle="dark", font=("fangsong ti", '12'))
        self.wallClockValue.pack(side='left', expand=False, padx=0, pady=0)

        self.lmFrame = ttk.Frame(self.leftFrame)
        self.lmFrame.pack(side='top', expand=False, fill='both', pady=10)

        self.ratioLabel = ttk.Label(self.lmFrame, text="仿真推进时间(us)/墙钟推进时间(s):", font=("fangsong ti", '12'))
        self.ratioLabel.pack(side='left', expand=False, padx=15, pady=0)

        self.ratioValue = ttk.Label(self.lmFrame, textvariable=self.ratio, font=("fangsong ti", '12'))
        self.ratioValue.pack(side='left', expand=False, padx=0, pady=0)

        self.text = ttk.Text(self.leftFrame, state="disabled", wrap='word', font=("fangsong ti", '14'))
        self.text.pack(side='bottom', expand=True, fill='both', padx=10, pady=20)
        self.text.tag_configure('stderr', foreground='#b22222')

        self.scrollBar = ttk.Scrollbar(self.text)
        self.scrollBar.pack(side='right', fill='y')
        self.scrollBar.config(command=self.text.yview)
        self.text.config(yscrollcommand=self.scrollBar.set)

        self.rightFrame = ttk.Frame(self)
        self.rightFrame.pack(side='right', expand=False, fill='both', padx=30)

        self.rmFrame = ttk.Frame(self.rightFrame)
        self.rmFrame.pack(side='top', expand=False, fill='both', padx=0, pady=0)

        self.logo = ttk.PhotoImage(file="./image/fenglin.gif")
        self.label_img = ttk.Label(self.rmFrame, image=self.logo)
        self.label_img.pack(side="top", expand=False, fill='x', padx=20, pady=0)

        self.rmmFrame = ttk.Frame(self.rightFrame)
        self.rmmFrame.pack(side='top', expand=False, fill='both', padx=0, pady=20)

        self.startupBut = ttk.Button(self.rightFrame, text="启动", state="disabled", command=self.__startup, bootstyle="success")
        self.startupBut.pack(side='top', expand=False, fill='x', padx=0, ipadx=50, pady=10)

        self.stopBut = ttk.Button(self.rightFrame, text="停止", state="disabled", command=self.__stop, bootstyle="danger")
        self.stopBut.pack(side='top', expand=False, fill='x', padx=0, ipadx=50, pady=10)

        sys.stdout = TextRedirector(self.text, 'stdout')
        sys.stderr = TextRedirector(self.text, 'stderr')

    #     self.refreshText()

    # def refreshText(self):
    #     self.text.see(tk.END)
    #     self.after(100,self.refreshText)

    def update(self):

        timeTxtPath = self.projectPath + "/data/time.txt"
        # timeTxtPath ="./time.txt"

        #only update the time  when in running
        if self.runningFlag is True:
            newSimTime = tool.getNanoSec(timeTxtPath, appPath)
            newSysTime = time.time()
            # print(newSysTime,newSimTime)

            # self.wallClock.set(str(newSysTime).split(".",2)[0])
            if newSimTime is not None:
                self.simTime.set(newSimTime)
                newSysTimeSec = int(str(newSysTime).split(".", 2)[0])

                #get the simtime for the first time
                if self.firstGetSimTime is True:
                    self.wallClock.set(0)
                    self.firstGetSimTime = False
                    self.firstWallClock = newSysTimeSec
                else:
                    self.wallClock.set(newSysTimeSec - self.firstWallClock + 1)
                    ratio = self.simTime.get() / 1000 / (self.wallClock.get())
                    self.ratio.set(round(ratio, 2))

            #only save timeinfo after get the sim time for the first time
            if self.firstGetSimTime is False:
                timeInfo = (newSysTime, newSimTime)
                self.timeInfoQueue.put(timeInfo)
                timeInfoSave_t = threading.Thread(target=tool.timeInfoSave, args=(self.timeInfoQueue, self.startTime, appPath))
                timeInfoSave_t.start()

        self.text.see(tk.END)

        self.after(1000, self.update)

    def __startup(self):
        init_file(self.projectPath)
        self.startTime = time.time()
        self.firstGetSimTime = True
        self.firstWallClock = ""
        self.runningFlag = True
        self.wallClock.set("")
        self.simTime.set("")
        self.ratio.set("")

        self.text['state'] = tk.NORMAL
        # self.text.delete('1.0',tk.END)
        self.text['state'] = tk.DISABLED

        self.startupBut['state'] = tk.DISABLED
        self.stopBut['state'] = tk.NORMAL
        self.startup_t = threading.Thread(target=startup, args=(self.projectPath, appPath), daemon=True)
        self.startup_t.start()

        self.update()

    def __stop(self):
        self.startupBut['state'] = tk.NORMAL
        self.stopBut['state'] = tk.DISABLED
        self.runningFlag = False
        self.stop_t = threading.Thread(target=stop)
        self.stop_t.start()

    def open(self):
        path = filedialog.askdirectory(title='选择路径', initialdir=None)
        print("----------------------------------------------------------------------------------------------------------")
        print("Please MAKE SURE you have selected the CORRET project path:")
        print(path)
        print("----------------------------------------------------------------------------------------------------------")
        self.projectPath = str(path)
        self.startupBut['state'] = tk.NORMAL

    def __destroy(self):
        self.destroy()


if __name__ == '__main__':
    appName = "OpenEmulator for TSN"
    appPath = os.getcwd()
    app = Application()
    app.mainloop()
