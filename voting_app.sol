contract Election{ //constructor

struct Candidate { //Voter details such as name and the no. of votes they have
string name;
uint voteCount;
}

struct Voter{ //To keep track of if they already voted and who they voted for

bool voted; //0 for not voted and 1 for voted
uint voteIndex; //Every party they can vote for will have a custom voteIndex
uint weight;
}

address public owner;
string public name;//To keep track of the owner of the contract as they need to authorize the voters
mapping (address => Voter)public voters; //Mapping to store voter info. and keep a dynamically sized array of the voters
Candidate[] public candidates; //Array consisting of all candidates
uint public auctionEnd; //keep track of when auction ended using integer time stamp

event ElectionResult(string name, uint voteCount); //An event which can be called to display election results

function Election(string _name, uint durationMinutes, string candidate1, string candidate2){
owner = msg.sender;
name = _name;
auctionEnd = now + (durationMinutes * 1 minutes); //now is an alias to block.timestamp
candidates.push(Candidate(candidate1,0)); //Define candidate objects using provided names. This gives out the block's creation time. Not actual time stamp'
candidates.push(Candidate(candidate2,0));

}

function authorize(address voter) {
require(msg.sender == owner);
require(!voters[voter].voted);
voters[voter].weight =1; //Only authorized voters whose weight is assigned as 1 can vote
}

function vote(uint voteIndex){ //function that allows voters to vote for a canditate in the list
// Since this list is made public, anyone can access the list of canditates to vote for
require(now<auctionEnd); //check if time for voting hasn't ended
require(!voters[msg.sender].voted);//check if person hasn't already voted before'
voters[msg.sender].voted = true;
voters[msg.sender].voteIndex = voteIndex;//increase the vote count by the amount of weight given to the voter
//Even if unauthorized voter calls the vote function, unless they have authorized weight, it won't affect the end result
candidates[voteIndex].voteCount += voters[msg.sender].weight;
}

function end(){ //function to end the Election
require(msg.sender==owner); //Make sure person ending Election is the owner
//require(now>=auctionEnd); //Ensure time has been exceeded

for(uint i=0; i< candidates.length; i++){
ElectionResult(candidates[i].name, candidates[i].voteCount);
}
}

}
