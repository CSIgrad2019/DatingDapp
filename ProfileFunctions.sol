pragma solidity ^0.5.5;
//pragma experimental ABIEncoderV2;
import "./ProfileMessages.sol";

contract DatingProfileFunctions is ProfileMessages{

    mapping (address => Base_Profile) private allUsers;
    mapping (uint => Base_Profile) private date;
    /*address [] public everyUser;*/
    
    event LogUpdateUser(address indexed userAddress, string usersName, string userGender, uint userAge, string userBio, string ipfsHash, uint[] interested_in, bool Active, string update_uri);
    event InactiveUser(uint profile_id, bool Active);
    
  /*  function isUser(address _userAddress) public view returns(bool isIndeed) {
     // if the list is empty, the requested user is not present
        if(everyUser.length == 0) return false;
        // true = exists
        return (everyUser[allUsers[_userAddress].index] == _userAddress);
      } */
        
   /* function updateUser( string memory _usersName,
        string memory _userGender, //Currently only Male and Female for end user.
        uint _userAge,
        string memory _userBio,
        string memory _ipfsHash,
        string memory interested_in_female, 
        string memory interested_in_male, 
        string memory interested_in_other,
        string memory _update_uri
        ) public returns(bool success) {
        
        require(isUser(msg.sender));     
        require(bytes(interested_in_female).length > 0, "Update field");
        require(bytes(interested_in_male).length > 0, "Update field");
        require(bytes(interested_in_other).length > 0, "Update field");
        require(bytes(_ipfsHash).length > 0, "Update field");
        require(bytes(_userBio).length > 0, "Update field");
        require(_userAge >= 18, "To young for dating!");
        require(bytes(_userGender).length > 0, "Update field");
        
        require (bytes(_userGender).length == 4 || bytes(_userGender).length == 6, "Please type Male or Female");
        
        if (bytes(interested_in_female).length == 3) {
        allUsers[msg.sender].interested_in.push(1);
        } require(bytes(interested_in_female).length == 3 || bytes(interested_in_female).length == 2, "Please type yes or no");
        if (bytes(interested_in_male).length == 3) {
        allUsers[msg.sender].interested_in.push(2);
        } require(bytes(interested_in_male).length == 3 || bytes(interested_in_male).length == 2, "Please type yes or no");
        if (bytes(interested_in_other).length == 3) {
        allUsers[msg.sender].interested_in.push(3);
        } require(bytes(interested_in_other).length == 3 || bytes(interested_in_other).length == 2, "Please type yes or no");
        
        allUsers[msg.sender].usersName = _usersName;
        allUsers[msg.sender].userGender = _userGender;
        allUsers[msg.sender].userAge = _userAge;
        allUsers[msg.sender].userBio = _userBio;
        allUsers[msg.sender].ipfsHash = _ipfsHash;
        allUsers[msg.sender].Active = true; 
        
        emit LogUpdateUser(msg.sender, 
        allUsers[msg.sender].usersName,  
        allUsers[msg.sender].userGender,
        allUsers[msg.sender].userAge,
        allUsers[msg.sender].userBio, 
        allUsers[msg.sender].ipfsHash, 
        allUsers[msg.sender].interested_in, 
        true,
        _update_uri
        );
        return true;
  } */
  
    function InactivateUser(uint profile_id, string memory _update_uri) public returns(bool success) {
      /*  require(isUser(msg.sender)); */
        // this would break referential integrity
        // require(allUsers[msg.sender].messageIds.length <= 0);
        allUsers[msg.sender].Active = false;
        emit InactiveUser(profile_id, allUsers[msg.sender].Active);
        emit LogUpdateUser(msg.sender, 
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
  
    function updateName_Gender( string memory _usersName,  string memory _userGender, string memory _update_uri) public returns(bool) {
         require (bytes(_userGender).length == 4 || bytes(_userGender).length == 6, "Please type Male or Female");
         require(bytes(_usersName).length > 0, "Update field");
         allUsers[msg.sender].usersName = _usersName;
         allUsers[msg.sender].userGender = _userGender;
         emit LogUpdateUser(msg.sender, 
            _usersName,  
            _userGender,
             allUsers[msg.sender].userAge,
             allUsers[msg.sender].userBio, 
             allUsers[msg.sender].ipfsHash, 
            allUsers[msg.sender].interested_in, 
            true,
            _update_uri
            );
            return true;
    }

    function updateAge( uint _userAge, string memory _update_uri) public returns(bool) {
         require(_userAge >= 18, "To young for dating!");
         allUsers[msg.sender].userAge = _userAge;
         emit LogUpdateUser(msg.sender, 
            allUsers[msg.sender].usersName,  
            allUsers[msg.sender].userGender,
            _userAge,
            allUsers[msg.sender].userBio, 
            allUsers[msg.sender].ipfsHash, 
            allUsers[msg.sender].interested_in, 
            true,
            _update_uri
            );
            return true;
    }
    
    function updateBio( string memory _userBio, string memory _update_uri) public returns(bool) {
         require(bytes(_userBio).length > 0, "Update field");
         allUsers[msg.sender].userBio = _userBio;
         emit LogUpdateUser(msg.sender, 
            allUsers[msg.sender].usersName,  
            allUsers[msg.sender].userGender,
            allUsers[msg.sender].userAge,
            _userBio, 
            allUsers[msg.sender].ipfsHash, 
            allUsers[msg.sender].interested_in, 
            true,
            _update_uri
            );
            return true;
    }

    function updatePic( string memory _ipfsHash, string memory _update_uri) public returns(bool) {
         require(bytes(_ipfsHash).length > 0, "Update field");
         allUsers[msg.sender].ipfsHash = _ipfsHash;
         emit LogUpdateUser(msg.sender, 
            allUsers[msg.sender].usersName,  
            allUsers[msg.sender].userGender,
            allUsers[msg.sender].userAge,
            allUsers[msg.sender].userBio, 
            _ipfsHash, 
            allUsers[msg.sender].interested_in, 
            true,
            _update_uri
            );
            return true;
    }
    
    function updateLookingFor(string memory interested_in_female, 
        string memory interested_in_male, 
        string memory interested_in_other,
        string memory _update_uri ) public returns(bool success) {
        
        require(bytes(interested_in_female).length > 0, "Update field");
        require(bytes(interested_in_male).length > 0, "Update field");
        require(bytes(interested_in_other).length > 0, "Update field");
        if (bytes(interested_in_female).length == 3) {
        allUsers[msg.sender].interested_in.push(1);
        } require(bytes(interested_in_female).length == 3 || bytes(interested_in_female).length == 2, "Please type yes or no");
        if (bytes(interested_in_male).length == 3) {
        allUsers[msg.sender].interested_in.push(2);
        } require(bytes(interested_in_male).length == 3 || bytes(interested_in_male).length == 2, "Please type yes or no");
        if (bytes(interested_in_other).length == 3) {
        allUsers[msg.sender].interested_in.push(3);
        } require(bytes(interested_in_other).length == 3 || bytes(interested_in_other).length == 2, "Please type yes or no"); 
  
        emit LogUpdateUser(msg.sender, 
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
    }}