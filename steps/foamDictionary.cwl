cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.case_dir)
        entryname: case
        writable: true

inputs:
  arch: int?
  size: string?

  case_dir:
    type: Directory

  entry:
    type: 
      type: record 
      fields:
        key: 
          type: string
          inputBinding:
            position: 1
            prefix: -entry
        value: 
          type: string
          inputBinding:
            position: 2
            prefix: -set
  filename:
    type: string 

baseCommand: [foamDictionary]

arguments:
- position: 3
  valueFrom: case/$(inputs.filename)


outputs:
  case_dir_out:
    type: Directory
    outputBinding:
      glob: case

stdout: log.set_mirror_dict
stderr: log.set_mirror_dict



