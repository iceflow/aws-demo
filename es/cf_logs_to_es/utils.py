#!/usr/bin/python
# -*- coding: utf8 -*-

import sys
import datetime
import hmac
import hashlib
import json

''' Python 常用函数库 '''

from urllib import unquote
import ConfigParser
import codecs
import time
import os


def parse_groups_to_users_list(db, groups_ids):
    '''
        传入以逗号分隔的用户组id字符串，例如：'1,2,3'
        return：所有用户组包含的用户id（字符串）的列表
    '''
    users_list = []
    groups_list = groups_ids.split(',')

    all_groups = []

    sql = "select * from oa_user_group where del_flg=0"
    try:
        res = db.sqldb_query(sql)
        if (res[0] > 0):
            all_groups = res[1]
    except Exception,e:
        print "mysql error",e
        return users_list
    
    def get_users_list(g_list, a_groups):
        u_list = []
        for group_id in g_list:
            for agroup in a_groups:
                if (group_id == str(agroup['id'])):
                    if (agroup['contained_users']):
                        u_list += agroup['contained_users'].split(',')
                    if (agroup['contained_groups']):
                        u_list += get_users_list(agroup['contained_groups'].split(','), all_groups)
        return u_list

    users_list = list(set(get_users_list(groups_list, all_groups)))

    return users_list

class jsonDateTimeEncoder(json.JSONEncoder):
    ''' jsonDateTimeEncoder().encode(object) 
        扩展json.dumps() datatime 使用类型
    '''
    def default(self, obj):
        if isinstance(obj, datetime.datetime):
            return obj.isoformat()
        elif isinstance(obj, datetime.date):
            return obj.isoformat()
        elif isinstance(obj, datetime.timedelta):
            return (datetime.datetime.min + obj).time().isoformat()
        else:
            return super(DateTimeEncoder, self).default(obj)

## Crypt ##
## 返回使用hmac_sha256散列计算得摘要
def hmac_sha256_msg(seed, content):
    return hmac.new(seed, msg=content, digestmod=hashlib.sha256).hexdigest()

def url_parse(query):

    length = len(query)
    num = 1
    dict = {}

    flag = 0

    for i in xrange(0, length):
        if query[i] == '&':
            num = num + 1
        if query[i] == '=':
            flag = 1
    if flag == 1:
        arg_list = query.split('&', num)
        for i in xrange(0, num):
            text = arg_list[i].split('=', 1)
            dict[text[0]] = unquote(text[1])

    return dict

def getUrlData(env):
    url={}
    
    if env is not None and 'REQUEST_URI' in env:
        uri = env['REQUEST_URI'].split('?', 1)

        if len(uri) > 1:
            url = url_parse(uri[1])

    return  url


def body_parse(body):
    print "body:", body
    ret = {}
    for line in body.split('\r\n'):
        if '=' in line:
            #ret[line.split("=")[0]] = line.split("=")[1]
            ret = dict(ret, **(url_parse(line)))
    return ret

def getCookieData(env):
    ''' def getCookieData(env): 分解获取cookie信息
        返回字典
        例子: 'HTTP_COOKIE': 'Remeber=checked; LoginUser=admin; LoginUserGuid=undefined'
    '''

    if 'HTTP_COOKIE' not in env:
        return {}
    
    cookie = env['HTTP_COOKIE'].split(';')
    cookie_dict = {}

    for i in xrange(len(cookie)):
        text = cookie[i].split('=', 1)
        if len(text) > 1:
            cookie_dict[text[0].strip()] = unquote(text[1]).strip()
        
    return cookie_dict

def getPostData(query):
    query = query.replace("+"," ")
    query = query.replace("%2B","+")
    d = {}
    a = query.split('&')
    for s in a:
        if s.find('='):
            k,v = map(urllib.unquote, s.split('='))
            d[k] = str(v)
    return d

def get_post_data(bodysize, input):
    ''' def get_post_data(bodysize, input):
        读取JSON格式POST提交，内容为UNICODE，需要转换为utf-8
        返回： dict
    '''
    data = json.loads(input.read(bodysize))
    #print "get_post_data", data
    for k,v in data.items():
        data[k] = data[k]
        if isinstance(data[k], unicode):
            data[k] = data[k].encode('utf-8')

    return data

# 功能: 读取key-value配置文件
# 返回: 正常返回数据字典, 异常返回None
def get_server_cfg(path):
    cfg_dict={}
    #print path

    cf = ConfigParser.ConfigParser()
    cf.readfp(codecs.open(path, "r", "utf-8-sig"))

    for section in cf.sections():
        for option in cf.options(section):
            cfg_dict[option] = cf.get(section, option).encode('utf-8')
        
    return cfg_dict


# 返回 YYYY-mm-dd HH:MM:SS格式时间字符串
def get_time():
    return time.strftime('%Y-%m-%d %T')

def today():
    return time.strftime('%Y-%m-%d')

def get_uptime():
    uptime_string = ""

    with open('/proc/uptime','r') as f:
        uptime_seconds = float(f.readline().split()[0])

        days = int(uptime_seconds/86400)

        today_uptime_seconds = uptime_seconds%86400
        hours = int(today_uptime_seconds/3600)

        hour_uptime_seconds = today_uptime_seconds%3600
        minutes = int(hour_uptime_seconds/60)
        seconds = int(hour_uptime_seconds%60)

    #uptime_string = "%02d天%02d小时%02d分钟%02d秒"%(days, hours, minutes, seconds)

    return {'days': repr(days), 'hours': repr(hours), 'minutes': repr(minutes), 'seconds': repr(seconds)}
    #return {'days': int(days), 'hours': int(hours), 'minutes': int(minutes), 'seconds': int(seconds)}

def make_day_list(start_date, end_date):
    '''  make_day_list(start_date, end_date): 根据输入得日期范围，返回日期列表 
        返回值: ['yyyy-mm-dd', ......]
    '''

    day_list = []    

    ## 日期范围错误，直接返回
    if start_date > end_date:
        return day_list

    ## Start day
    day_list.append(start_date)

    start_list = start_date.split('-')
    start_year = int(start_list[0])
    start_mon = int(start_list[1])
    start_day = int(start_list[2])

    d1 = datetime.date(start_year, start_mon, start_day)

    # 日期累计
    while True:
        d2 =  d1 + datetime.timedelta(1)

        if d2.isoformat() > end_date:
            break

        day_list.append(d2.isoformat())
        d1 = d2

    return day_list

def day_time_offset(day_time):
    ''' day_time_offset(day_time): 将时间格式"HH:MM:SS"转换为当天秒数 
        返回值: < 0, 异常
    '''
    s = day_time.split(':')

    if len(s) != 3:
        return -1

    hour = int(s[0])
    minute = int(s[1])
    second = int(s[2])

    if hour < 0 or hour > 23:
        return -2

    if minute < 0 or minute > 59:
        return -3

    if second < 0 or second > 59:
        return -4

    return hour*3600+minute*60+second


def make_day_time_list(interval):
    '''  make_day_time_list(interval, reverse=False)): 基于间隔秒数返回间隔开始时间字符串列表
        从 00:00:00 开始, interval 间隔分钟, 
        一天有 60*60*24=86400秒
        返回值: [0,....] max 86400
    '''
    offset = 0
    result = []
    interval_seconds = 60*interval

    while 1: 
        if offset >= 86400:
            break; 
        
        result.append(offset)
        offset += interval_seconds

    return result

class unix_conf_file:
    ''' class unix_conf_file: 获取unix key=value 配置文件map
        注意: key_upcase key全部使用大写或者小写，需要规范,保证前端json数据交互
    '''
    def __init__(self, conf_file, key_upcase=True):
        self.conf_file = conf_file 
        self.conf_map = {}
        self.key_upcase = key_upcase

        self.read()

    def get(self, key):
        if self.key_upcase:
            key = key.upper()
        else:
            key = key.lower()

        if key in self.conf_map:  
            return self.conf_map[key]

        return None

    def set(self, key, value):
        self.conf_map[key] = value

    def remove(self, key):
        if key in self.conf_map:
            del self.conf_map[key]

    def read(self):
        self.conf_map = {}
        with open(self.conf_file) as f:
            for line in f.readlines():
                line = line.strip()
                if not len(line) or line.startswith('#'):
                    continue
                sections = line.split('=')
                if len(sections) > 1:
                    if self.key_upcase:
                        self.conf_map[sections[0].strip().upper()] = sections[1].strip()
                    else:
                        self.conf_map[sections[0].strip().lower()] = sections[1].strip()

        return self.conf_map

    def write(self):
        with open(self.conf_file, 'w') as f:
            for k,v in self.conf_map.items():
                f.write('%s=%s\n'%(k.upper(),v))

def get_ip(dev):
    ''' def get_ip(dev): 获取接口IP地址 '''

    cmd = "ip addr show dev %s | grep 'inet ' | awk '{print $2}'"%(dev)

    return os.popen(cmd).readline().strip()

def get_default_gw():
    ''' def get_default_gw(): 获取默认网关IP地址 '''

    cmd = "ip route |grep default | awk '{print $3}'"

    return os.popen(cmd).readline().strip()

def get_all_users(db):
    '''
        获取所有del_flg=0的用户信息
    '''
    u_list = []

    try:
        sql = "select * from oa_user_list where del_flg=0"
        res = db.sqldb_query(sql)
        if (res[0] > 0):
            u_list = res[1]
    except Exception,e:
        print e
        return u_list

    return u_list


def get_file_create_time(filename):
    ''' def get_file_create_time(filename): 获取文件创建时间'''

    if os.path.exists(filename):
        return int(os.stat(filename).st_ctime)
    else:
        return 0

def get_file_content(filename):
    ''' def get_file_content(filename): 获取文件内容'''

    print "get_file_content(%s)"%filename

    data = ''

    if os.path.exists(filename):
        with open(filename) as f:
            for line in f.readlines():
                line = line.strip()
                data += "%s\r\n"%(line)

    return data


def secs2str(secs):
    return time.strftime("%Y-%m-%d %H:%M:%S",time.localtime(secs))   

def get_before_date(days, check_day=None):
    ''' 获取指定天数前的日期字符串 '''

    if check_day is not None:
        check_day_list = check_day.split('-')
        check_year = int(check_day_list[0])
        check_mon = int(check_day_list[1])
        check_day = int(check_day_list[2])

        day = datetime.date(check_year, check_mon, check_day)
    else:
        day = datetime.date.today()

    return str(day-datetime.timedelta(days=days))
    
##############################################
##  Test
##############################################
if __name__ == '__main__':
    #print make_day_list('2012-11-11', '2013-02-01')
    #l = make_day_time_list(15)
    #print len(l),l

    #print day_time_offset('00:10:00')
    #print day_time_offset('01:00:01')

#    A = hmac_sha256_msg('123', '321')
#    print type(A)


    A=today()

    print A

    #A=secs2str(1404144000)
    #print A

    #a = get_file_content('./rr')
    #print a

    #print parse_groups_to_users_list('')
    

    #print unix_conf_file("/rayeye/conf/admin.conf").get('lan_mode')

    '''
    uf = unix_conf_file("/rayeye/conf/admin.conf")

    A = uf.read()
    #print A

    uf.remove('LEO')

    uf.write()
    '''

    #print get_uptime()
    #print "[",get_ip('wlan0'),"]"
