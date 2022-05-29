contract WARP {
    struct valueStruct {
        uint8 a;
        uint256 b;
        uint8[4] c;
    }

    struct elemStruct {
        uint8 a;
    }

    struct dynArrayStruct {
        uint8[] a;
        elemStruct[] b;
    }

    struct mapStruct {
       mapping (uint8 => uint8) a; 
    }

    valueStruct val = valueStruct(1, 2, [3, 4, 5, 6]);

    dynArrayStruct dyn;

    mapStruct map;

    function deleteValueStruct() public returns (valueStruct memory) {
        delete val;
        return val;
    }

    function setDynArrayStructVal(uint8 x) public {
        dyn.a.push(x);
        dyn.b.push(elemStruct(x));
    }

    function deleteDynArrayStruct() public {
        delete dyn;
    }
    
    function getDynArrayStruct(uint index) public view returns (uint8, elemStruct memory) {
        return (dyn.a[index], dyn.b[index]);
    }

    
    function setMapStructVal(uint8 key, uint8 value) public {
        map.a[key] = value;
    }

    function deleteMapStruct() public  {
        delete map;
    }

    function getMapStruct(uint8 key) public view returns (uint8) {
        return map.a[key];
    }
}

