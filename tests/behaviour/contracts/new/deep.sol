contract BaseC {}

contract BaseD {}

contract BaseE {}

contract MiddleA {
    constructor() {
        BaseC bc = new BaseC();
        BaseD bd = new BaseD();
    }
}

contract MiddleB {
    constructor() {
        BaseC bc = new BaseC();
        BaseE be = new BaseE();
    }
}

contract WARP {
    function createContracts() public {
        MiddleA a = new MiddleA();
        MiddleB b = new MiddleB();
    }
}


