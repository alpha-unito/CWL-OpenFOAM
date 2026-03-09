
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.case_dir)
        entryname: case
        writable: true

baseCommand: [reconstructPar]


inputs:
  case_dir:
    type: Directory
    inputBinding: 
      prefix: -case
      position: 1

  is_latestTime:
    type: boolean
    default: true
    inputBinding:
      prefix: -latestTime
      position: 2

  is_constant:
    type: boolean
    default: false
    inputBinding:
      prefix: -constant
      position: 3



outputs:
  case_dir_out:
    type: Directory
    outputBinding:
      glob: case


stdout: log.reconstructPar
stderr: log.reconstructPar