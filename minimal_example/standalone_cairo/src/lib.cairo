mod tokens_balances_dict_u256;

use tokens_balances_dict_u256::{U256TokensBalancesDictTrait, BalanceToWithdraw};

#[executable]
fn main() -> Array<BalanceToWithdraw> {
    let mut tokens_balances_dict = U256TokensBalancesDictTrait::create();

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

    println!("test");

    let balances_to_withdraw = tokens_balances_dict.to_array_u256(); 
    balances_to_withdraw
}