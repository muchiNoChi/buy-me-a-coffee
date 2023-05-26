from brownie import BuyMeACoffee, accounts
import os
from dotenv import load_dotenv

# Load .env variables
load_dotenv()

"""
Process:
    Create a deployment script
    Test the script on your local development environment
    Test the script again on one of the public test networks and verify that it executed as intended
    Use the script to deploy your project to the mainnet
"""

def main():
    acct = accounts.load(os.getenv('DEPLOY_ACCOUNT_ID'))
    BuyMeACoffee.deploy({'from': acct}, publish_source=True) # Etherscan cannot yet verify Vyper contracts, so this will throw an error and contract will have to be verified manually
