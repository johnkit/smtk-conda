# smtk-conda
Conda recipe for smtk

This repository stores the Conda recipe for building SMTK as a conda
package. The smtk-conda package contains these modules:

    smtk.attribute
    smtk.common
    smtk.io
    smtk.mesh
    smtk.model
    smtk.operation
    smtk.resource
    smtk.session.mesh
    smtk.session.polygon
    smtk.simulation
    smtk.view

To create the package, you must have conda and conda-build installed on
the build machine. Run this command from a terminal:

    DATECODE="" conda build --python=2.7 -c defaults -c conda-forge  meta.yaml

Note that DATECODE *must* be set as an environment variable. The
preferred format is yymmdd, but you can use any string for testing.

## If the build fails due to a "smudge error" when cloning smtk

This occurs on some machines, and is due to some unknown issue with one
particular git-lfs file (Basic2DFluid.sbt). Because the lfs files are
not required to build smtk-conda, we can work around it. To disable
git-lfs, we have added folder xdg_config_home, which contains a git
config file. To build smtk-conda without pulling git-lfs file, add this
to the command line:

    XDG_CONFIG_HOME=${path-to-smtk-conda}/xdg_config_home  DATECODE= ...

Not very elegant, but gets the job done for now.


Other notes:

* Packages have been build and tested for python versions 2.7 and 3.6 on
  on linux (ubuntu) and macOS.
* The conda-forge link is needed to import nlohmann_json, which is used
  in building smtk.
* You do not need to run conda-build from a conda environment.
* On linux systems, the resulting package is a 45MB bzip2 file with a
  name such as smtk-3.0.0conda-py27h6bb024c_0.tar.bz2.
