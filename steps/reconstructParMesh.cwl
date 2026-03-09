
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.case_dir)
        entryname: case
        writable: true

baseCommand: [reconstructParMesh]


inputs:
  case_dir:
    type: Directory
    inputBinding: 
      prefix: -case
      position: 1

  is_constant:
    type: boolean
    default: true
    inputBinding:
      prefix: -constant
      position: 2



outputs:
  case_dir_out:
    type: Directory
    outputBinding:
      glob: case


stdout: log.reconstructParMesh
stderr: log.reconstructParMesh