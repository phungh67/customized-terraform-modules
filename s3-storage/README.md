# Argument Reference

The following arguments are supported:

- `bucket-prefix` - (Must have) For better naming convention. The final bucket name will be formatted as `<prefix>-<environment>-bucket`. Default is `""`.

- `optional_region` - (Optional) Region to provision this bucket. Default is `null`.

- `service_type` - (Optional) Indicate the purpose of this bucket (e.g., storage, static host). Default is `"storage"`.

- `cors_specified` - (Optional) Specify if the user wants to provide pre-configured CORS rules. Set to `1` to enable. Default is `0`.

- `policy_specified` - (Optional) Specify if the user wants to provide a pre-configured bucket policy. Default is `0`.

- `lifecycle_specified` - (Optional) Specify if the user wants to provide a pre-configured lifecycle policy. Default is `0`.

- `origin_string` - (Optional) Domain that is allowed to call S3. Used to set allowed_origins when cors_specified is active. Default is `""` (which falls back to the wildcard `*`).

# Attribute Reference

In addition to all arguments above, the following attributes are exported:

- `s3_bucket_id` - The name (ID) of the bucket.

- `s3_bucket_arn` - The ARN of the bucket.

## 👨‍💻 Author

**Huy Hoang Phung**
* *Cloud & DevOps Engineer*
* *M.Sc. Candidate in Computer Systems and Cybersecurity @ Chalmers*
* [GitHub Profile](https://github.com/phungh67)