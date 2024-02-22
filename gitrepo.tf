provider "github" {
    token = "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"
}
resource "github_repository" "git_repo" {
    name        = "git-repo"
    description = "created a repository from terraform"
    visibility  = "public"
    auto_init   = true
}

  
