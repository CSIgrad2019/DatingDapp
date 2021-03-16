pragma solidity ^0.5.5;
//pragma experimental ABIEncoderV2;
import "./ProfileMessages.sol";

contract DatingProfileFunctions is ProfileMessages{
    
    event LogUpdateUser(address indexed userAddress, string usersName, string userGender, uint userAge, string userBio, string ipfsHash, uint[] interested_in, bool Active, string update_uri);
    event InactiveUser(uint profile_id, bool Active);
    
    function updateUser( string memory _usersName,
        string memory _userGender, //Currently only Male and Female for end user.
        uint _userAge,
        string memory _userBio,
        string memory _ipfsHash,
        string memory interested_in_female, 
        string memory interested_in_male, 
        string memory interested_in_other,
        string memory _update_uri
        ) public returns(bool success) {
        
        require(isUser(msg.sender), "you are not the user!");    
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
  } 
  
    function InactivateUser(uint profile_id, string memory _update_uri) public returns(bool success) {
        require(isUser(msg.sender)); 
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
}