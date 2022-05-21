'''
Date: 2022-04-27 21:02:24
LastEditTime: 2022-04-28 16:03:02
Description: file content
'''
import os


def kill_process(process_name):
    try:
        os.system("killall -9 " + process_name)
        print("process " + process_name + " has been stopped")

    except OSError:
        print("no such process!")


def kill_sim():
    process_name = "simv_1"
    kill_process(process_name)


def kill_tsnlight():
    process_name = "tsnlight"
    kill_process(process_name)


def kill_interlock():
    process_name = "interlock"
    kill_process(process_name)


def kill_opensync():
    process_name = "ptp_app"
    kill_process(process_name)
