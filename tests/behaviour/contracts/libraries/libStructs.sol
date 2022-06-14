library Lib {
    struct Data { uint a; uint[] b; }
    function set(Data storage _s) public
    {
        _s.a = 7;
        while (_s.b.length < 20)
            _s.b.push();
        _s.b[19] = 8;
    }
}
contract WARP {
    mapping(string => Lib.Data) data;
    function f() public returns (uint a, uint b)
    {
        Lib.set(data["abc"]);
        a = data["abc"].a;
        b = data["abc"].b[19];
    }
}
