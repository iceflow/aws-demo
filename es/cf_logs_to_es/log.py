#!/usr/bin/python
# -*- coding: utf8 -*-

from utils import *
import os
import syslog


#syslog.openlog('YSPAY', 0, syslog.LOG_LOCAL1 )

# 基础消息类
#########################
class Log:
    ''' 日志类 用于记录日志行为'''

    def __init__(self, app_name=None, log_file=None):
        self.app_name = app_name
        self.log_file = log_file

        self.msg = None
        self.log_level = None
        self.create_time = None

    def print_log(self):
        print "%s %s %s"%(self.create_time, self.app_name, self.msg)


    def do_log(self, msg, level):
        self.create_time = get_time()
        self.msg = msg

        self.print_log()

        content = "%s %s %s"%(self.create_time, self.app_name, self.msg)

        with open(self.log_file,'a') as f:
            f.write(content+'\n')

        #syslog.syslog(level, content)

        #self.save_to_db()

        return

    def info(self, msg):
        self.log_level = 'info'
        self.do_log(msg, syslog.LOG_INFO)

    def debug(self, msg):
        self.log_level = 'debug'
        self.do_log(msg, syslog.LOG_DEBUG)

if __name__ == "__main__":

    Log.info("xxxx")

