cwlVersion: v1.2
class: Workflow

inputs:
  case_dir:
    type: Directory

steps:

  copy_case:
    run: ../steps/copy-case.cwl
    in:
      case_dir: case_dir
    out: [case_dir_out]

  blockMesh:
    run: ../steps/blockMesh.cwl
    in:
      case_dir: copy_case/case_dir_out
    out: [case_dir_out]

  decompose:
    run: ../steps/decompose.cwl
    in:
      case_dir: blockMesh/case_dir_out
    out: [case_dir_out]

  snappy:
    run: ../steps/snappy-parallel.cwl
    in:
      case_dir: decompose/case_dir_out
      is_parallel:
        default: true
      overwrite:
        default: true
      decompseDic:
        default: system/decomposeParDict
    out: [case_dir_out]

  reconstructParMesh:
    run: ../steps/reconstructParMesh.cwl
    in:
      case_dir: snappy/case_dir_out
      is_constant:
        default: true
    out: [case_dir_out]

  reconstruct:
    run: ../steps/reconstruct.cwl
    in:
      case_dir: reconstructParMesh/case_dir_out
      is_latestTime:
        default: false
      is_constant:
        default: true
    out: [case_dir_out]

  set_mirror_dict:
    run: ../steps/foamDictionary.cwl
    in:
      case_dir: reconstruct/case_dir_out
      entry: 
        valueFrom: "${return {'key': 'pointAndNormalDict.basePoint', 'value': '( 0 4 0 )'}}" 
      filename: 
        default: "system/mirrorMeshDict"
    out: [case_dir_out]

  mirror_mesh:
    run: ../steps/mirrorMesh.cwl
    in:
      case_dir: set_mirror_dict/case_dir_out
      overwrite:
        default: true
    out: [case_dir_out]

  cleanup_mesh:
    run: ../steps/cleanupMesh.cwl
    in:
      case_dir: mirror_mesh/case_dir_out
    out: [case_dir_out]

  decompose2:
    run: ../steps/decompose.cwl
    in:
      case_dir: cleanup_mesh/case_dir_out
    out: [case_dir_out]

  potential:
    run: ../steps/potentialFoam.cwl
    in:
      case_dir: decompose2/case_dir_out
      is_parallel:
        default: true
      writePhi:
        default: true
      decompseDic:
        default: system/decomposeParDict
    out: [case_dir_out]

  simpleFoam:
    run: ../steps/simpleFoam.cwl
    in:
      case_dir: potential/case_dir_out
      is_parallel:
        default: true
      decompseDic:
        default: system/decomposeParDict
    out: [case_dir_out]


outputs:
  case_dir_out:
    type: Directory
    outputSource: simpleFoam/case_dir_out


requirements:
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}
