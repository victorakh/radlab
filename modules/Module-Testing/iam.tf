/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#########################################################################
# IAM - Trusted User/Group
#########################################################################

resource "google_project_iam_member" "role_notebooks_admin" {
  for_each = toset(concat(formatlist("user:%s", var.trusted_users), formatlist("group:%s", var.trusted_groups)))
  project  = local.project.project_id
  member   = each.value
  role     = "roles/notebooks.admin"
}

resource "google_project_iam_member" "role_viewer" {
  for_each = toset(concat(formatlist("user:%s", var.trusted_users), formatlist("group:%s", var.trusted_groups)))
  project  = local.project.project_id
  member   = each.value
  role     = "roles/viewer"
}


/**

# Test script starts from here
# create custom role vm_start_stop_custom_role
resource "google_project_iam_custom_role" "start_stop_role" {
  role_id     = "vm_start_stop_custom_role"
  project     = local.project.project_id
  title       = "vm_start_stop_custom_role"
  description = "vm_start_stop_custom_role"
  permissions = [
    "compute.instances.start",
    "compute.instances.stop"
  ]
}

output "start_stop_role_id" {
  value = google_project_iam_custom_role.start_stop_role.role_id
}

resource "google_project_iam_member" "role_custom_vm_start_stop" {
  for_each = toset(concat(formatlist("user:%s", var.trusted_users), formatlist("group:%s", var.trusted_groups)))
  project  = local.project.project_id
  member   = each.value
  role     = start_stop_role_id
}






# Add role_compute_starter and role_compute_starter_stopper
resource "google_project_iam_member" "role_compute_starter" {
  for_each = toset(concat(formatlist("user:%s", var.trusted_users), formatlist("group:%s", var.trusted_groups)))
  project  = local.project.project_id
  member   = each.value
  role    = "roles/compute.instanceAdmin"
}


resource "google_project_iam_custom_role" "viewer_with_vm_permissions_role" {
  role_id     = "viewer_with_vm_permissions_role"
  title       = "Viewer with VM Permissions Role"
  description = "Custom role for viewing and managing VM start and stop operations"
  permissions = [
    "roles/viewer",
    "compute.instances.start",
    "compute.instances.stop",
  ]
}

resource "google_project_iam_member" "viewer_with_vm_permissions" {
  for_each = toset(concat(formatlist("user:%s", var.trusted_users), formatlist("group:%s", var.trusted_groups)))
  project  = local.project.project_id
  member   = each.value
  role     = google_project_iam_custom_role.viewer_with_vm_permissions_role.role_id
}

*/

#########################################################################
# IAM - Owner User/Group
#########################################################################

/*
  Allows the user to add ownership for other users or groups.  Be very careful when granting these access rights,
  as they have gain full ownership of the projects and can potentially break the entire module.

  More information: https://cloud.google.com/iam/docs/understanding-roles#basic
*/

resource "google_project_iam_member" "role_owner" {
  for_each = toset(concat(formatlist("user:%s", var.owner_users), formatlist("group:%s", var.owner_groups)))
  member   = each.value
  project  = local.project.project_id
  role     = "roles/owner"
}
