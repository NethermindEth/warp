/* 
  Stores all prefix/infix/suffix of solidity variables generated/modified by
  the transpiler.
  Every new generation should be added accordingly. 
*/

// Used in TupleFiller in TupleFixes
export const TUPLE_FILLER_PREFIX = '__warp_tf';

// Used in librariesConverter
export const LIBRARY_CONTRACT_PREFIX = 'library__';

// Used in SourceUnitSplitter
export const FREE_FILE_SUFFIX = '__WC_FREE';
export const CONTRACT_INFIX = '__WC__';

// Used in IdentifierManglerPass and CairoStubProcessor
export const MANGLED_INTERNAL_USER_FUNCTION = '__warp_usrfn_';
export const MANGLED_TYPE_NAME = '__warp_usrTp_';
export const MANGLED_LOCAL_VAR = '__warp_usrid_';

// Used in StaticArrayIndexer
export const CALLDATA_TO_MEMORY_PREFIX = 'cd_to_wm_';

// Used in StorageAllocator
export const CONSTANT_STRING_TO_MEMORY_PREFIX = 'memory_string';

// Used in ModifierHandler in FunctionModifierHandler
export const MANGLED_PARAMETER = '__warp_parameter_';
export const MANGLED_RETURN_PARAMETER = '__warp_ret_parameter_';
export const MODIFIER_PREFIX = '__warp_modifier_';
export const ORIGINAL_FUNCTION_PREFIX = '__warp_original_';

// Used in ExternalArgModifier in MemoryRefInputModifier
export const CALLDATA_TO_MEMORY_FUNCTION_PARAMETER_PREFIX = 'cd_to_wm_param_';

// Used in IfFunctionaliser
export const IF_FUNCTIONALISER_INFIX = '_if_part';

// Used in PublicFunctionSplitter in ExternalFunctionCreator
export const INTERNAL_FUNCTION_SUFFIX = '_internal';

// Used in LoopFunctionaliser
//  - Used in ReturnToBreak
export const RETURN_FLAG_PREFIX = '__warp_rf';
export const RETURN_VALUE_PREFIX = '__warp_rv';
//  - Used in utils
export const WHILE_PREFIX = '__warp_while';

// Used in TupleAssignmentSplitter
export const TUPLE_VALUE_PREFIX = '__warp_tv_';

// Used in  VariableDeclarationExpressionSplitter
export const SPLIT_VARIABLE_PREFIX = '__warp_td_';

// Used in Expression Splitter
export const SPLIT_EXPRESSION_PREFIX = '__warp_se_';

// Used in Pre Expression Splitter
export const PRE_SPLIT_EXPRESSION_PREFIX = '__warp_pse_';
export const CONDITIONAL_FUNCTION_PREFIX = '__warp_conditional_';
export const CONDITIONAL_RETURN_VARIABLE = '__warp_rc_';

// Used in UnloadingAssignment
export const COMPOUND_ASSIGNMENT_SUBEXPRESSION_PREFIX = '__warp_cs_';

// Used in StorageAllocator and InheritanceInliner in ConstructorInheritance
export const INIT_FUNCTION_PREFIX = '__warp_init_';
