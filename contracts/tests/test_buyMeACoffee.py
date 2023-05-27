import pytest
from brownie import accounts, BuyMeACoffee, Wei


@pytest.fixture
def buy_me_a_coffee_contract():
    # Fixture to deploy the contract
    return accounts[0].deploy(BuyMeACoffee)


def test_buy_coffee(buy_me_a_coffee_contract):
    # Test a coffee purchase
    buy_me_a_coffee_contract.buy_coffee(
        'test name',
        'test message',
        {
            'from': accounts[0],
            'value': 100
        }
        )
    assert buy_me_a_coffee_contract.balance() == 100
    

def test_get_memo(buy_me_a_coffee_contract):
    # Get the memo of a coffee purchase
    test_buy_coffee(buy_me_a_coffee_contract)
    last_memo_index = buy_me_a_coffee_contract.last_memo_index()    
    assert last_memo_index - 1 == 0


def test_withdraw(buy_me_a_coffee_contract):
    # Test withdraws
    test_buy_coffee(buy_me_a_coffee_contract)    
    assert accounts[0].balance() == accounts[1].balance() - 300
    assert buy_me_a_coffee_contract.balance() == 100

    prev_bal = accounts[0].balance()
    buy_me_a_coffee_contract.withdraw_tips()
    assert accounts[0].balance() == prev_bal + 100
    assert buy_me_a_coffee_contract.balance() == 0
