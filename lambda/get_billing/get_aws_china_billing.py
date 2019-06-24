import json
import boto3
import time

from datetime import datetime, timedelta, timezone

def get_region_billing(region_name='cn-northwest-1'):
    client = boto3.client('cloudwatch',region_name=region_name)        # 创建cloudwatch，可以指定region_name
    endTime = datetime.utcnow().replace(tzinfo=timezone.utc)            # 统计结束时间（当前时间）
    delta = timedelta(days=1)                                           # 时间间隔位1天
    startTime = endTime-delta                                           # 统计开始时间（当前时间前一天）
    
    metrics = client.list_metrics(                                      # 获取账单分类度量（按服务分类）
        Namespace='AWS/Billing'
    )
    
    billings = []                                                       # 创建存放账单信息的列表   
    
    for i,v in enumerate(metrics['Metrics']):                           # 对度量进行循环，获取不同的度量账单
        res = client.get_metric_data(
            MetricDataQueries=[
                {
                    'Id': 'm1',
                    'MetricStat': {
                        'Metric': {
                            'Namespace': 'AWS/Billing',
                            'MetricName': 'EstimatedCharges',
                            'Dimensions': v['Dimensions']               # 将每个度量的Dimensions取出作为参数
                        },
                        'Period': 300,
                        'Stat': 'Average',
                        'Unit': 'None'
                    }
                },
            ],
            StartTime=startTime,                                        # 当前时间1天前，获取近一天的账单信息
            EndTime=endTime                                             # 当前时间
        )
        # 将每个度量获取的服务名和账单保存进billings列表
        serviceName = v['Dimensions'][0]['Value']
        servicePrice = res['MetricDataResults'][0]['Values'][0] if res['MetricDataResults'][0]['Values'] else '0.0'
        billings.append({'ServiceName':serviceName,"Price":servicePrice})
        
    billTime = res["MetricDataResults"][0]["Timestamps"][0]             # 最近账单时间（账单每天出两次，1：30和13：30，UTC时间）
    cnBillTime = billTime.astimezone(timezone(timedelta(hours=8)))      # 最近账单的中国时间 +8:00
    formatTime = cnBillTime.strftime("北京时间%Y年%m月%d日%H:%M:%S")     # 对账单时间进行格式化输出
    
    for i,v in enumerate(billings):
        if v["ServiceName"] == "CNY":
            v["ServiceName"] = "总账单(RMB)"                              # 替换列表中主账单的名称为"总账单(RMB)" 
            billings.remove(v)                                           # 把总帐单删除
            billings.insert(0,v)                                         # 把总帐单放到列表第一位
            break
    

    print(billings)
    return(billings[0]['Price'])

    
    
def lambda_handler(event, context):
    beijing_billing = get_region_billing('cn-north-1')
    ningxia_billing = get_region_billing('cn-northwest-1')
        
    print(beijing_billing)
    print(ningxia_billing)
    return {
        'message': 'AWS中国本月消费￥{}，其中宁夏区域消费￥{}，北京区域消费￥{}'.format(beijing_billing+ningxia_billing, ningxia_billing, beijing_billing)
    }
