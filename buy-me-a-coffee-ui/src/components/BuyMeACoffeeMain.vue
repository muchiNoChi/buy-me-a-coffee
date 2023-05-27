<template>
  <el-container>
    <el-main>
      <el-row :gutter="20">
        <el-col :span="13">
          <el-text class="mx-1" size="large">Helo gib kofi pls</el-text>
        </el-col>
        <el-col :span="11">
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
        <el-input
          v-model="memo"
          :autosize="{ minRows: 2, maxRows: 4 }"
          type="textarea"
          placeholder="Message"
        />
      </el-row>
      <el-row justify="center">
        <el-button @click="sendFunds">Send ETH</el-button>
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

export default {
  data() {
    return {
      accountAddress: null,
      receiverAddress: null,
      tipAmount: null,
      memo: null,
      txHash: null,
    }
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
          console.log('Metamask is not installed, consider installing it first.')
        }
      } catch (error) {
        console.log(error)
      }
    },

    async sendFunds() {
      if (!this.accountAddress) return;
      try {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner(this.accountAddress);
        await window.ethereum
          .request({
            method: 'eth_sendTransaction',
            params: [
              {
                from: this.accountAddress,
                to: this.receiverAddress,
                value: ethers.utils.parseUnits(this.tipAmount, 'ether').toHexString(),
              }
            ]
          })
          .then(txHash => {
            console.log(txHash);
            this.txHash = txHash;
            this.txUrl = `https://sepolia.etherscan.io/tx/${txHash}`;
          });
      } catch (error) {
        console.log(error)
      }
    }
  }
}
</script>

<style scoped>
el-container {
  display: flex;
  align-content: center;
}
</style>
