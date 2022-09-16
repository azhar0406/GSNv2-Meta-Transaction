// const ethers = require('ethers')
// var Web3 = require( 'web3')
const {RelayProvider} = require('@opengsn/provider')

const contractArtifact = require('./NoGas.json')

const contractAbi = contractArtifact

let theContract
let provider

async function initContract() {

    if (!window.ethereum) {
        throw new Error('provider not found')
    }
    window.ethereum.on('accountsChanged', () => {
        console.log('acct');
        window.location.reload()
    })
    window.ethereum.on('chainChanged', () => {
        console.log('chainChained');
        window.location.reload()
    })
    const networkId = await window.ethereum.request({method: 'net_version'})


    // provider = new ethers.providers.Web3Provider(window.ethereum);

    const conf = {
        paymaster:   '0xca068C4AeEb4A5832C993B0fF1272BB6743B4575',
        forwarder:   '0x7614f9Decb3115017B8e32F613942EFD5BC8c83F',
        ourContract: '0xd351272F4F899E205AF6DF31b094cB8B94dbE0e1',
        // gasPrice:  20000000000   // 20 Gwei
    }


    
    gsnProvider = await RelayProvider.newProvider({
        provider: window.ethereum,
        config: {
            loggerConfiguration: {logLevel: 'debug'},
            paymasterAddress: conf.paymaster,
            relayLookupWindowBlocks: 6e5,
            relayRegistrationLookupBlocks: 6e5,
            // maxViewableGasLimit: 6400000,
        }
    }).init();

    // console.log(gsnProvider);

    
    provider = new ethers.providers.Web3Provider(gsnProvider);

    let checkprovider = await provider.send("eth_requestAccounts", []);

    console.log(provider);
    
    console.log(checkprovider);

    const network = await provider.getNetwork()

    // console.log(network);

    const contractAddress = conf.ourContract;

    // console.log(contractAddress);

    // await theContract.web3.setProvider(gsnProvider)
    const accounts = await provider.listAccounts();

    // console.log(provider.getSigner(accounts[0]));

    theContract = new ethers.Contract(contractAddress, contractAbi, provider.getSigner(accounts[0]))


    await listenToEvents()
    return {contractAddress, network}
}

async function contractCall() {
    
  
    // await window.ethereum.send('eth_requestAccounts')
// console.log(await provider.getGasPrice());

// const accounts = await provider.listAccounts();
// console.log(accounts[0]);
    // const txOptions = {gasPrice: 1600000008}


//    v = ethers.BigNumber.from(await theContract.estimateGas.captureTheFlag());


//    const txOptions = {gasLimit: (v.toNumber() * 3)}
//    const txOptions = {gasLimit: 6400000}
 
   

//    console.log( v.toNumber());
    const transaction = await theContract.captureTheFlag()
    const hash = transaction.hash
    console.log(`Transaction ${hash} sent`)
    const receipt = await transaction.wait()
    console.log(`Mined in block: ${receipt.blockNumber}`)
}

let logview

function log(message) {
    message = message.replace(/(0x\w\w\w\w)\w*(\w\w\w\w)\b/g, '<b>$1...$2</b>')
    if (!logview) {
        logview = document.getElementById('logview')
    }
    logview.innerHTML = message + "<br>\n" + logview.innerHTML
}

async function listenToEvents() {

    theContract.on('FlagCaptured', (previousHolder, currentHolder, rawEvent) => {
        log(`Flag Captured from&nbsp;${previousHolder} by&nbsp;${currentHolder}`)
        console.log(`Flag Captured from ${previousHolder} by ${currentHolder}`)
    })
}

window.app = {
	// listenToEvents: listenToEvents,
    initContract,
    contractCall,
    log
}
