pragma solidity ^0.5.5;
//pragma experimental ABIEncoderV2;
contract ProfileMessages {

    struct Tier2_Profile {
        bool smoker; //True or False for end user.
        string alchohol; // Three option - occassional drinker, dauly drinker or NO.
        string ethnicity;
        string languages;
        string zodiac_sign;
        string profession;
        string education_level;
    } 
    
    struct Tier3_Profile {
        bool kids; //This should be a True or False result for end user.
        string looking_for; // Type of relationship user is looking for (casual, long-term, FWB)
        string religion; // 3 major religions (Christianity, Islam and Judaism)
        string interests; // hobbies other activities 
        string build; //whether person is athletic, heavy-set or average.
    } 
    
    struct Base_Profile {
        uint256 profile_id;
        string usersName;
        string userGender; //Currently only Male and Female for end user.
        uint userAge;
        string userBio;
        string ipfsHash;
        // messages of a user
        uint[] messages;
        mapping(uint256 => uint256) messagePointers;
        uint[] interested_in; // Sexual orientation
        bool Active;
        Tier2_Profile t2_Profile;
        Tier3_Profile t3_Profile;
    } 
    
    struct Message {
        uint256 id;
        uint256 parent;
        string content;
        address writtenBy;
        uint256 timestamp;
        uint256 timetolive;
        // addresses of users' likes
        address[] likes;
        // mapping of message id to position in likes array
        mapping(address => uint256) likePointers;
        // total drops in wei
        uint256 dropAmount;
        // addresses of users' drops
        /*address[] drops;
        // mapping of message id to position in drops array
        mapping(address => uint256) dropPointers;*/
        uint[] comments;
  }
   
   mapping (address => Base_Profile) allUsers;
   mapping (uint => Base_Profile) date;
   
    
    uint256[] public messageOrder;
    mapping(uint256 => Message) public messageStructs;
    function getMessageCount() public view returns(uint256 count) {
        return messageOrder.length;
  }
  
   function isUser(address _userAddress) public view returns(bool isIndeed) {
     // if the list is empty, the requested user is not present
        if(allUsers[_userAddress].profile_id == 0){
             return false;
        }
        // true = exists
        return true;
      }
  
  function createMessage(string memory _content) public returns(uint256 index) {
  /*  require(isUser(msg.sender)); */
    require(bytes(_content).length > 0);
   /* require(msg.value >= 0);*/
    uint256 msgId = messageOrder.length;
    messageStructs[msgId].content = _content;
    messageStructs[msgId].writtenBy = msg.sender;
    messageStructs[msgId].timestamp = now;
    messageStructs[msgId].id = msgId;
    messageOrder.push(msgId);
    allUsers[msg.sender].messagePointers[allUsers[msg.sender].messages.push(msgId)-1] = msgId;
    return msgId;
  }
  function isMessageLiker(address _user, uint256 _id) public view returns(bool isIndeed) {
     // if the list is empty, the requested message is not present
    if(messageStructs[_id].likes.length == 0) return false;
    uint256 likerRow = messageStructs[_id].likePointers[_user];
    return (messageStructs[_id].likes[likerRow] == _user);}
    
  function likeMessage(uint256 _id) public returns(uint256 newlikes) {
    require(isUser(msg.sender)); 
    require(_id < messageOrder.length);
    // require that a user can not like a message twice
    require(!isMessageLiker(msg.sender, _id));
    messageStructs[_id].likePointers[msg.sender] = messageStructs[_id].likes.push(msg.sender) - 1;
    // TODO: prolongue timetolive
    return (messageStructs[_id].likes.length);
  }
  function unlikeMessage(uint256 _id) public returns(uint256 newlikes) {
    require(isUser(msg.sender)); 
    require(_id < messageOrder.length);
    require(messageStructs[_id].likes.length > 0);
    // require that a user can not unlike a message twice
    require(isMessageLiker(msg.sender, _id));
    uint256 rowToDelete = messageStructs[_id].likePointers[msg.sender];
    address keyToMove = messageStructs[_id].likes[messageStructs[_id].likes.length-1];
    messageStructs[_id].likes[rowToDelete] = keyToMove;
    messageStructs[_id].likePointers[keyToMove] = rowToDelete;
    delete messageStructs[_id].likePointers[msg.sender];
    return --messageStructs[_id].likes.length;
  }
}