cwlVersion: v1.2
class: Workflow

inputs:
  case_dir:
    type: Directory
  sizes: 
    type: string[]
  entries:
    type:
      type: array
      items:
        type: array
        items:
          type: record
          fields:
            key: string 
            value: string

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
      decomposeDict:
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

  solver:
    run: motorbike-solver.cwl
    in:
      case_dir: reconstruct/case_dir_out
      size: sizes
      entries: entries
    scatter: [ entries, size ]  
    scatterMethod: dotproduct
    out: [case_dir_out]

outputs:
  case_dir_out:
    type: Directory[]
    outputSource: MeshSize/case_dir_out

requirements:
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}
  ScatterFeatureRequirement: {}