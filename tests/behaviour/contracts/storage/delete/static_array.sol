contract WARP {
    uint8[][3] small;
    uint8[][10] big;

    function setSmall(uint8 index, uint8 value) public  {
        small[index].push(value);
    }

    function setBig(uint8 index, uint8 value) public {
        big[index].push(value);
    }

    function getSmall(uint8 index1, uint8 index2 ) public returns (uint8) {
        return small[index1][index2];
    }

    function getBig(uint8 index1, uint8 index2 ) public returns (uint8) {
        return big[index1][index2];
    }

    function deleteSmall() public {
        delete small;
    }

    function deleteBig() public {
        delete big;
    }
}
