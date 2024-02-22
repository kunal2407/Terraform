provider "github" {
  token = "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"
}
resource "github_repository" "git_repo" {
  name        = "git-terraform"
  description = "created a repository from terraform"
  visibility  = "public"
  auto_init   = true
}
resource "github_branch" "branch" {
  repository    = github_repository.git_repo.name
  branch        = "master"
  source_branch = "main"
}

resource "github_repository_file" "new" {
  repository     = github_repository.git_repo.name
  branch         = "main"
  file           = "git-terraform.txt"
  content        = "Hello this is Kunal"
  commit_message = "git.tf file from terraform"
}