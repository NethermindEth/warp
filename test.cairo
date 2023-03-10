#[contract]

mod co{
    use integer::u128_to_felt;
    use warplib::warp_add;

    #[view]
    fn f(num: u128){
        let x = warp_add(num, 1);
    }
}

