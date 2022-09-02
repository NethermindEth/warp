pragma solidity ^0.8.14;

interface fooInterface  {
    function foo(bytes calldata x) external;
    function foo1(uint8[] calldata x) external;
}


interface barInterface is fooInterface {}

contract testContract {
    function bar(
        address pool,
        bytes calldata x,
        uint8[] calldata y
    )
        external
    {
        fooInterface(pool).foo(x);
        barInterface(pool).foo(x);
    }

}