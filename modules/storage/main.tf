resource "aws_s3_bucket_public_access_block" "fio_doc" {
  bucket = var.bucket_name

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "fio_doc_policy" {
  bucket = var.bucket_name
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${var.bucket_name}/*"
      }
    ]
  })

  # Ensure public access block settings are configured first
  depends_on = [aws_s3_bucket_public_access_block.fio_doc]
}

resource "aws_s3_bucket_versioning" "fio_doc" {
  bucket = var.bucket_name
  
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Disabled"
  }
}