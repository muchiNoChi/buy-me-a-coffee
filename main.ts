window.addEventListener('DOMContentLoaded', (event) => {
  const connectWalletBtn: HTMLElement | null = document.getElementById('connectWalletBtn');

  connectWalletBtn?.addEventListener('click', async () => {
    // Handle the wallet connection logic here
    alert('Wallet connection functionality will be implemented here.');
  });
});

const connectWallet = async () => {
  try {
    const { ethereum } = window as any;
    const accounts = await ethereum.request({
      method: 'eth_requestAccounts',
    });

    const account = accounts[0];

  } catch (error) {
    console.log(error);
  }
}