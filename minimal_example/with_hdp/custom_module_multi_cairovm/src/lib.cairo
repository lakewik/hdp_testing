mod tokens_balances_dict_u256;

#[starknet::contract]
mod starknet_get_storage {
    use hdp_cairo::{
        HDP,  
    };
    use super::tokens_balances_dict_u256::{U256TokensBalancesDictTrait};

    #[storage]
    struct Storage {}


    #[external(v0)]
    pub fn main(
        ref self: ContractState,
        hdp: HDP,
    ) -> bool {
        let mut tokens_balances_dict = U256TokensBalancesDictTrait::create();

        println!("hdpmodule_1");

        tokens_balances_dict.add(
                      0xb8d5ba6aa707d6a289cfba24678bb9a5c3e743a4123bb3849ffd9c9b4484e291,
                      20000
        );

        tokens_balances_dict.add(
                        1777,
                        3333
        );

        tokens_balances_dict.add(
                        0xb8d5ba6aa707d6a289cfba24678bb9a5c3e743a4123bb3849ffd9c9b4484e291,
                        20007
        );

        println!("hdpmodule_2");

        true
    }
}
