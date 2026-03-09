cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.case_dir)
        entryname: case
        writable: true

baseCommand: [surfaceFeatureExtract]

inputs:
  case_dir:
    type: Directory
    inputBinding:
      prefix: -case 
      position: 1

outputs:
  case_dir_out:
    type: Directory
    outputBinding:
      glob: case


stdout: log.surfaceFeatures
stderr: log.surfaceFeatures