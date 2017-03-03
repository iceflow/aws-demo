#!/usr/bin/python
# -*- coding: utf8 -*-

import sys
from log import *
from es_put import *
from ip2geo import *

### 常量定义
DUMP_PROCESS_NUM = 1          # 当日志条数累计到DUMP_PROCESS_NUM数量，触发入库

INT_VAL_NUM = 20                # INT64类型数量
STR_VAL_NUM = 20                # STR类型数量

INDICES_PREFIX = "cf-logs-"
DEFAULT_TYPE = "log"
CF_LOGS_WEB_SIZE = 24

################  全局变量 - 开始 ########################################
#### 日志
log = Log('CF_LOGS_TO_ES', '/var/log/cf_logs_to_es.log')
#### 数据库连接
#uf = unix_conf_file(db_class.default_config_file)
#cfg = uf.read()
#db = db_class(cfg=cfg)
#log_db = db_class(host=cfg['LOGDB_HOST'], port=int(cfg['LOGDB_PORT']), user=cfg['LOGDB_USER'], passwd=cfg['LOGDB_PASS'])

#### 应用数据
es_server  = None               # ES 服务器
value_list = []                 # 数据待入库列表
################  全局变量 - 结束 ########################################


#  //完整网络包格式：总长度(4)+协议ID(2)+protobuf流数据长度(4)+protobuf流数据内容
def process_line(s):
    if CF_LOGS_WEB_SIZE != len(s):
        log.info('日志字段数量不匹配%d: %d(%s)'%(CF_LOGS_WEB_SIZE, len(s), ' '.join(s)))
        return

    # 数据分段
    data = {}
    data["@timestamp"] = "%s:%s +0000"%(s[0], s[1]);
    data["x-edge-location"] = s[2];
    data["sc-bytes"] = int(s[3]);
    data["c-ip"] = s[4];
    data["location"] = get_geo_location(s[4]);
    data["cs-method"] = s[5];
    data["cs-host"] = s[6];
    data["cs-uri-stem"] = s[7];
    data["sc-status"] = s[8];
    data["cs-feferer"] = s[9];
    data["cs-user-agent"] = s[10];
    data["cs-uri-query"] = s[11];
    data["cs-cookie"] = s[12];
    data["x-edge-result-type"] = s[13];
    data["x-edge-request-id"] = s[14];
    data["x-host-header"] = s[15];
    data["cs-protocol"] = s[16];
    data["cs-bytes"] = s[17];
    data["time-taken"] = s[18];
    data["x-forwarded-for"] = s[19];
    data["ssl-protocol"] = s[20];
    data["ssl-cipher"] = s[21];
    data["x-edge-response-result-type"] = s[22];
    data["cs-protocol-version"] = s[23];
    
    #print data
    #put_data_to_es(es_server, '%s%s'%(INDICES_PREFIX, s[0]), DEFAULT_TYPE, data)
    put_data_to_es(es_server, 'cf-logs-2017-02-25', 'log', data)

def parse_file(es_server, filename):
    log.debug('开始分析文件:%s'%(filename))

    if not os.path.exists(filename):
        log.debug('文件%s不存在'%(filename))
        return

    total_num = 0       # 处理数量总数
    process_num = 0     # 未入库数量
    with open(filename) as f:
        for line in f.readlines():
            line = line.strip()
            if not len(line) or line.startswith('#'):
                continue
            sections = line.split('\t')
            if len(sections) > 1:
                #print ("sections[%d]"%len(sections))

                data = process_line(sections)
   

            total_num += 1
            process_num += 1


    log.debug('完成分析文件:%s 数量:%d'%(filename, total_num))

def usage(prog):
    print "%s usage:"%(prog)
    print "   %s es_server log_file [log_file] [log_file] ... : 分析日志文件列表"%(prog)

if __name__ == '__main__':

    # 参数检查
    argc = len(sys.argv)

    if argc < 2:
        usage(sys.argv[0])
        sys.exit(1)

    es_server = sys.argv[1]

    log.info('开始批量分析日志文件到%s: %s'%(es_server, ' '.join(sys.argv[1:])))

    # 数据分析
    for pos in xrange(argc-2):
        parse_file(es_server, sys.argv[pos+2])

    sys.exit(0)
