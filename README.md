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

    conda build --python=2.7 -c defaults -c conda-forge  meta.yaml

Notes:

* Only python2 packages are currently supported. (Python 3 might work,
  but hasn't been tested.)
* The conda-forge link is needed to import nlohmann_json, which is used
  in building smtk.
* You do not need to run conda-build from a conda environment.
* On linux systems, the resulting package is a 45MB bzip2 file with a
  name such as smtk-3.0.0conda-py27h6bb024c_0.tar.bz2.
