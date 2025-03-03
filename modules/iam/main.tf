resource "aws_iam_group" "developers" {
  name = "${var.environment}-FiO.DeveloperOutSourcing"
}

resource "aws_iam_policy" "developer_policy" {
  name = "${var.environment}-developer-policy"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          # SSM Access
          "ssm:StartSession",
          "ssm:TerminateSession",
          "ssm:SendCommand",
          "ssm:ListCommands",
          "ssm:ListCommandInvocations",
          "ssm:TerminateSession",
          "ssm:ResumeSession",
          "ssm:GetConnectionStatus",
          "ssm:DescribeSessions",
          "ssm:GetDocument",
          
          # S3 Access
          # "s3:GetObject",
          # "s3:ListBucket",
          # "s3:PutObject",
          # "s3:GetObject",
          # "s3:ListBucket",
          # "s3:DeleteObject",
          
          # RDS Access
          "rds:DescribeDBInstances",
          "rds:DescribeDBParameters",
          "rds:DescribeDBParameterGroups",
          
          # Logging & Monitoring
          "cloudwatch:GetMetricData",
          "logs:GetLogEvents",
          "logs:DescribeLogStreams",
          "logs:FilterLogEvents",
          
          # ECR Permissions
          "ecr:DescribeRepositories",
          "ecr:CreateRepository",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:GetLifecyclePolicy",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:ListTagsForResource",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:TagResource",
        ]
        Resource = [
          "arn:aws:ec2:${var.region}:*:instance/*",
          "arn:aws:ssm:${var.region}:*:session/*",
          "arn:aws:ssm:${var.region}:*:document/AWS-RunShellScript",
          # "arn:aws:s3:::${var.bucket_name}/*",
          # "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:rds:${var.region}:*:db:*",
          "arn:aws:logs:${var.region}:*:*",
          # "arn:aws:ecr:${var.region}:*:repository/frontend-fio-app",
          # "arn:aws:ecr:${var.region}:*:repository/backend-fio-app",
          "arn:aws:ecr:${var.region}:*:repository/*", 
          "arn:aws:iam::842131655522:user/fable_roy",
          "arn:aws:ssm:${var.region}:842131655522:document/SSM-SessionManagerRunShell"
        ]
      },
      {
          Effect: "Allow",
          Action: "iam:GetAccountSummary",
          Resource: "*"
      },
      {
          Effect: "Allow",
          Action: [
              "iam:GetUser",
              "iam:ListMFADevices",
              "iam:EnableMFADevice",
              "iam:GetLoginProfile",
              "iam:ListAccessKeys",
              "iam:ListUsers",
              "iam:ListGroups",
              "iam:ListRoles",
              "iam:GetUserPolicy",
              "iam:ListGroupsForUser",
              "iam:ListAttachedUserPolicies"
          ],
          Resource: "*"
      },
      {
          Effect: "Allow",
          Action: [
              "secretsmanager:GetResourcePolicy",
              "secretsmanager:GetSecretValue",
              "secretsmanager:DescribeSecret",
              "secretsmanager:ListSecrets",
              // Add create/update permissions
               "secretsmanager:CreateSecret",
               "secretsmanager:PutSecretValue",
               "secretsmanager:UpdateSecret",
               "secretsmanager:TagResource"
          ],
          Resource: "*"
      },
      {
          Effect: "Allow",
          Action: [
              "ec2:DescribeInstances",
              "ec2:DescribeSecurityGroups", 
              "ec2:DescribeVolumes",
              "ec2:DescribeVpcs",
              "ec2:DescribeSubnets",
              "ec2:DescribeKeyPairs",
              "ec2:DescribeAvailabilityZones",
              "ec2:DescribeInstanceStatus",
              "cloudwatch:DescribeAlarms",
              "cloudwatch:GetMetricStatistics",
              "cloudwatch:ListMetrics",
              "autoscaling:DescribeAutoScalingGroups",
              "elasticloadbalancing:DescribeLoadBalancers"
          ],
          Resource: "*"
      },
      # {
      #     Effect: "Allow",
      #     Action: [
      #         "iam:CreateAccessKey",
      #         "iam:DeleteAccessKey",
      #         "iam:ListAccessKeys",
      #         "iam:UpdateAccessKey",
      #         "iam:GetAccessKeyLastUsed"
      #     ],
      #      Resource = "*"
      # }
      {
          Effect: "Allow",
          Action: "ecr:GetAuthorizationToken",
          Resource: "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetAccountPublicAccessBlock",
          "s3:GetBucketPublicAccessBlock",
          "s3:GetBucketVersioning", 
          "s3:GetBucketPolicy",
          "s3:PutBucketPolicy",
          "s3:GetBucketOwnershipControls",
          "s3:PutBucketOwnershipControls",
          "s3:ListAllMyBuckets",
          "s3:CreateBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:GetObjectAcl",
          "s3:DeleteObject",
        ]
        Resource = [
          "arn:aws:s3:::fio-doc",
          "arn:aws:s3:::fio-doc/*",
          # For account-level operations
          "arn:aws:s3:::*"
        ]
      },
      {
        Effect = "Deny"
        Action = [
          "iam:CreateAccessKey",
          "iam:UpdateAccessKey",
          "iam:DeleteAccessKey",
          "iam:CreateServiceSpecificCredential",
          "iam:UpdateServiceSpecificCredential",
          "iam:DeleteServiceSpecificCredential"
        ],
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_group_policy_attachment" "developer_policy_attach" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.developer_policy.arn
}

resource "aws_iam_user" "developer" {
  name = "${var.environment}-fable-roy"
}

resource "aws_iam_user_group_membership" "developer" {
  user   = aws_iam_user.developer.name
  groups = [aws_iam_group.developers.name]
}

resource "aws_iam_user_login_profile" "developer" {
  user = aws_iam_user.developer.name
  password_reset_required = true
  password_length = 12
}