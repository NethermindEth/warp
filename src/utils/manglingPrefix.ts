// TODO:
// Check there are no issues path mangling, although it seems there won't be any
// External contract handler should be passed here?
// StorageAllocator adds a 'wm_' prefix to some vars
// Update script name
// ExternalArgModifier/MemoryRefInputModifier has a _mem suffix
// If Functionalizer has a '_part' in between
// The one with static index access to memory, clash is bound to happen

// Used in TupleFiller in TupleFixes
export const TUPLE_FILLER_PREFIX = '__warp_tf';

// Used in SourceUnitSplitter
export const FREE_FILE = '__WARP_FREE__';
export const CONTRACT_PREFIX = '__WARP_CONTRACT__';

// Used in IdentifierManglerPass
export const MANGLED_INTERNAL_USER_FUNCTION = '__warp_usrfn';
export const MANGLED_TYPE_NAME = '__warp_usrT';
export const MANGLED_LOCAL_VAR = '__warp_usrid';

// Used in ModifierHandler in FunctionModifierHandler
export const MANGLED_PARAMETER = '__warp_parameter';
export const MANGLED_RETURN_PARAMETER = '__warp_ret_paramter';

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
