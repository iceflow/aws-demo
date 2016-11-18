

aws --debug logs create-export-task --task-name test_task --log-group-name /var/log/messages --from 1469280120000 --to 1479280120000 --destination leo-logs --destination-prefix cwlogs/messages


#aws logs describe-export-tasks --task-id  10e11650-d5f1-4901-b627-0db9ea5768dc
