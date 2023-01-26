resource "docker_image" "iac_lab_app" {
  name = "iac_lab_app"
  build {
    path = "${path.cwd}/sample"
    tag  = ["iac_lab_app:latest"]
    build_arg = {
      platform : "linux/amd64"
    }
  }
}
