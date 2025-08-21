variable "teams" {
  description = "List of teams with their configurations"
  type = list(object({
    name      = string
    namespace = string
    admins    = list(string)
    members   = list(string)
  }))
  default = []
}