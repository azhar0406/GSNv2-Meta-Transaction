# GSNv 2 Meta Transaction with foundry

This sample dapp emits an event with the last account that clicked on the "capture the flag" button. We will integrate
this dapp to work gaslessly with GSN v2. This will allow an externally owned account without ETH to capture the flag by
signing a meta transaction

1. Paymaster: (https://rinkeby.etherscan.io/address/0xca068c4aeeb4a5832c993b0ff1272bb6743b4575)

2. Forwarder: (https://rinkeby.etherscan.io/address/0x7614f9decb3115017b8e32f613942efd5bc8c83f)

3. CaptureTheFlag: (https://rinkeby.etherscan.io/address/0xd351272f4f899e205af6df31b094cb8b94dbe0e1)


### To run the sample:

1. first clone and cd fronted
2. run  `npm install`
3. Make sure you have Metamask installed, and pointing to "Rinkeby"
4. In a different window, run `npm run dev`, to start the UI
5. New tab will open automatically "http://127.0.0.1:8080/"
6. Click the "Capture the Flag" button. Notice that you don't need an account with eth for that but under the paymaster you must whitelist the sender as well as the target. 


### Further reading

Documentation explaining how everything works: https://docs-v2.opengsn.org/