provider "github" {
  token = "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"
}
resource "github_branch" "branch" {
  repository    = github_repository.repo.name
  branch        = "terraform"
  source_branch = "main"
}