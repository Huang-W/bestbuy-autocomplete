# resource "aws_s3_bucket" "bestbuy-product-data" {
#   bucket = "bestbuy-product-data"
#   acl    = "private"
#
#   tags = merge(local.common_tags, {
#     Name = "bestbuy_product_data"
#     Type = "storage"
#   })
# }
#
# output "s3_bucket_product_data_arn" {
#   value = aws_s3_bucket.bestbuy_product_data.arn
# }
