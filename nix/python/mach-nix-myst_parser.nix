{ pkgs, python, ... }:
with builtins;
with pkgs.lib;
let
  pypi_fetcher_src = builtins.fetchTarball {
    name = "nix-pypi-fetcher";
    url = "https://github.com/DavHau/nix-pypi-fetcher/tarball/e105186d0101ead100a64e86b1cd62abd1482e62";
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    sha256 = "0nyil3npbqhwgqmxp65s3zn0hgisx14sjyv70ibbbdimfzwvy5qv";
  };
  pypiFetcher = import pypi_fetcher_src { inherit pkgs; };
  fetchPypi = pypiFetcher.fetchPypi;
  fetchPypiWheel = pypiFetcher.fetchPypiWheel;
  is_py_module = pkg:
    isAttrs pkg && hasAttr "pythonModule" pkg;
  normalizeName = name: (replaceStrings ["_"] ["-"] (toLower name));
  replace_deps = oldAttrs: inputs_type: self:
    map (pypkg:
      let
        pname = normalizeName (get_pname pypkg);
      in
        if self ? "${pname}" && pypkg != self."${pname}" then
          trace "Updated inherited nixpkgs dep ${pname} from ${pypkg.version} to ${self."${pname}".version}"
          self."${pname}"
        else
          pypkg
    ) (oldAttrs."${inputs_type}" or []);
  override = pkg:
    if hasAttr "overridePythonAttrs" pkg then
        pkg.overridePythonAttrs
    else
        pkg.overrideAttrs;
  nameMap = {
    pytorch = "torch";
  };
  get_pname = pkg:
    let
      res = tryEval (
        if pkg ? src.pname then
          pkg.src.pname
        else if pkg ? pname then
          let pname = pkg.pname; in
            if nameMap ? "${pname}" then nameMap."${pname}" else pname
          else ""
      );
    in
      toString res.value;
  get_passthru = pypi_name: nix_name:
    # if pypi_name is in nixpkgs, we must pick it, otherwise risk infinite recursion.
    let
      python_pkgs = python.pkgs;
      pname = if hasAttr "${pypi_name}" python_pkgs then pypi_name else nix_name;
    in
      if hasAttr "${pname}" python_pkgs then 
        let result = (tryEval 
          (if isNull python_pkgs."${pname}" then
            {}
          else
            python_pkgs."${pname}".passthru)); 
        in
          if result.success then result.value else {}
      else {};
  tests_on_off = enabled: pySelf: pySuper:
    let
      mod = {
        doCheck = enabled;
        doInstallCheck = enabled;
      };
    in
    {
      buildPythonPackage = args: pySuper.buildPythonPackage ( args // {
        doCheck = enabled;
        doInstallCheck = enabled;
      } );
      buildPythonApplication = args: pySuper.buildPythonPackage ( args // {
        doCheck = enabled;
        doInstallCheck = enabled;
      } );
    };
  pname_passthru_override = pySelf: pySuper: {
    fetchPypi = args: (pySuper.fetchPypi args).overrideAttrs (oa: {
      passthru = { inherit (args) pname; };
    });
  };
  mergeOverrides = with pkgs.lib; foldl composeExtensions (self: super: {});
  merge_with_overr = enabled: overr:
    mergeOverrides [(tests_on_off enabled) pname_passthru_override overr];
  select_pkgs = ps: [
    ps."myst-parser"
  ];
  overrides = manylinux1: autoPatchelfHook: merge_with_overr false (python-self: python-super: let self = {
    "alabaster" = python-self.buildPythonPackage {
      pname = "alabaster";
      version = "0.7.12";
      src = fetchPypiWheel "alabaster" "0.7.12" "alabaster-0.7.12-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "alabaster" "alabaster") // { provider = "wheel"; };
    };
    "attrs" = python-self.buildPythonPackage {
      pname = "attrs";
      version = "20.2.0";
      src = fetchPypiWheel "attrs" "20.2.0" "attrs-20.2.0-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "attrs" "attrs") // { provider = "wheel"; };
    };
    "babel" = python-self.buildPythonPackage {
      pname = "babel";
      version = "2.8.0";
      src = fetchPypiWheel "babel" "2.8.0" "Babel-2.8.0-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "babel" "Babel") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ pytz ];
    };
    "certifi" = python-self.buildPythonPackage {
      pname = "certifi";
      version = "2020.6.20";
      src = fetchPypiWheel "certifi" "2020.6.20" "certifi-2020.6.20-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "certifi" "certifi") // { provider = "wheel"; };
    };
    "chardet" = python-self.buildPythonPackage {
      pname = "chardet";
      version = "3.0.4";
      src = fetchPypiWheel "chardet" "3.0.4" "chardet-3.0.4-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "chardet" "chardet") // { provider = "wheel"; };
    };
    "docutils" = python-self.buildPythonPackage {
      pname = "docutils";
      version = "0.16";
      src = fetchPypiWheel "docutils" "0.16" "docutils-0.16-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "docutils" "docutils") // { provider = "wheel"; };
    };
    "idna" = python-self.buildPythonPackage {
      pname = "idna";
      version = "2.10";
      src = fetchPypiWheel "idna" "2.10" "idna-2.10-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "idna" "idna") // { provider = "wheel"; };
    };
    "imagesize" = python-self.buildPythonPackage {
      pname = "imagesize";
      version = "1.2.0";
      src = fetchPypiWheel "imagesize" "1.2.0" "imagesize-1.2.0-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "imagesize" "imagesize") // { provider = "wheel"; };
    };
    "jinja2" = python-self.buildPythonPackage {
      pname = "jinja2";
      version = "2.11.2";
      src = fetchPypiWheel "jinja2" "2.11.2" "Jinja2-2.11.2-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "jinja2" "jinja2") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ markupsafe ];
    };
    "markdown-it-py" = python-self.buildPythonPackage {
      pname = "markdown-it-py";
      version = "0.5.6";
      src = fetchPypiWheel "markdown-it-py" "0.5.6" "markdown_it_py-0.5.6-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "markdown-it-py" "markdown-it-py") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ attrs ];
    };
    "markupsafe" = python-self.buildPythonPackage {
      pname = "markupsafe";
      version = "1.1.1";
      src = fetchPypiWheel "markupsafe" "1.1.1" "MarkupSafe-1.1.1-cp37-cp37m-manylinux1_x86_64.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "markupsafe" "markupsafe") // { provider = "wheel"; };
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreMissingDeps = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [  ];
    };
    "myst-parser" = python-self.buildPythonPackage {
      pname = "myst-parser";
      version = "0.12.10";
      src = fetchPypiWheel "myst-parser" "0.12.10" "myst_parser-0.12.10-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "myst-parser" "myst-parser") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ docutils markdown-it-py pyyaml sphinx ];
    };
    "packaging" = python-self.buildPythonPackage {
      pname = "packaging";
      version = "20.4";
      src = fetchPypiWheel "packaging" "20.4" "packaging-20.4-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "packaging" "packaging") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ pyparsing six ];
    };
    "pygments" = python-self.buildPythonPackage {
      pname = "pygments";
      version = "2.7.1";
      src = fetchPypiWheel "pygments" "2.7.1" "Pygments-2.7.1-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "pygments" "pygments") // { provider = "wheel"; };
    };
    "pyparsing" = python-self.buildPythonPackage {
      pname = "pyparsing";
      version = "2.4.7";
      src = fetchPypiWheel "pyparsing" "2.4.7" "pyparsing-2.4.7-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "pyparsing" "pyparsing") // { provider = "wheel"; };
    };
    "pytz" = python-self.buildPythonPackage {
      pname = "pytz";
      version = "2020.1";
      src = fetchPypiWheel "pytz" "2020.1" "pytz-2020.1-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "pytz" "pytz") // { provider = "wheel"; };
    };
    "pyyaml" = override python-super.pyyaml ( oldAttrs: {
      pname = "pyyaml";
      version = "5.3.1";
      passthru = (get_passthru "pyyaml" "pyyaml") // { provider = "sdist"; };
      buildInputs = with python-self; (replace_deps oldAttrs "buildInputs" self) ++ [  ];
      propagatedBuildInputs = with python-self; (replace_deps oldAttrs "propagatedBuildInputs" self) ++ [  ];
      src = fetchPypi "pyyaml" "5.3.1";
    });
    "requests" = python-self.buildPythonPackage {
      pname = "requests";
      version = "2.24.0";
      src = fetchPypiWheel "requests" "2.24.0" "requests-2.24.0-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "requests" "requests") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ certifi chardet idna urllib3 ];
    };
    "setuptools" = override python-super.setuptools ( oldAttrs: {
      pname = "setuptools";
      version = "47.3.1";
      passthru = (get_passthru "setuptools" "setuptools") // { provider = "nixpkgs"; };
      buildInputs = with python-self; (replace_deps oldAttrs "buildInputs" self) ++ [  ];
      propagatedBuildInputs = with python-self; (replace_deps oldAttrs "propagatedBuildInputs" self) ++ [  ];
    });
    "six" = python-self.buildPythonPackage {
      pname = "six";
      version = "1.15.0";
      src = fetchPypiWheel "six" "1.15.0" "six-1.15.0-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "six" "six") // { provider = "wheel"; };
    };
    "snowballstemmer" = python-self.buildPythonPackage {
      pname = "snowballstemmer";
      version = "2.0.0";
      src = fetchPypiWheel "snowballstemmer" "2.0.0" "snowballstemmer-2.0.0-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "snowballstemmer" "snowballstemmer") // { provider = "wheel"; };
    };
    "sphinx" = python-self.buildPythonPackage {
      pname = "sphinx";
      version = "3.2.1";
      src = fetchPypiWheel "sphinx" "3.2.1" "Sphinx-3.2.1-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "sphinx" "sphinx") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ alabaster babel docutils imagesize jinja2 packaging pygments requests setuptools snowballstemmer sphinxcontrib-applehelp sphinxcontrib-devhelp sphinxcontrib-htmlhelp sphinxcontrib-jsmath sphinxcontrib-qthelp sphinxcontrib-serializinghtml ];
    };
    "sphinxcontrib-applehelp" = python-self.buildPythonPackage {
      pname = "sphinxcontrib-applehelp";
      version = "1.0.2";
      src = fetchPypiWheel "sphinxcontrib-applehelp" "1.0.2" "sphinxcontrib_applehelp-1.0.2-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "sphinxcontrib-applehelp" "sphinxcontrib-applehelp") // { provider = "wheel"; };
    };
    "sphinxcontrib-devhelp" = python-self.buildPythonPackage {
      pname = "sphinxcontrib-devhelp";
      version = "1.0.2";
      src = fetchPypiWheel "sphinxcontrib-devhelp" "1.0.2" "sphinxcontrib_devhelp-1.0.2-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "sphinxcontrib-devhelp" "sphinxcontrib-devhelp") // { provider = "wheel"; };
    };
    "sphinxcontrib-htmlhelp" = python-self.buildPythonPackage {
      pname = "sphinxcontrib-htmlhelp";
      version = "1.0.3";
      src = fetchPypiWheel "sphinxcontrib-htmlhelp" "1.0.3" "sphinxcontrib_htmlhelp-1.0.3-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "sphinxcontrib-htmlhelp" "sphinxcontrib-htmlhelp") // { provider = "wheel"; };
    };
    "sphinxcontrib-jsmath" = python-self.buildPythonPackage {
      pname = "sphinxcontrib-jsmath";
      version = "1.0.1";
      src = fetchPypiWheel "sphinxcontrib-jsmath" "1.0.1" "sphinxcontrib_jsmath-1.0.1-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "sphinxcontrib-jsmath" "sphinxcontrib-jsmath") // { provider = "wheel"; };
    };
    "sphinxcontrib-qthelp" = python-self.buildPythonPackage {
      pname = "sphinxcontrib-qthelp";
      version = "1.0.3";
      src = fetchPypiWheel "sphinxcontrib-qthelp" "1.0.3" "sphinxcontrib_qthelp-1.0.3-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "sphinxcontrib-qthelp" "sphinxcontrib-qthelp") // { provider = "wheel"; };
    };
    "sphinxcontrib-serializinghtml" = python-self.buildPythonPackage {
      pname = "sphinxcontrib-serializinghtml";
      version = "1.1.4";
      src = fetchPypiWheel "sphinxcontrib-serializinghtml" "1.1.4" "sphinxcontrib_serializinghtml-1.1.4-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "sphinxcontrib-serializinghtml" "sphinxcontrib-serializinghtml") // { provider = "wheel"; };
    };
    "urllib3" = python-self.buildPythonPackage {
      pname = "urllib3";
      version = "1.25.11";
      src = fetchPypiWheel "urllib3" "1.25.11" "urllib3-1.25.11-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "urllib3" "urllib3") // { provider = "wheel"; };
    };
  }; in self);
in
{ inherit overrides select_pkgs; }
