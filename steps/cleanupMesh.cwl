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
  size: string?
  case_dir:
    type: Directory

arguments:
  - |
    set -e


    cd case &&
    rm -f log.* && 
    rm -fr logs FIGS processor* 0 &&
    cp -r 0.orig 0


outputs:
  case_dir_out:
    type: Directory
    outputBinding:
      glob: case


stdout: log.cleanupMesh
stderr: log.cleanupMesh



