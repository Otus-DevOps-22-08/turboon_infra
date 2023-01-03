terraform {
  backend "s3" {
    endpoint            = "storage.yandexcloud.net"
    bucket              = "turboon-tf-state"
    region              = "ru-central1"
    key                 = "otus-tf-hw2/tf.state"
    access_key          = "YCAJE9ho2yQpdXwBeQRkCO8jf"
    secret_key          = "YCOlh2vWie3mB8hn2VCkhd1U6keY5EltJeMF0sXu"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
