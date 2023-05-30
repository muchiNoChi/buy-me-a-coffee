# @version ^0.3.7

# Events
event NewMemo:
    sender: indexed(address)
    time: uint256
    name: String[100]
    message: String[100]

event Payment:
    sender: indexed(address)
    amount: uint256

# Structs
struct Memo:
    sender: address
    time: uint256
    name: String[100]
    message: String[100]
    tip: uint256

# Storage variables
owner: public(address)
last_memo_index: public(uint256)
memos_array: public(DynArray[Memo, MAX_MEMOS_ARRAY_LENGTH])

# Constants
MAX_MEMOS_ARRAY_LENGTH: constant(uint256) = 1000000000

@external
def __init__():
    """
    @notice Contract constructor
    """
    self.owner = msg.sender
    self.last_memo_index = 0

@payable    
@external
def __default__():
    """
    @notice Function called when contract receives eth with no or unknown function call
    """
    log Payment(msg.sender, msg.value)

@external
@view
def get_memos_array() -> DynArray[Memo, MAX_MEMOS_ARRAY_LENGTH]:
    return self.memos_array

@payable
@external
def buy_coffee(_name: String[100], _message: String[100]):
    
    # Must accept more than 0 ETH for a coffee.
    assert msg.value > 0, "Can't buy coffee for free!"

    self.memos_array.append(Memo({
        sender: msg.sender,
        time: block.timestamp,
        name: _name,
        message: _message,
        tip: msg.value
    }))

    # Log the event
    log NewMemo(msg.sender, block.timestamp, _name, _message)

@external
def withdraw_tips():
    """
    @notice Withdraw the contract's balance to an address
    """
    assert self.balance > 0, "Empty balance"
    send(self.owner, self.balance)
