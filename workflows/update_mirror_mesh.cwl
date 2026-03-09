cwlVersion: v1.2
class: Workflow 
requirements:
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}
inputs:
  size: string
  index: int
  case_dir: Directory
  entry: 
    type:
      type: record 
      fields:
        key: string 
        value: string
outputs:
  case_dir_out:
    type: Directory
    outputSource: mirror_mesh/case_dir_out
steps:
  set_mirror_dict:
    run: ../steps/foamDictionary.cwl
    in:
      size: size
      arch: index
      case_dir: case_dir
      entry: entry # e.g. key: "pointAndNormalDict.basePoint" value: "( 0 4 0 )" 
      filename: 
        default: "system/mirrorMeshDict"
    out: [case_dir_out]
  mirror_mesh:
    run: ../steps/mirrorMesh.cwl
    in:
      size: size
      arch: index
      case_dir: set_mirror_dict/case_dir_out
      overwrite:
        default: true
    out: [case_dir_out]