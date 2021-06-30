credentials ++= {
  List("credentials", "nexus-credentials", "github-credentials")
    .map(Path.userHome / ".sbt" / _)
    .filter(f => f.exists && !f.isDirectory)
    .map(Credentials(_))
}
