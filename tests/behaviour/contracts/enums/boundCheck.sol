contract WARP {
    enum ActionChoices {GoLeft, GoRight, GoStraight}

    constructor() {}

    function checkInt256(int256 x) public {
        choice = ActionChoices(x);

    }

    function checkInt8(uint8 x) public {
        choice = ActionChoices(x);
    }

    ActionChoices choice;
}
