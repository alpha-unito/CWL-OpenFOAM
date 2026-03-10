cwlVersion: v1.2
class: Workflow

requirements:
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}
  MultipleInputFeatureRequirement: {}

$namespaces:
  cwltool: "http://commonwl.org/cwltool#"

inputs:
  case_dir:
    type: Directory
  size: 
    type: string
  entries:
    type:
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

  # Step iter
  update_mirror_mesh:
    run: update_mirror_mesh.cwl # execute the sub workflow (defined inplace)
    # inputs of the iter step
    in:
      case_dir: copy_case/case_dir_out
      size: size
      index:
        default: 0
      entry: 
        valueFrom: |
          ${
            return ((inputs.entries.length > 0) ? inputs.entries[0] : 'null');
          }
      entries: entries
    # outputs of the iter step
    out: [ case_dir_out ] 
    # loop for (int i = 0; i < entries.length; i++)
    requirements:
      cwltool:Loop:
        loopWhen: $(inputs.index < inputs.entries.length)
        loop:
          index:
            valueFrom: $(inputs.index + 1)
          case_dir: case_dir_out
          entry: 
            valueFrom: $(inputs.entries[inputs.index])
        outputMethod: last
  
  cleanup_mesh:
    run: ../steps/cleanupMesh.cwl
    in:
      size: size
      case_dir: 
        source:
          - iter/case_dir_out
          - copy_case/case_dir_out
        pickValue: first_non_null
    out: [case_dir_out]

  decompose2:
    run: ../steps/decompose.cwl
    in:
      size: size
      case_dir: cleanup_mesh/case_dir_out
    out: [case_dir_out]

  potential:
    run: ../steps/potentialFoam.cwl
    in:
      size: size
      case_dir: decompose2/case_dir_out
      is_parallel:
        default: true
      writePhi:
        default: true
      decomposeDict:
        default: system/decomposeParDict
    out: [case_dir_out]

  simpleFoam:
    run: ../steps/simpleFoam.cwl
    in:
      size: size
      case_dir: potential/case_dir_out
      is_parallel:
        default: true
      decomposeDict:
        default: system/decomposeParDict
    out: [case_dir_out]

outputs:
  case_dir_out:
    type: Directory
    outputSource: simpleFoam/case_dir_out
