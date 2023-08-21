resource "aws_dlm_lifecycle_policy" "daily_snapshot" {
  description        = "Daily snapshot"
  execution_role_arn = var.dlm_lifecycle_role_arn
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    schedule {
      name = "daily snapshots"

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times         = ["00:00"] # UTC
      }

      retain_rule {
        count = 2
      }

      tags_to_add = {
        SnapshotCreator = "DLM"
      }

      copy_tags = true
    }

    target_tags = {
      DailySnapshot = "true"
    }
  }
}
