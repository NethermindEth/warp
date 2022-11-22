
import "./contract.sol";

contract itr{
    address public cairoContractAddress;
    constructor(address contractAddress) {
        cairoContractAddress = contractAddress;
    }
    function add(uint256 a, uint256 b) public returns (uint256) {
        Forwarder_contract cairoContract = Forwarder_contract(cairoContractAddress);
        return cairoContract.add_5f39068a(a, b);
    }
    function arrayAdd(uint256[] memory a, uint256 b) public returns (uint256[] memory) {
        Forwarder_contract cairoContract = Forwarder_contract(cairoContractAddress);
        return cairoContract.arrayAdd_21a2debb(a, b);
    }
    function staticArrayAdd(uint256[3] memory a, uint256[3] memory b) public returns (uint256[3] memory) {
        Forwarder_contract cairoContract = Forwarder_contract(cairoContractAddress);
        return cairoContract.staticArrayAdd_6fd891c7(a, b);
    }
    function structAdd(S_a9463b19_uint256 memory s, uint256 b) public returns (S_a9463b19_uint256 memory) {
        Forwarder_contract cairoContract = Forwarder_contract(cairoContractAddress);
        return cairoContract.structAdd_f626e22b(s, b);
    }
    function structArrayAdd(S_a9463b19_uint256[] memory s, uint256 b) public returns (S_a9463b19_uint256[] memory) {
        Forwarder_contract cairoContract = Forwarder_contract(cairoContractAddress);
        return cairoContract.structArrayAdd_a9fa80fe(s, b);
    }
    function staticStructArrayAdd(S_a9463b19_uint256[3] memory s, uint256[3] memory b) public returns (S_a9463b19_uint256[3] memory) {
        Forwarder_contract cairoContract = Forwarder_contract(cairoContractAddress);
        return cairoContract.staticStructArrayAdd_a7c87eb1(s, b);
    }
    function array2Dadd(uint256[3][] memory a, uint256[3][] memory b) public returns (uint256[3][] memory) {
        Forwarder_contract cairoContract = Forwarder_contract(cairoContractAddress);
        return cairoContract.array2Dadd_14dd5669(a, b);
    }
    function array2DaddStatic(uint256[3][3] memory a, uint256[3][3] memory b) public returns (uint256[3][3] memory) {
        Forwarder_contract cairoContract = Forwarder_contract(cairoContractAddress);
        return cairoContract.array2DaddStatic_9fb362da(a, b);
    }
}