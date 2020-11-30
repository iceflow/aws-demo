
# Using Rclone to copy data

Configuration file: ~/.config/rclone/rclone.conf

rclone config show

rclone listremotes

# List direct
rclone lsd chinakb-bjs:

# List objects
rclone ls chinakb-bjs:

root@ip-172-31-36-20:/data/aws-demo/s3/data-sync# time rclone copy nwcdlabs-bjs:reinvent-bak-bjs/reinvent nwcdlabs-bjs:reinvent -P
Transferred:       20.559G / 1009.789 GBytes, 2%, 246.635 MBytes/s, ETA 1h8m27s
Checks:               212 / 338, 63%
Transferred:           53 / 10073, 1%
Elapsed time:      1m25.6s
Checking:
 * 2014/AWS-reInvent-2014…nce-on-AWS-YouTube.mp4: checking
 * 2014/AWS-reInvent-2014…plications-YouTube.mp4: checking
 * 2014/AWS-reInvent-2014…-the-Cloud-YouTube.mp4: checking
 * 2014/AWS-reInvent-2014…AWS-Lambda-YouTube.mp4: checking
 * 2014/AWS-reInvent-2014…es-Mailbox-YouTube.mp4: checking
 * 2014/AWS-reInvent-2014…nd-the-Web-YouTube.mp4: checking
 * 2014/AWS-reInvent-2014…-Analytics-YouTube.mp4: checking
 * 2014/AWS-reInvent-2014…Footprints-YouTube.mp4: checking
Transferring:
 * 2015/Architecture/AWS …n - YouTube [720p].mp4:  0% /486.729M, 0/s, -
 * 2016/re -Invent 2016 B…Practices (ARC402).mp4:  0% /215.463M, 0/s, -
 * 2016/re -Invent 2016 B… Patterns (ARC305).mp4:  0% /177.355M, 0/s, -
 * 2016/re -Invent 2016 B…PC Design (ARC302).mp4:  0% /218.281M, 0/s, -


##
root@ip-172-31-36-20:/data/aws-demo/s3/data-sync# time rclone copy nwcdlabs-bjs:reinvent-bak-bjs/reinvent nwcdlabs-bjs:reinvent -P
Transferred:       88.356G / 1.069 TBytes, 8%, 229.135 MBytes/s, ETA 1h14m56s
Transferred:        1.190T / 1.190 TBytes, 100%, 222.742 MBytes/s, ETA 0s
Checks:               338 / 338, 100%
Transferred:        12533 / 12533, 100%
Elapsed time:   1h33m20.0s

real    93m20.047s
user    0m16.996s
sys     0m4.097s
