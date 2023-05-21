<template>
  <el-container>
    <el-main>
      <el-col>
        <el-row><el-text class="mx-1" size="large">Helo gib kofi pls</el-text></el-row>
        <el-row>
          <el-button @click="connectWallet">Connect wallet</el-button>
          <el-button @click="sendFunds">Send ETH</el-button>
        </el-row>
      </el-col>
    </el-main>
  </el-container>
</template>

<script>
export default {
  data() {
    return {
      accountAddress: null,
    }
  },

  methods: {
    async connectWallet() {
      try {
        if (window.ethereum) {
          const accounts = await window.ethereum.request({
            method: 'eth_requestAccounts',
          });

          this.accountAddress = accounts[0];
        } else {
          console.log('Metamask is not installed, consider installing it first.');
        }
      } catch (error) {
        console.log(error);
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
                value: '0x29a2241af62c0000', // Only required to send ether to the recipient from the initiating external account.
                gasPrice: '0x09184e72a000', // Customizable by the user during MetaMask confirmation.
                gas: '0x2710', // Customizable by the user during MetaMask confirmation.
              },
            ],
          })
          .then((txHash) => console.log(txHash))

        this.accountAddress = accounts[0];
      } catch (error) {
        console.log(error);
      }
    },
  },
}
</script>

<style scoped>
el-container {
  display: flex;
  align-content: center;
}
</style>
