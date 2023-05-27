<template>
  <el-container>
    <el-main>
      <el-row :gutter="20">
        <el-col :span="16">
          <el-text class="mx-1">Helo gib kofi to Leo and Sasha pls</el-text>
        </el-col>
        <el-col :span="8">
          <el-button v-if="!accountAddress" @click="connectWallet">Connect wallet</el-button>
          <el-button v-else type="success" plain disabled>Connected</el-button>
        </el-col>
      </el-row>
      <el-row :gutter="20">
          <el-input v-model="tipAmount" placeholder="Enter tip amount" />
        <el-col :span="9">
        </el-col>
      </el-row>
      <el-row :gutter="20">
          <el-input v-model="name" placeholder="Enter you name" />
        <el-col :span="9">
        </el-col>
      </el-row>
      <el-row :gutter="20">
        <el-input
          v-model="memo"
          :autosize="{ minRows: 2, maxRows: 4 }"
          type="textarea"
          placeholder="Message"
        />
      </el-row>
      <el-row justify="center">
        <el-button @click="buyACoffee">Send us ETH pls wi poor</el-button>
        <el-button
          v-if="canWithdraw" @click="withdrawTips">Withdraw tips</el-button>
      </el-row>
      <el-row v-if="txHash" :gutter="20">
        <el-link type="success" :href="txUrl">
          {{ txHash }}<el-icon class="el-icon--right"></el-icon>
        </el-link>
      </el-row>
    </el-main>
  </el-container>
</template>

<script>
import { ethers } from 'ethers'
import contractAbi from '../../utils/BuyMeACoffee.json';

export default {
  data() {
    return {
      accountAddress: null,
      contractAddress: '0x1BeD6fEa980Ab67675EC07452E818EdF306AD9Bc',
      contractOwnerAddress: null,

      tipAmount: 0.0001,
      name: 'sashlek',
      memo: 'Thank you for being kittens! Let me buy you a coffee.',
      txHash: null,

      memos: [],
    }
  },

  computed: {
    buyMeACoffeeContract() {
      if (!this.accountAddress) return null;
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner(this.accountAddress);
      return new ethers.Contract(this.contractAddress, contractAbi.abi, signer);
    },

    canWithdraw() {
      if (!this.buyMeACoffeeContract) return false;
      const creator = this.buyMeACoffeeContract.owner;
      console.log(`contract creator is ${creator}`)
      return creator === this.accountAddress; // only creator can withdraw tips
    },
  },

  methods: {
    async connectWallet() {
      try {
        if (window.ethereum) {
          const accounts = await window.ethereum.request({
            method: 'eth_requestAccounts'
          });

          this.accountAddress = accounts[0];
          console.log(this.accountAddress);
        } else {
          console.log('Metamask is not installed, consider installing it first.');
        }
      } catch (error) {
        console.log(error)
      }
    },

    async buyACoffee() {
      if (!this.buyMeACoffeeContract) return;
      try {
        const coffeeTxn = await this.buyMeACoffeeContract.buy_coffee(
          this.name,
          this.memo,
          {
            value: ethers.utils.parseEther(this.tipAmount),
          }
        );
        await coffeeTxn.wait();
        this.txHash = coffeeTxn.hash;
        this.txUrl = `https://sepolia.etherscan.io/tx/${this.txHash}`;
      } catch (error) {
        console.log(error)
      }
    },

    // fetches all memos from on-chain data
    async getMemos() {
      if (!this.buyMeACoffeeContract) return;
      try {
        this.memos = await this.buyMeACoffeeContract.getMemos();
      } catch (err) {
        console.error(err);
      }
    },

    async withdrawTips() {
      // TODO
    },
  }
}
</script>

<style scoped>
el-container {
  display: flex;
  align-content: center;
}
</style>
