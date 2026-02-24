resource "github_team" "coder" {
  name    = "Coder"
  privacy = "closed"
}

resource "github_team_repository" "coder_api_router_skeleton" {
  team_id    = github_team.coder.id
  repository = "api-router-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_api_skeleton" {
  team_id    = github_team.coder.id
  repository = "api-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_apitte_skeleton" {
  team_id    = github_team.coder.id
  repository = "apitte-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_console_skeleton" {
  team_id    = github_team.coder.id
  repository = "console-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_datagrid_skeleton" {
  team_id    = github_team.coder.id
  repository = "datagrid-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_ddd_skeleton" {
  team_id    = github_team.coder.id
  repository = "ddd-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_doctrine_extra_skeleton" {
  team_id    = github_team.coder.id
  repository = "doctrine-extra-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_doctrine_skeleton" {
  team_id    = github_team.coder.id
  repository = "doctrine-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_embedded_skeleton" {
  team_id    = github_team.coder.id
  repository = "embedded-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_framex_skeleton" {
  team_id    = github_team.coder.id
  repository = "framex-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_fx_skeleton" {
  team_id    = github_team.coder.id
  repository = "fx-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_gui_skeleton" {
  team_id    = github_team.coder.id
  repository = "gui-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_mcp_skeleton" {
  team_id    = github_team.coder.id
  repository = "mcp-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_messenger_skeleton" {
  team_id    = github_team.coder.id
  repository = "messenger-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_micro_skeleton" {
  team_id    = github_team.coder.id
  repository = "micro-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_nella_skeleton" {
  team_id    = github_team.coder.id
  repository = "nella-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_payments_skeleton" {
  team_id    = github_team.coder.id
  repository = "payments-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_sentry_skeleton" {
  team_id    = github_team.coder.id
  repository = "sentry-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_starter_skeleton" {
  team_id    = github_team.coder.id
  repository = "starter-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_strapi_v3_skeleton" {
  team_id    = github_team.coder.id
  repository = "strapi-v3-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_strapi_v4_skeleton" {
  team_id    = github_team.coder.id
  repository = "strapi-v4-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_tester_skeleton" {
  team_id    = github_team.coder.id
  repository = "tester-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_ui_skeleton" {
  team_id    = github_team.coder.id
  repository = "ui-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_vite_skeleton" {
  team_id    = github_team.coder.id
  repository = "vite-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_webapp_skeleton" {
  team_id    = github_team.coder.id
  repository = "webapp-skeleton"
  permission = "push"
}

resource "github_team_repository" "coder_webpack_skeleton" {
  team_id    = github_team.coder.id
  repository = "webpack-skeleton"
  permission = "push"
}
