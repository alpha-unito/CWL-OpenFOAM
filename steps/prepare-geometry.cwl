cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.case_dir)
        entryname: case
        writable: true

baseCommand: [bash, -c]

inputs:
  case_dir:
    type: Directory

arguments:
  - |
    set -e

    mkdir -p case/constant/triSurface


    mkdir -p case/constant/triSurface &&
    cp $FOAM_TUTORIALS/resources/geometry/motorBike.obj.gz \
        case/constant/triSurface/



outputs:
  case_dir_out:
    type: Directory
    outputBinding:
      glob: case

stdout: log.prepareGeometry
stderr: log.prepareGeometry