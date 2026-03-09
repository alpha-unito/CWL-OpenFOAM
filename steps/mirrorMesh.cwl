cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.case_dir)
        entryname: case
        writable: true

baseCommand: [mirrorMesh]

inputs:

  arch: int?
  size: string?

  case_dir:
    type: Directory
    inputBinding: 
      prefix: -case
      position: 1

  overwrite:
    type: boolean
    default: true
    inputBinding:
      prefix: -overwrite
      position: 2



outputs:
  case_dir_out:
    type: Directory
    outputBinding:
      glob: case

stdout: log.mirrorMesh
stderr: log.mirrorMesh
