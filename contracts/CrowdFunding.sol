import { useEffect, useState } from "react";
import Web3 from "web3";
import CrowdFundingABI from "./CrowdFundingABI.json"; // Simpan ABI hasil compile ke file ini

const CONTRACT_ADDRESS = "0xYourContractAddressHere";

function App() {
  const [account, setAccount] = useState("");
  const [contract, setContract] = useState(null);
  const [balance, setBalance] = useState("0");
  const [goal, setGoal] = useState(0);
  const [raised, setRaised] = useState(0);
  const [amount, setAmount] = useState("");

  const connectWallet = async () => {
    if (window.ethereum) {
      const web3 = new Web3(window.ethereum);
      await window.ethereum.enable();
      const accounts = await web3.eth.getAccounts();
      setAccount(accounts[0]);

      const instance = new web3.eth.Contract(CrowdFundingABI, CONTRACT_ADDRESS);
      setContract(instance);
    } else {
      alert("Please install Metamask");
    }
  };

  const fetchDetails = async () => {
    if (!contract) return;

    const bal = await contract.methods.getBalance().call();
    const raisedAmount = await contract.methods.raisedAmount().call();
    const goal = await contract.methods.goal().call();

    setBalance(bal);
    setRaised(raisedAmount);
    setGoal(goal);
  };

  const contribute = async () => {
    if (!amount) return;
    await contract.methods.contribute().send({
      from: account,
      value: Web3.utils.toWei(amount, "wei"),
    });
    fetchDetails();
  };

  useEffect(() => {
    connectWallet();
  }, []);

  useEffect(() => {
    if (contract) fetchDetails();
  }, [contract]);

  return (
    <div className="App" style={{ padding: "2rem", fontFamily: "Arial" }}>
      <h1>Crowdfunding DApp</h1>
      <p><strong>Connected Account:</strong> {account}</p>
      <p><strong>Contract Balance:</strong> {balance} wei</p>
      <p><strong>Raised:</strong> {raised} / {goal} wei</p>

      <input
        type="number"
        placeholder="Amount in wei"
        value={amount}
        onChange={(e) => setAmount(e.target.value)}
      />
      <button onClick={contribute}>Contribute</button>
    </div>
  );
}

export default App;
