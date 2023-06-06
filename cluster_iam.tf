resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-cluster"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {"Service": "ec2.amazonaws.com"},
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF

}

resource "aws_iam_instance_profile" "cluster" {
  name       = "${var.cluster_name}-cluster"
  role       = aws_iam_role.cluster.name
  depends_on = [aws_iam_role_policy.cluster_s3]
}

resource "aws_iam_role_policy" "cluster_s3" {
  name = "${var.cluster_name}-cluster-s3"
  role = aws_iam_role.cluster.id

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
     {
       "Effect": "Allow",
       "Action": [
         "s3:ListBucket",
         "s3:ListBucketVersions",
         "s3:ListBucketMultipartUploads",
         "s3:AbortMultipartUpload"
      ],
       "Resource": ["arn:aws:s3:::${aws_s3_bucket.storage.bucket}"]
     },
     {
       "Effect": "Allow",
       "Action": [
         "s3:PutObject",
         "s3:GetObject",
         "s3:GetObjectVersion"
       ],
       "Resource": ["arn:aws:s3:::${aws_s3_bucket.storage.bucket}/*"]
     }
   ]
 }

EOF

}

resource "aws_iam_role_policy" "cluster_dynamo" {
  name = "${var.cluster_name}-cluster-dynamo"
  role = aws_iam_role.cluster.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllActionsOnTeleportDB",
            "Effect": "Allow",
            "Action": "dynamodb:*",
            "Resource": "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.teleport.name}"
        },
        {
            "Sid": "AllActionsOnTeleportEventsDB",
            "Effect": "Allow",
            "Action": "dynamodb:*",
            "Resource": "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.teleport_events.name}"
        },
        {
            "Sid": "AllActionsOnTeleportEventsIndexDB",
            "Effect": "Allow",
            "Action": "dynamodb:*",
            "Resource": "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.teleport_events.name}/index/*"
        },
        {
            "Sid": "AllActionsOnTeleportStreamsDB",
            "Effect": "Allow",
            "Action": "dynamodb:*",
            "Resource": "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.teleport.name}/stream/*"
        },
        {
            "Sid": "AllActionsOnLocks",
            "Effect": "Allow",
            "Action": "dynamodb:*",
            "Resource": "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.teleport_locks.name}"
        }
    ]
}
EOF

}

resource "aws_iam_role_policy" "cluster_route53" {
  name = "${var.cluster_name}-cluster-route53"
  role = aws_iam_role.cluster.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "certbot-dns-route53 policy",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZones",
                "route53:GetChange"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect" : "Allow",
            "Action" : [
                "route53:ChangeResourceRecordSets"
            ],
            "Resource" : [
                "arn:aws:route53:::hostedzone/${data.aws_route53_zone.cluster.zone_id}"
            ]
        }
    ]
}
EOF

}
