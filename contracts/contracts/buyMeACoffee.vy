# @version ^0.3.7

event NewMemo:
    sender: indexed(address)
    time: uint256
    name: String[100]
    message: String[100]

struct Memo:
    sender: address
    time: uint256
    name: String[100]
    message: String[100]

owner: address
memos: public(HashMap[uint256, Memo])
memoCount: public(uint256)

@external
def __init__():
    self.owner = msg.sender

@external
def get_memos(memo_index: uint256) -> Memo:
    return self.memos[memo_index]

@external
def buy_coffee():
    # TODO
    pass

@external
def withdraw_tips():
    # TODO
    pass
