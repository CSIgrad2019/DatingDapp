pragma solidity ^0.5.5;

import "./DatingProfile.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/drafts/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/ownership/Ownable.sol";

contract DatingCoin is ERC721Full, Ownable, DatingProfile {
    
    constructor() ERC721Full("DatingCoin", "DATE") public {
        
    }
    
    using Counters for Counters.Counter;
    Counters.Counter profile_ids; // This counter will count the amount of profiles/amount of tokens as each profile is a token.
// What a complete profile should look like. (some variables may need to be renamed.)    
    struct Complete_Profile {
        string name;
        uint age;
        string gender; // Modernized gender options.
        uint height;
        uint tier_level;
        Tier2_Profile t2_Profile;
        Tier3_Profile t3_Profile;
    }
    
    struct Tier2_Profile {
        string ethnicity;
        string build; //whether person is athletic, heavy-set or average.
        string languages;
        string zodiac_sign;
        string location;
        string profession;
        string education_level;
    }
    
    struct Tier3_Profile {
        bool kids; //This should be a True or False result for end user.
        string alchohol; // Three option - occassional drinker, dauly drinker or NO.
        string looking_for; // Type of relationship user is looking for (casual, long-term, FWB)
        string religion;
        string interested_in; // Sexual orientation
        string interests; // hobbies other activities 
    }
   
   mapping (uint => Complete_Profile) public date;
   
   function registeredUser(address owner, string memory name, string memory token_uri) public returns(uint) {
        require(age => 18, "To young for dating!");
        profile_ids.increment();
        uint profile_id = profile_ids.current();
        _mint(owner, profile_id); //Not sure if pulling owner form the function is the corret way of doing this.
        _setTokenURI(profile_id, token_uri);
        date[profile_id] = DATE(Ownable); //change vin to what is needed for DATE.
        return profile_id;
    }
    