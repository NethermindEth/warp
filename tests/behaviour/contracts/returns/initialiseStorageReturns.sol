contract WARP {
	uint[] arr1;
	uint[][] arr2;
	function getStorageArrays() internal returns (uint[] storage ptr1, uint[][] storage ptr2) {
		ptr1 = arr1;
		ptr2 = arr2;
	}
	function getDefaultArrayLengths() public returns (uint, uint) {
		(uint[] storage a, uint[][] storage b) = getStorageArrays();
		return (a.length, b.length);
	}
}
