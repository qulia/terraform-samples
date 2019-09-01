instance_count = 4
subnet_count = 2

s3_web_bucket = "web-bucket"

s3_web_bucket_content = [
  {
    key = "/website/index.html",
    source = "./index.html"
  },
  {
    key = "/website/Globo_logo_Vert.png",
    source = "./Globo_logo_Vert.png"
  }
]

environment_tag = "dev"