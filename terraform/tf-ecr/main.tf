resource "aws_ecrpublic_repository" "ecr" {

  count = length(var.ecr_names)

  repository_name = var.ecr_names[count.index]
  force_destroy = true

#   catalog_data {
#     about_text        = "About Text"
#     architectures     = ["ARM"]
#     description       = "Description"
#     logo_image_blob   = filebase64(image.png)
#     operating_systems = ["Linux"]
#     usage_text        = "Usage Text"
#   }

  tags = {
    env = "production"
  }
}