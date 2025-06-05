use core::{
    integer::u256,
    pedersen::pedersen,
    dict::{Felt252Dict, Felt252DictTrait},
    option::OptionTrait,
    array::ArrayTrait,
    traits::Into,
};

#[derive(Serde, Drop)]
pub struct BalanceToWithdraw {
    token_contract_address: u256,
    amount: u256
}

pub trait U256TokensBalancesDictTrait {
    fn create() -> U256TokensBalancesDict;
    fn hash_key(key: u256) -> felt252;
    fn insert(ref self: U256TokensBalancesDict, key: u256, value: u256);
    fn get(ref self: U256TokensBalancesDict, key: u256) -> Option<u256>;
    fn keys_get(ref self: U256TokensBalancesDict) -> Array<u256>;
    fn to_array_u256(ref self: U256TokensBalancesDict) -> Array<BalanceToWithdraw>;
    fn add(ref self: U256TokensBalancesDict, key: u256, value: u256);

}

#[derive(Destruct)]
pub struct U256TokensBalancesDict {
    low_dict: Felt252Dict<felt252>,
    high_dict: Felt252Dict<felt252>,
    keys: Array<u256>,
}

impl U256TokensBalancesDictImpl of U256TokensBalancesDictTrait {
    fn create() -> U256TokensBalancesDict {
        let mut low_dict: Felt252Dict<felt252> = Default::default();
        let mut high_dict: Felt252Dict<felt252> = Default::default();

        let mut keys = ArrayTrait::new();
  
        U256TokensBalancesDict { low_dict, high_dict, keys  }
    }

    fn hash_key(key: u256) -> felt252 {
        pedersen(key.low.into(), key.high.into())
    }

    fn insert(ref self: U256TokensBalancesDict, key: u256, value: u256) {
        let h = Self::hash_key(key);

        let low = self.low_dict.get(h);
        let high = self.high_dict.get(h);

        self.low_dict.insert(h, value.low.into());
        self.high_dict.insert(h, value.high.into());

        if low == 0 && high == 0 {
             self.keys.append(key);
        }
       
        println!("inserting at hash {}", h);
    }

    fn add(ref self: U256TokensBalancesDict, key: u256, value: u256) {
        let current: u256 = match self.get(key) {
            Option::Some(val) => val,
            Option::None => Default::default()
        };
        
        let new = current + value;
        self.insert(key, new);
        println!("new value {}", new);

    }

    fn get(ref self: U256TokensBalancesDict, key: u256) -> Option<u256> {
      println!("test1");
        let h = Self::hash_key(key);
        let low = self.low_dict.get(h);
        let high = self.high_dict.get(h);
        println!("getting at hash {}", h);
        println!("low {}", low);
          println!("high {}", high);
        if low == 0 && high == 0 {
            Option::None
        } else {
            Option::Some(u256 { 
                low: low.try_into().unwrap(),
                high: high.try_into().unwrap()
            })
        }
    }

    fn keys_get(ref self: U256TokensBalancesDict) -> Array<u256> {
        let mut result = ArrayTrait::new();
        let len = self.keys.len();
        let mut i = 0;
          println!("keys len {}", len);
        loop {
            if i == len {
                break;
            }
            
           // let h = ;
             let h = Self::hash_key(*self.keys.at(i));
            let low = self.low_dict.get(h);
            let high = self.high_dict.get(h);
               println!("test2");
            
            result.append(u256 {
                low: low.try_into().unwrap_or(0),
                high: high.try_into().unwrap_or(0),
            });
              println!("test3");
            
            i += 1;
        }
        result
    }

     fn to_array_u256(ref self: U256TokensBalancesDict) -> Array<BalanceToWithdraw> {
        let mut result = ArrayTrait::new();
        let keys = @self.keys;
        let len = keys.len();
        let mut i = 0;

          println!("keys {:?}", keys);
        
        loop {
            if i == len {
                break;
            }
            
            let key = *keys.at(i);

            println!("key to get at array composition {}", key);
            let amount = self.get(key).unwrap();
            
            result.append(BalanceToWithdraw {
                token_contract_address: key,
                amount,
            });
            
            i += 1;
        };
        result
    }
}