{
  buildPythonPackage,
  fetchPypi,

  attrs,
}:
buildPythonPackage rec {
  pname = "markdown-it-py";
  version = "0.6.2";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256:18zc16bqgarq3pbfhav2if5gzdrf0xs3vxdjiaycp4h7psazkff3";
  };

  doCheck = false;

  propagatedBuildInputs = [
    attrs
  ];
}
