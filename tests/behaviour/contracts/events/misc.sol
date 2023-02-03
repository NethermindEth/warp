contract WARP{

    event allStringEvent(string, string);
    event allStringMiscEvent(string indexed, string);
    event allUintMiscEvent(uint , string, uint indexed);
    event allIndexedEvent(uint indexed, uint indexed);
    event allUintMiscEventAnonymous(uint, uint indexed) anonymous;

    function allString(string calldata a, string calldata b) public {
        emit allStringEvent(a, b);
    }

    function allStringMisc(string memory a, string memory b) public {
        emit allStringMiscEvent(a, b);
    }

    function allUint(uint a, uint b) public {
        emit allUintMiscEvent(a,"tihor", b);
    }

    function allIndexed(uint a, uint b) public {
        emit allIndexedEvent(a, b);
    }

    function allEventsAtOnce() public {
        emit allStringEvent("a", "abcdefghijklmnopqrstuvwxyz");
        emit allStringMiscEvent("warp", "isnotgonnamakeit");
        emit allUintMiscEvent(1,"najnar", 2);
        emit allIndexedEvent(1, 2);
        emit allUintMiscEventAnonymous(1, 2);
    }
}
