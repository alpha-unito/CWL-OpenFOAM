cwlVersion: v1.2
class: CommandLineTool

requirements:
 InitialWorkDirRequirement:
   listing:
     - entry: $(inputs.case_dir)
       entryname: case
       writable: true

baseCommand: "true"

inputs:
  case_dir:
    type: Directory

outputs:
  case_dir_out:
    type: Directory
    outputBinding:
      glob: case

