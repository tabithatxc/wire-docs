{
  buildPythonPackage,
  fetchPypi,

  markdown-it-py
}:
buildPythonPackage rec {
  pname = "mdit-py-plugins";
  version = "0.2.1";
  src = fetchPypi {
    inherit pname version;
    # sha256 = "sha256:042p2a17xmsyd87w916ydf151fsja0gcdmnmrdjq0vh5xai7qihy"; # 0.2.6
    sha256 = "sha256:19hbmhn9k3msbj6lbnc2ahhfx989rng36ha3l6jkbmz07y84rfnd";
  };

  doCheck = false;

  propagatedBuildInputs = [
    markdown-it-py
  ];
}
