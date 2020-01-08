# AWS EC2 自动开关机方案(AWS中国区域:北京/宁夏测试通过)
## 功能描述
- 中国时间每日09:00，开启宁夏，北京区域标签AutoStart==True的EC2
- 中国时间每日18:00，关闭宁夏，北京区域标签AutoStop==True的EC2

## 手工操作步骤
 - 1. 宁夏区域，创建lambda函数 auto_ec2_start, python 3.7, 代码使用auto_ec2_start.py内容, Execution role使用auto_ec2_start_role.json内容
 - 2. 宁夏区域，创建lambda函数 auto_ec2_stop , python 3.7, 代码使用auto_ec2_stop.py内容 , Execution role使用auto_ec2_stop_role.json内容
 - 3. 宁夏区域，CloudWatch Event Rule中，创建新的规则 auto_ec2_start: Schedule Cron expression "0 1 * * ? *", target: lambda-> auto_ec2_start. 
 - 4. 宁夏区域，CloudWatch Event Rule中，创建新的规则 auto_ec2_stop: Schedule Cron expression "0 10 * * ? *", target: lambda-> auto_ec2_stop. 
 - 4. 需要自动启动的EC2，增加标签(Key=AutoStart, Value=True)
 - 5. 需要自动停止的EC2，增加标签(Key=AutoStop, Value=True)

## TODO
 [ ] CDK方式发布
 [ ] CloudFormation方式发布
 [ ] 标签自定义操作时间
