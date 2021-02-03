terraform {
  backend "remote" {
    organization = "Software-Architect"

    workspaces {
      name = "gh-actions-demo"
    }
  }
}
