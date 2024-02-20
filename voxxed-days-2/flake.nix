{
  description = "Voxxed Days 2 Virtual Environment";

  inputs.devshell.url = "github:numtide/devshell";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, flake-utils, devshell, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShells.default =
        let
          pkgs = import nixpkgs {
            inherit system;

            overlays = [ devshell.overlays.default ];
          };

          mavenVersion = "3.9.6";

          projectMaven = pkgs.maven.overrideAttrs (oldAttrs: {
            version = mavenVersion;
            src = pkgs.fetchurl {
              # https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
              # mirror://apache/maven/maven-3/${mavenVersion}/binaries/apache-maven-${mavenVersion}-bin.tar.gz
              url = "mirror://apache/maven/maven-3/${mavenVersion}/binaries/apache-maven-${mavenVersion}-bin.tar.gz";
              hash = "sha256-bu3SyuNibWrTpcnuMkvSZYU9ZCl/B/AzQwdVvQ4MOks=";
            };
          });

          projectJDK = pkgs.jdk8;
        in
        pkgs.devshell.mkShell {
          imports = [ (pkgs.devshell.importTOML ./devshell.toml) ];
          name = "Voxxed Days 2";
          packages = [ 
            projectMaven 
            projectJDK
          ];
          env = [
            {
              name = "JAVA_HOME";
              eval = "${projectJDK}";
            }
            {
              name = "MAVEN_HOME";
              eval = "${projectMaven}";
            } 
          ];
        };
    });
}