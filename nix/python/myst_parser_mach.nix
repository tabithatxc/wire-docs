{
  buildPythonPackage,
  fetchPypi,

}:
let
  mach-nix = import (builtins.fetchGit {
    url = "https://github.com/DavHau/mach-nix/";
    ref = "refs/tags/3.2.0";
  }) {};
in
mach-nix.buildPythonPackage {
  src = builtins.fetchGit {
    url = "https://github.com/executablebooks/MyST-Parser";
    ref = "v0.13.7";
  };
}

# buildPythonPackage rec {
#   pname = "arabic_reshaper";
#   version = "2.1.1";
#   src = fetchPypi {
#     inherit pname version;
#     sha256 = "sha256-zzGPpdUdLSJPpJv2vbu0aE9r0sBot1z84OYH+JrBmdw=";
#   };
#   buildInputs = [future];
#   doCheck = false;
# }
