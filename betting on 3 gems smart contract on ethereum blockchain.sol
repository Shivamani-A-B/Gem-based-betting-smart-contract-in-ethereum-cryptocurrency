pragma solidity ^0.5.10;

contract betting_game {
    address payable public owner; //the owner to access the whole contract
    uint256 public minbet; // mininum amount to be betted.
    uint256 public gem1; //this gem is ruby.(for say)
    uint256 public gem2;  //this gem is diamond.(for say)
    uint256 public gem3; // this gem is emarald.(for say)
    address payable[] public players;  //number of players entered stored as an array.
    struct player {    // individually get the players details.
        uint256 amountbet;
        uint16 teamselected;
    }
    mapping (address=>player) public playerinfo;  //assigning the player details to the players address.
    function() external payable {} // this is used for internal and external transaction.
 
    constructor() public {   // constructor for the owner to evoke this contract.
        owner =msg.sender;
        minbet=1000000000000000000;  // mentioned in wei .   one wei = 1x10^18   which is equal to 1 ether.
    }
    function kill() public{  // if the owneris willing to end the contract on the block when needed.
        if(msg.sender==owner) selfdestruct(owner);
    }
    function checkplayerexists(address payable _player)public view returns(bool) {  // to check whether the player has enrolled twice for the same game.
        for(uint i=0;i<players.length;i++){
            if(players[i]==_player){
                return (true);
            }
        }
        return false;
    }
    function bett(uint8 _teamselected)public payable{  // this is where the betting takes place.
        require(!checkplayerexists(msg.sender));
        require(msg.value>=minbet && msg.value<=1000);  // condition to check whether the player has given the minimum bet value and should not exceed the value 1000 ether.
        playerinfo[msg.sender].amountbet=msg.value;
        playerinfo[msg.sender].teamselected=_teamselected;
        players.push(msg.sender);
        if(_teamselected==1){    //votng on gems
            gem1 += msg.value;
        }
        else if(_teamselected==2){
            gem2 += msg.value;
        }
        else{
            gem3 += msg.value;
        }
    }
    function distributeprize(uint16 teamwinner) public{  // distributing the price after winning the bet.
        address payable[1000] memory winners;
        uint256 count = 0;
        uint256 loserbet = 0;
        uint256 winnerbet = 0;
        address add;
        uint256 bet;
        address payable playeraddress;
        for(uint256 i=0;i<players.length;i++){
            playeraddress=players[i];
            if(playerinfo[playeraddress].teamselected==teamwinner){
                winners[count]=playeraddress;
                count++;
            }
        }
        if(teamwinner==1){
            loserbet=gem2;
            loserbet=gem3;
            winnerbet=gem1;
        }
        else if(teamwinner==2){
            loserbet=gem1;
            loserbet=gem3;
            winnerbet=gem2;
        }
        else{
            loserbet=gem1;
            loserbet=gem2;
            winnerbet=gem3;
        }
        for(uint256 j=0;j<count;j++){ //to give the winner 3 times the bet with 5% deducted and performining 4 stages.
            if(winners[j]!=address(0)){
                add=winners[j];
                bet=playerinfo[add].amountbet;
                winners[j=0].transfer(bet*3-(bet*3)*5/100);
                winners[j+=1].transfer((bet*3)*5/100);
                winners[j+=2].transfer((bet*3)*3/100);
                winners[j+=3].transfer((bet*3)*2/100);
                winners[j+=4].transfer((bet*3)*1/100);
                winners[j+=5].transfer((bet*3)*1/2/100);
                winners[j+=6].transfer((bet*3)*1/2/100);
                winners[j+=7].transfer((bet*3)*1/2/100);
                winners[j+=8].transfer((bet*3)*1/2/100);
                winners[j+=9].transfer((bet*3)*1/2/100);
                winners[j+=10].transfer((bet*3)*1/2/100);
                winners[j+=11].transfer((bet*3)*1/4/100);
                winners[j+=12].transfer((bet*3)*1/4/100);
                winners[j+=13].transfer((bet*3)*1/4/100);
                winners[j+=14].transfer((bet*3)*1/4/100);
                break;
            }
            
        }
        
        // reseting the variables for next round of game.
        delete playerinfo[playeraddress];
        players.length=0;
        loserbet=0;
        winnerbet=0;
        gem1=0;
        gem2=0;
        gem3=0;
        owner.transfer(loserbet+(bet-(bet*3-(bet*3)*5/100)));
    }
    function amountgem() public view returns(uint256){ // displaying the amount in gem 1
        return(gem1);
    }
    function amountgem2() public view returns(uint256){ // displaying the amount in gem 2
        return(gem2);
    }
    function amountgem3() public view returns(uint256){ // displaying the amount in gem 3
        return(gem3);
    }
}
