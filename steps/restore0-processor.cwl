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
    source $WM_PROJECT_DIR/bin/tools/RunFunctions
    cd  case
    restore0Dir -processor 
    

outputs:
  case_dir_out:
    type: Directory
    outputBinding:
      glob: case

stdout: log.restore0-processor
stderr: log.restore0-processor