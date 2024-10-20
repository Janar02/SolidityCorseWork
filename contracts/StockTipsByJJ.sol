// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract StockTipsByJJ{
    string private stockTip;
    string private stockTipExplanation;
    // Võtsin kasutusele payable modifieri, mida käsitleti udemy kursuse hilisemas faasis
    // payable võimaldab teha antud aadressiga tehinguid
    address payable private owner;
    uint private stockTipPrice;

    constructor(string memory _initialTip, string memory _initialDesc){
        owner = payable(msg.sender);
        stockTipPrice = 0.001 ether; // 1 finney, 1000000 gwei, 1000000000000000 wei
        stockTip = _initialTip;
        stockTipExplanation = _initialDesc;
    }

    // Otsustasin kasutada modifierit, et muuta nutilepingu omaniku kontroll lihtsamaks ja vähendada koodi.
    modifier OnlyOwner(){
        require(msg.sender == owner, "Only the contract deployer can edit the stock tip");
        _;
    }

    // Uue aktsiavihje postitamine (võimalik vaid omanikule)
    function SetNewStockTip(string memory _newStockTip, string memory _explanation) public OnlyOwner{
        stockTip = _newStockTip;
        stockTipExplanation = _explanation;

    }
    // Tasuta aktsiavihje
    function GetFreeStockTip() public view returns(string memory){
        return  stockTip;
    }
    // Tasuline aktsiavihje
    // Eeldasin, et kuna funktsioon peab muutma 
    function GetDetailedStockTip() public payable  returns(string memory) {
        if(msg.value < stockTipPrice){
            payable(msg.sender).transfer(msg.value);
            return "Value refunded! Not enough ETH to unlock stock tip.";
        }else{
            // liigsed ETH-d saadetakse ostjale tagasi
            if(msg.value > stockTipPrice){
                payable(msg.sender).transfer(msg.value - stockTipPrice);
            }
            return  GetStockTipFullText(stockTip, stockTipExplanation);
        }
    }

    // Tulu välja kasseerimise meetod
    function WithdrawIncome() public OnlyOwner{
        // address.this viitab antud nutilepingu aadressile, kuhu kogunevad ostjate saadetud ETH-d
        owner.transfer(address(this).balance);
    }

    // Funktsioon sobiva stringi genereerimiseks. Funktsioon on pure, kuna kasutab ainult parameetritena kaasa antud väärtusi
    function GetStockTipFullText(string memory str1, string memory str2) private pure returns(string memory){
        return string(abi.encodePacked(str1, " - ", str2));
    }

    // 3.
    
    // Kas teenuse kasutaja saab teha kindlaks aktsiavihje aja?
        // Kuna nutilepinguga seotud tehingud on avalikult plokiahelast leitavad, siis on kasutajal võimalik kindlaks teha, millal viimane
        // SetNewStockTip meetodi signatuuriga tehing ahelasse lisati. See ei ole kindlasti kasutajasõbralik ja kuna aeg on aktsiavihjete 
        // puhul võrdlemisi oluline, siis võiks seda kuvada tasuta aktsiavihje juures. Selleks saaks kasutada funktsiooni block.timestamp
        // mis salvestab viimase bloki mainimise kellaaja uint-na. Kuvamisel peaks ta tagasi Date vormi koverteerima.

    // Kas teenuse kasutaja saab plokiahelast vaadata, millised olid varasemad vihjed?
        //  Kasutajal ei ole võimalik plokiahelast näha, millised olid varasemad vihjed. 
        // Selle võimaldamiseks saaks kasutusele võtta listi, kuhu tip-i uuendamisel salvestatada varasemad väärtused.

    string[] private stockTipHistory;
    // Uue aktsiavihje postitamine sedasi, et varasemad salvestatakse
    function SetNewStockTipAdv(string memory _newStockTip, string memory _explanation) public OnlyOwner{
        stockTipHistory.push(stockTip); // Salvestan avalikku ajalukku vaid tasuta vihjed
        stockTip = _newStockTip;
        stockTipExplanation = _explanation;
    }

    function GetPreviousFreeTips() public view returns(string[] memory){
        return stockTipHistory;
    }

    // Kui vihjete kohta on soov rohkem infot kaasa panna, kui ainult tasuta vihje string,
    // siis peaks looma oma andmestruktuuri kasutades struct-i

    // struct StockTip{
    //     string freeTip;
    //     string desc;
    // }
    // StockTip[] private stockTipHistory;
    // // Uue aktsiavihje postitamine sedasi, et varasemad salvestatakse
    // function AdvSetNewStockTip(string memory _newStockTip, string memory _explanation) public OnlyOwner{
    //     StockTip memory oldTip = StockTip({
    //         freeTip: stockTip,
    //         desc: stockTipExplanation
    //     });
    //     stockTipHistory.push(oldTip); // Salvestan avalikku ajalukku vaid tasuta vihjed
    //     stockTip = _newStockTip;
    //     stockTipExplanation = _explanation;
    // }

    // function GetPreviousFreeTips() public view returns(StockTip[] memory){
    //     return stockTipHistory;
    // }
}