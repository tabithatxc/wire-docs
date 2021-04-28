{
  buildPythonApplication,
  buildPythonPackage,
  fetchPypi,

  markdown-it-py,
  docutils,
  jinja2,
  mdit-py-plugins,
  pyyaml,
  sphinx,
}:
buildPythonPackage rec {
  pname = "myst-parser";
  version = "0.13.7";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256:11bwgixdx4ny0ficnkf3qkkyixsrrry8xpi8wli0vxqr7vj9kg74";
  };

  doCheck = false;

  propagatedBuildInputs = [
    docutils
    jinja2
    markdown-it-py
    mdit-py-plugins
    pyyaml
    sphinx
  ];
}
