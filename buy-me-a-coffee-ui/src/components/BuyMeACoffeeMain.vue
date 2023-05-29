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
        <el-col :span="9"> </el-col>
      </el-row>
      <el-row :gutter="20">
        <el-input v-model="name" placeholder="Enter you name" />
        <el-col :span="9"> </el-col>
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
        <el-button v-if="canWithdraw" @click="withdrawTips">Withdraw tips</el-button>
      </el-row>
      <el-row v-if="txHash" :gutter="20">
        <el-link type="success" :href="txUrl">
          {{ txHash }}<el-icon class="el-icon--right"></el-icon>
        </el-link>
      </el-row>
      <el-row v-if="currentBalance" :gutter="20">
        <el-statistic title="Current tips amount (ETH)" :value="currentBalance" />
      </el-row>

      <!-- Memos list -->
      <el-table :data="memos" style="width: 100%">
        <el-table-column prop="name" label="Name" width="180" />
        <el-table-column prop="tip" label="Tip" width="180" />
        <el-table-column prop="message" label="Message" />
      </el-table>
    </el-main>
  </el-container>
</template>

<script>
import { ethers } from 'ethers'
import contractAbi from '../../utils/BuyMeACoffee.json'

export default {
  data() {
    return {
      accountAddress: null,
      contractAddress: '0x1BeD6fEa980Ab67675EC07452E818EdF306AD9Bc',
      contractOwnerAddress: null,
      currentBalance: 0,

      tipAmount: '0.0001',
      name: 'sashlek',
      memo: 'Thank you for being kittens! Let me buy you a coffee.',
      txHash: null,

      memos: []
    }
  },

  async created() {
    // this.currentBalance = await this.getContractBalance();
  },

  computed: {
    buyMeACoffeeContract() {
      if (!this.accountAddress) return null
      const provider = new ethers.providers.Web3Provider(window.ethereum)
      const signer = provider.getSigner(this.accountAddress)
      return new ethers.Contract(this.contractAddress, contractAbi.abi, signer)
    },

    canWithdraw() {
      if (!this.contractOwnerAddress) return false
      return this.contractOwnerAddress === this.accountAddress // only creator can withdraw tips
    }
  },

  methods: {
    async connectWallet() {
      try {
        if (window.ethereum) {
          const accounts = await window.ethereum.request({
            method: 'eth_requestAccounts'
          })

          this.accountAddress = ethers.utils.getAddress(accounts[0])
          console.log(this.accountAddress)
          this.contractOwnerAddress = await this.getContractOwner()
          this.currentBalance = await this.getContractBalance()
          this.memos = await this.getMemos()
        } else {
          console.log('Metamask is not installed, consider installing it first.')
        }
      } catch (error) {
        console.log(error)
      }
    },

    async buyACoffee() {
      if (!this.buyMeACoffeeContract) return
      try {
        const coffeeTxn = await this.buyMeACoffeeContract.buy_coffee(this.name, this.memo, {
          value: ethers.utils.parseEther(this.tipAmount)
        })
        await coffeeTxn.wait()
        this.txHash = coffeeTxn.hash
        this.txUrl = `https://sepolia.etherscan.io/tx/${this.txHash}`
        this.currentBalance = await this.getContractBalance()
      } catch (error) {
        console.log(error)
      }
    },

    // fetches all memos from on-chain data
    async getMemos() {
      if (!this.buyMeACoffeeContract) return
      try {
        const lastMemoIndex = await this.buyMeACoffeeContract.last_memo_index()
        // lastMemoIndex is a counter, and getMemos expects an index for a memo -
        // pass it and decrement the counter.
        const memoPromises = [];
        for (let i = lastMemoIndex - 1; i >= 0; i--) {
          memoPromises.push(this.buyMeACoffeeContract.get_memos(i))
        }
        await Promise.all(memoPromises)
          .then(res => this.memos = res)
          .catch(err => console.error(err))
      } catch (err) {
        console.error(err)
      }
    },

    async getContractOwner() {
      console.log(this.buyMeACoffeeContract)
      const contractOwnerAddress = await this.buyMeACoffeeContract.owner()
      console.log(`contract creator is ${contractOwnerAddress}`)
      return contractOwnerAddress
    },

    async getContractBalance() {
      console.log(this.buyMeACoffeeContract)
      const provider = new ethers.providers.Web3Provider(window.ethereum)
      const bigIntBalance = await provider.getBalance(this.contractAddress)
      const balance = ethers.utils.formatEther(bigIntBalance)
      console.log(`contract balance is ${this.contractOwnerAddress}`)
      return balance
    },

    async withdrawTips() {
      // TODO
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
