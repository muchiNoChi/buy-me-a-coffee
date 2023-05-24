<template>
  <el-container>
    <el-main>
      <el-col>
        <el-row><el-text class="mx-1" size="large">Helo gib kofi pls</el-text></el-row>
        <el-row>
          <el-button @click="connectWallet">Connect wallet</el-button>
          <el-button @click="sendFunds">Send ETH</el-button>
        </el-row>
        <el-row>
          <el-input v-model="tipAmount" placeholder="Enter tip amount" />
          <el-input
            v-model="memo"
            :autosize="{ minRows: 2, maxRows: 4 }"
            type="textarea"
            placeholder="Message"
          />
        </el-row>
      </el-col>
    </el-main>
  </el-container>
</template>

<script>
import { ethers } from 'ethers';

export default {
  data() {
    return {
      accountAddress: null,
      tipAmount: null,
      memo: null
    }
  },

  methods: {
    async connectWallet() {
      try {
        if (window.ethereum) {
          const accounts = await window.ethereum.request({
            method: 'eth_requestAccounts'
          })

          this.accountAddress = accounts[0]
        } else {
          console.log('Metamask is not installed, consider installing it first.')
        }
      } catch (error) {
        console.log(error)
      }
    },

    async sendFunds() {
      try {
        const accounts = await window.ethereum
          .request({
            method: 'eth_sendTransaction',
            params: [
              {
                from: this.accountAddress,
                to: this.accountAddress, // TODO pass a target address here
                value: ethers.utils.parseUnits(this.tipAmount, 'ether').toHexString(),
                gasPrice: '0x09184e72a000', // Customizable by the user during MetaMask confirmation.
                gas: '0x2710' // Customizable by the user during MetaMask confirmation.
              }
            ]
          })
          .then((txHash) => console.log(txHash))

        this.accountAddress = accounts[0]
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
