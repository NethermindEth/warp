contract WARP{

    event allStringEvent(string, string);
    event allStringMiscEvent(string indexed, string);
    event allUintMiscEvent(uint , uint indexed);
    event allIndexedEvent(uint indexed, uint indexed);
    event allUintMiscEventAnonymous(uint, uint indexed) anonymous;

    function allString(string memory a, string memory b) public {
        emit allStringEvent(a, b);
    }

    function allStringMisc(string memory a, string memory b) public {
        emit allStringMiscEvent(a, b);
    }

    function allUint(uint a, uint b) public {
        emit allUintMiscEvent(a, b);
    }

    function allIndexed(uint a, uint b) public {
        emit allIndexedEvent(a, b);
    }

    function allEventsAtOnce() public {
        emit allStringEvent("a", "b");
        emit allStringMiscEvent("a", "b");
        emit allUintMiscEvent(1, 2);
        emit allIndexedEvent(1, 2);
        emit allUintMiscEventAnonymous(1, 2);
    }
}
