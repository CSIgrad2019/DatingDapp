pragma solidity ^0.5.5;
//pragma experimental ABIEncoderV2;
/*import "./DatingInterestsUpdates.sol";*/
/*import "./ProfileMessages.sol";*/
import "./DatingProfileFunctions.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/drafts/Counters.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/ownership/Ownable.sol";
// import "https://github.com/ConsenSysMesh/openzeppelin-solidity/blob/master/contracts/lifecycle/Pausable.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/math/SafeMath.sol";
//import "https://github.com/zeppelinos/zos-lib/blob/v1.0.0/contracts/migrations/Migratable.sol";

contract DatingCoin is ERC721Full, DatingProfileFunctions {
    
    constructor() ERC721Full("DatingCoin", "DATE") public {
        
    }
    //    using SafeMath for uint256;
    using Counters for Counters.Counter;
    Counters.Counter profile_ids; // This counter will count the amount of profiles/amount of tokens as each profile is a token.
    // What a complete profile should look like. (some variables may need to be renamed.)    

    mapping (address => Base_Profile) private allUsers;
    mapping (uint => Base_Profile) private date;
     
    function EmptyProfile() private pure returns(Base_Profile memory) {
         
        Tier3_Profile memory empty_t3_profile = Tier3_Profile(false, "", "", "", "");
        
        Tier2_Profile memory empty_t2_profile = Tier2_Profile(false, " ", "", "", "", "", "");
        uint[] memory a = new uint[](3);
        uint[] memory b = new uint[](10);
        
        Base_Profile memory user_profile = Base_Profile(0, "", "", 0, "", "", b, a, false, empty_t2_profile,empty_t3_profile);
        
        return (user_profile); 
    }
    
    function registeredUser(address owner) public returns(uint) {
        string memory token_uri = "ipfs://bafybeicqfzuz7dzs22723pv6qnup4tggkv44w4icuhun6mkbngelho2mte";
        profile_ids.increment();
        uint profile_id = profile_ids.current();
        _mint(owner, profile_id); //Not sure if pulling owner form the function is the corret way of doing this.
        _setTokenURI(profile_id, token_uri);
        date[profile_id] = EmptyProfile(); //change vin to what is needed for DATE.
        
        return profile_id;
    }
     
}
