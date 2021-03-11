pragma solidity ^0.5.5;
//pragma experimental ABIEncoderV2;
/*import "./DatingProfile.sol";*/
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/drafts/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/ownership/Ownable.sol";
// import "https://github.com/ConsenSysMesh/openzeppelin-solidity/blob/master/contracts/lifecycle/Pausable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/math/SafeMath.sol";
//import "https://github.com/zeppelinos/zos-lib/blob/v1.0.0/contracts/migrations/Migratable.sol";

contract DatingCoin is ERC721Full, Ownable/*, DatingProfile*/ {
    
    constructor() ERC721Full("DatingCoin", "DATE") public {
        
    }
    //    using SafeMath for uint256;
    using Counters for Counters.Counter;
    Counters.Counter profile_ids; // This counter will count the amount of profiles/amount of tokens as each profile is a token.
    // What a complete profile should look like. (some variables may need to be renamed.)    
    
    struct Tier2_Profile {
        bool smoker; //True or False for end user.
        string alchohol; // Three option - occassional drinker, dauly drinker or NO.
        string ethnicity;
        string languages;
        string zodiac_sign;
        string profession;
        string education_level;
        /*string prompts;*/ //2truths and a lie, favorite foods, etc...
    }
    
    struct Tier3_Profile {
        bool kids; //This should be a True or False result for end user.
        string looking_for; // Type of relationship user is looking for (casual, long-term, FWB)
        string religion; // 3 major religions (Christianity, Islam and Judaism)
        string interests; // hobbies other activities 
        string build; //whether person is athletic, heavy-set or average.
    }
    
    struct Base_Profile {
        uint256 index;
        bytes32 userEmail;
        bytes32 usersName;
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
   
   mapping (address => Base_Profile) private allUsers;
   mapping (address => Tier2_Profile) private t2_Profiles;
   mapping (address => Tier3_Profile) private t3_Profiles;
   mapping (uint => Base_Profile) private date;
   address [] public everyUser;
   
   event LogNewUser   (address indexed userAddress, bytes32 userEmail, bytes32 usersName, string userGender, uint userAge,
   string userBio, string ipfsHash, uint[] interested_in, bool Active, string token_uri, string alchohol, bool kids);
   
   event LogUpdateUser(address indexed userAddress, bytes32 userEmail, bytes32 usersName, string userGender, uint userAge,
   string userBio, string ipfsHash, uint[] interested_in, bool Active, string update_uri, string alchohol, bool kids);
   
   event InactiveUser(uint profile_id, bool Active);
  
    /*function registeredUser(address owner, 
        bytes32 _userEmail,
        bytes32 _usersName,
        uint _userGender, //Currently only Male and Female for end user.
        uint _userAge,
        string memory _userBio,
        string memory _ipfsHash,
        uint messages,
        bool interested_in_female, 
        bool interested_in_male, 
        bool interested_in_other, 
        string memory token_uri) public returns(uint) {
        profile_ids.increment();
        uint profile_id = profile_ids.current();
        _mint(owner, profile_id); //Not sure if pulling owner form the function is the corret way of doing this.
        _setTokenURI(profile_id, token_uri);
        date[profile_id] = Base_Profile(Ownable); //change vin to what is needed for DATE.
        return profile_id;
    }*/
    
    function isValidName(bytes32 _usersName) private pure returns(bool isValid) {
        return (!(_usersName == 0x0));
     }
     
    // we are registering a users profile to the dating coin
    function createUser( address owner,
        bytes32 _userEmail,
        bytes32 _usersName,
        string memory _userGender, //Currently only Male and Female for end user.
        uint _userAge,
        string memory _userBio,
        string memory _ipfsHash,
        string memory interested_in_female, 
        string memory interested_in_male, 
        string memory interested_in_other,
        string memory token_uri,
        /*Tier2_Profile*/string memory _alchohol,
        bool _kids) public returns(uint256) {
            
       /* require(!isUser(msg.sender));*/ 
        require(bytes(interested_in_female).length > 0, "Update field");
//        require(interested_in_female == "True" || interested_in_female == "False", "Enter True or False");
        require(bytes(interested_in_male).length > 0, "Update field");
//        require(interested_in_male == "True" || interested_in_male == "False", "Enter True or False");
        require(bytes(interested_in_other).length > 0, "Update field");
//        require(interested_in_other == "True" || interested_in_other == "False", "Enter True or False");
        require(isValidName(_usersName), "Usersname is taken");
        require(bytes(_ipfsHash).length > 0, "Update field");
        require(bytes(_userBio).length > 0, "Update field");
        require(_userEmail.length > 0, "Update field");
        require(_userAge >= 18, "To young for dating!");
        require(bytes(_userGender).length > 0, "Update field");
        
        allUsers[msg.sender].userEmail = _userEmail;
        allUsers[msg.sender].usersName = _usersName;
        allUsers[msg.sender].userGender = _userGender;
        allUsers[msg.sender].userAge = _userAge;
        allUsers[msg.sender].userBio = _userBio;
        allUsers[msg.sender].ipfsHash = _ipfsHash;
        allUsers[msg.sender].Active = true; 
        // True value: females = 1, males = 2, other = 3
        if (bytes(interested_in_female).length == 3) {
        allUsers[msg.sender].interested_in.push(1);
        } 
        require(bytes(interested_in_female).length == 3 || bytes(interested_in_female).length == 2, "Please type yes or no");
        if (bytes(interested_in_male).length == 3) {
        allUsers[msg.sender].interested_in.push(2);
        }
        require(bytes(interested_in_male).length == 3 || bytes(interested_in_male).length == 2, "Please type yes or no");
        if (bytes(interested_in_other).length == 3) {
        allUsers[msg.sender].interested_in.push(3);
        }
        require(bytes(interested_in_other).length == 3 || bytes(interested_in_other).length == 2, "Please type yes or no");
       
        // now inserting tier2 information
        Tier2_Profile storage t2 = t2_Profiles[msg.sender];
        t2_Profiles.alchohol = _alchohol;
        
        // now inserting tier3 information
        t3_Profiles[msg.sender].kids = _kids;
        
        everyUser.push(msg.sender) - 1;
        
        profile_ids.increment();
        uint profile_id = profile_ids.current();
        _mint(owner, profile_id); //Not sure if pulling owner form the function is the corret way of doing this.
        _setTokenURI(profile_id, token_uri);
        date[profile_id] = Base_Profile(allUsers[msg.sender].index, _userEmail, _usersName, _userGender, _userAge, _userBio, _ipfsHash, allUsers[msg.sender].messages,
        allUsers[msg.sender].interested_in, allUsers[msg.sender].Active, t2_Profiles[msg.sender].alchohol, t3_Profiles[msg.sender].kids);
        
        emit LogNewUser(msg.sender, _userEmail, _usersName, _userGender, _userAge, _userBio, _ipfsHash, allUsers[msg.sender].interested_in,
        allUsers[msg.sender].Active, token_uri, t2_Profiles[msg.sender].alchohol, t3_Profiles[msg.sender].kids);
        
        return profile_id;
       /* return everyUser.length - 1; */
    } 
    
    function isUser(address _userAddress) public view returns(bool isIndeed) {
     // if the list is empty, the requested user is not present
        if(everyUser.length == 0) return false;
        // true = exists
        return (everyUser[allUsers[_userAddress].index] == _userAddress);
      }
    
    function updateUser( bytes32 _userEmail,
        bytes32 _usersName,
        string memory _userGender, //Currently only Male and Female for end user.
        uint _userAge,
        string memory _userBio,
        string memory _ipfsHash,
        string memory interested_in_female, 
        string memory interested_in_male, 
        string memory interested_in_other,
        string memory _update_uri
        ) /*whenNotPaused*/  public returns(bool success) {
        
        require(isUser(msg.sender));     
        require(isValidName(_usersName), "Usersname is taken");
        require(bytes(interested_in_female).length > 0, "Update field");
        require(bytes(interested_in_male).length > 0, "Update field");
        require(bytes(interested_in_other).length > 0, "Update field");
        require(bytes(_ipfsHash).length > 0, "Update field");
        require(bytes(_userBio).length > 0, "Update field");
        require(_userEmail.length > 0, "Update field");
        require(_userAge >= 18, "To young for dating!");
        require(bytes(_userGender).length > 0, "Update field");
        
        if (bytes(interested_in_female).length == 3) {
        allUsers[msg.sender].interested_in.push(1);
        } /*else {
            allUsers[msg.sender].interested_in.push(0);
        }*/ require(bytes(interested_in_female).length == 3 || bytes(interested_in_female).length == 2, "Please type yes or no");
        if (bytes(interested_in_male).length == 3) {
        allUsers[msg.sender].interested_in.push(2);
        }/* else {
            allUsers[msg.sender].interested_in = allUsers[msg.sender].interested_in.push(0);
        }*/ require(bytes(interested_in_male).length == 3 || bytes(interested_in_male).length == 2, "Please type yes or no");
        if (bytes(interested_in_other).length == 3) {
        allUsers[msg.sender].interested_in.push(3);
        } require(bytes(interested_in_other).length == 3 || bytes(interested_in_other).length == 2, "Please type yes or no");
        
        allUsers[msg.sender].userEmail = _userEmail;
        allUsers[msg.sender].usersName = _usersName;
        allUsers[msg.sender].userGender = _userGender;
        allUsers[msg.sender].userAge = _userAge;
        allUsers[msg.sender].userBio = _userBio;
        allUsers[msg.sender].ipfsHash = _ipfsHash;
        allUsers[msg.sender].Active = true; 
        
        emit LogUpdateUser(msg.sender, 
        allUsers[msg.sender].userEmail, 
        allUsers[msg.sender].usersName,  
        allUsers[msg.sender].userGender,
        allUsers[msg.sender].userAge,
        allUsers[msg.sender].userBio, 
        allUsers[msg.sender].ipfsHash, 
        allUsers[msg.sender].interested_in, 
        allUsers[msg.sender].Active,
        _update_uri
        );
        return true;
  }
  
    function InactivateUser(uint profile_id, string memory _update_uri) /*whenNotPaused*/ public returns(bool success) {
        require(isUser(msg.sender)); 
        // this would break referential integrity
        // require(allUsers[msg.sender].messageIds.length <= 0);
        allUsers[msg.sender].Active = false;
        if (date[profile_id].usersName == allUsers[msg.sender].usersName) {
            
        }
        emit InactiveUser(profile_id, allUsers[msg.sender].Active);
        emit LogUpdateUser(msg.sender, 
        allUsers[msg.sender].userEmail, 
        allUsers[msg.sender].usersName,  
        allUsers[msg.sender].userGender,
        allUsers[msg.sender].userAge,
        allUsers[msg.sender].userBio, 
        allUsers[msg.sender].ipfsHash, 
        allUsers[msg.sender].interested_in, 
        allUsers[msg.sender].Active,
        _update_uri
        );
        return allUsers[msg.sender].Active;
    }

    uint256[] private messageOrder;
    mapping(uint256 => Message) private messageStructs;
    function getMessageCount() public view returns(uint256 count) {
        return messageOrder.length;
  }
  function createMessage(string memory _content) public returns(uint256 index) {
    require(isUser(msg.sender));
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