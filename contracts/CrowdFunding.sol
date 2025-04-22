import { useEffect, useState } from "react";
import Web3 from "web3";
import CrowdFundingABI from "./CrowdFundingABI.json"; // Ganti dengan ABI kontrak kamu

const CONTRACT_ADDRESS = "0xYourContractAddressHere"; // Ganti dengan alamat kontrakmu

function App() {
  const [account, setAccount] = useState("");
  const [contract, setContract] = useState(null);
  const [balance, setBalance] = useState("0");
  const [goal, setGoal] = useState("0");
  const [raised, setRaised] = useState("0");
  const [amount, setAmount] = useState("");
  const [loading, setLoading] = useState(false);

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
    try {
      setLoading(true);
      const bal = await contract.methods.getBalance().call();
      const raisedAmount = await contract.methods.raisedAmount().call();
      const goalAmount = await contract.methods.goal().call();
