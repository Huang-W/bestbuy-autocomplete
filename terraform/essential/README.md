# Essential

This creates some resources so that terraform state could be stored remotely:

- S3 bucket to store terraform state (us-west-2)
- Backup S3 bucket in separate region (us-east-1)
- DynamoDB Table for state locking
- Bucket policy, IAM role, and IAM policy for replication.
