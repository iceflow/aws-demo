

# Generate SQS task
s3_copy_from_inventory.sh
 |- inventory_files_to_sqs.py


# Consume SQS tasks
start_read_sqs.sh
 |-read_sqs.sh
    |- s3_copy_from_sqs.py
