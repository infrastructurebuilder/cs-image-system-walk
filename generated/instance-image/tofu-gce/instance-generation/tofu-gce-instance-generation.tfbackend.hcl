# Backend 's3-main' (s3) partial configuration for workspace tofu-gce
bucket = "csis-walk-tfstate-514190660293"
key = "statefiles/cs-image-system-walk/tofu_gce.tfstate"
region = "us-east-2"
encrypt = true
use_lockfile = true
profile = "noaa"